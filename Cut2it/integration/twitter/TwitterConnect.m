//
//  TwitterConnect.m
//  Twitter
//
//  Created by Admin Admin on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterConnect.h"

@implementation TwitterConnect

@synthesize consumerKey = _consumerKey;
@synthesize consumerSecret = _consumerSecret;
@synthesize delegate = _delegate;

#pragma mark Twitter

- (NSString *)sendUpdate:(NSString *)status
{
    return [self sendUpdate:status inReplyTo:0];
}

- (NSString *)sendUpdate:(NSString *)status inReplyTo:(unsigned long)updateID
{
    if (!status)
	{
        return nil;
    }
    
    NSString * path = [NSString stringWithFormat:@"statuses/update.%@", API_FORMAT];
    
    NSString * trimmedText = status;
    if ([trimmedText length] > TWITTER_MAX_MESSAGE_LENGTH) 
	{
        trimmedText = [trimmedText substringToIndex:TWITTER_MAX_MESSAGE_LENGTH];
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:trimmedText forKey:@"status"];
    if (updateID > 0) 
	{
        [params setObject:[NSString stringWithFormat:@"%lu", updateID] forKey:@"in_reply_to_status_id"];
    }
    NSString * body = [self queryStringWithBase:nil parameters:params prefixed:NO];
    
    return [self sendRequestWithMethod:@"POST"
								  path:path 
                       queryParameters:params
								  body:body 
                           requestType:0
                          responseType:0];
}


#pragma mark init

- (id)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret
{
	if (self = [super init])
	{
		self.consumerKey = key;
		self.consumerSecret = secret;
		
		_consumer = [[OAConsumer alloc] initWithKey:_consumerKey
											 secret:_consumerSecret];
	}
	return self;
}

- (void)dealloc
{
	[_consumerKey release];
	[_consumerSecret release];
	[super dealloc];
}

#pragma mark -
#pragma mark TwitterConnect

- (void)requestToken
{
	NSLog(@"**********************************************************");
	NSLog(@"******************* REQUEST TOKEN ************************");
	NSLog(@"**********************************************************");
	
	NSURL * url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	OAMutableURLRequest * request = [[[OAMutableURLRequest alloc] initWithURL:url
																	 consumer:_consumer
																		token:nil 
																		realm:nil 
															signatureProvider:nil] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setParameters:[NSArray arrayWithObject:[[[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oob"] autorelease]]];
    
	OADataFetcher * fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
						 delegate:self 
				didFinishSelector:@selector(setRequestToken:withData:) 
				  didFailSelector:@selector(outhTicketFailed:data:)];
}

- (void)authorize
{
	NSLog(@"**********************************************************");
	NSLog(@"********************* AUTHORIZE **************************");
	NSLog(@"**********************************************************");
	
	NSURL * url = [NSURL URLWithString: @"https://api.twitter.com/oauth/authorize"];
	OAMutableURLRequest * request = [[[OAMutableURLRequest alloc] initWithURL:url
																	 consumer:nil
																		token:_requestToken
																		realm:nil
															signatureProvider:nil] autorelease];	
	
	[request setParameters:[NSArray arrayWithObject:[[[OARequestParameter alloc] initWithName:@"oauth_token" value:_requestToken.key] autorelease]]];
	
	TwitterDialog * modalViewController = [[TwitterDialog alloc] initWithRequest:request 
																		delegate:self];
	[modalViewController show];
	[modalViewController release];
}
 

- (void)requestAccessToken {
	NSLog(@"**********************************************************");
	NSLog(@"******************* ACCESS TOKEN *************************");
	NSLog(@"**********************************************************");
	
	NSURL * url = [NSURL URLWithString: @"https://api.twitter.com/oauth/access_token"];
	OAMutableURLRequest * request = [[[OAMutableURLRequest alloc] initWithURL:url
																	 consumer:_consumer
																		token:_requestToken
																		realm:nil
															signatureProvider:nil] autorelease];
	[request setHTTPMethod:@"POST"];
	
    OADataFetcher * fetcher = [[[OADataFetcher alloc] init] autorelease];	
	[fetcher fetchDataWithRequest:request
						 delegate:self 
				didFinishSelector:@selector(setAccessToken:withData:) 
				  didFailSelector:@selector(outhTicketFailed:data:)];
}

- (void)twitterConnect:(id<TwitterConnectDelegate>) delegate
{
	self.delegate=delegate;
	
	if (_accessToken && _consumer) {
		if ([_delegate respondsToSelector:@selector(twitterAuthorizationComplete:consumer:)]) {
			[_delegate twitterAuthorizationComplete:_accessToken consumer:_consumer];
		}
	}
  
	
	[self requestToken];
}

#pragma mark TwitterRequest

- (NSString *)encodeString:(NSString *)string
{
    NSString * result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}

- (NSString *)queryStringWithBase:(NSString *)base
					   parameters:(NSDictionary *)params 
						 prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString * str = [NSMutableString stringWithCapacity:0];
    if (base) 
	{
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) 
	{
        int i;
        NSArray * names = [params allKeys];
        for (i = 0; i < [names count]; i++) 
		{
            if (i == 0 && prefixed) 
			{
                [str appendString:@"?"];
            }
			else if (i > 0)
			{
                [str appendString:@"&"];
            }
            NSString * name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}

- (NSString *)sendRequestWithMethod:(NSString *)method
                               path:(NSString *)path 
                    queryParameters:(NSDictionary *)params 
                               body:(NSString *)body 
                        requestType:(int)requestType 
                       responseType:(int)responseType
{
    NSString * fullPath = path;	
    NSString * urlString = [NSString stringWithFormat:@"http://api.twitter.com/%@", fullPath];
    NSURL * finalURL = [NSURL URLWithString:urlString];
	
	if (!finalURL)
	{
        return nil;
    }
	
	OAMutableURLRequest *theRequest = [[[OAMutableURLRequest alloc] initWithURL:finalURL
																	   consumer:_consumer 
																		  token:_accessToken 
																		  realm:nil
															  signatureProvider:nil] autorelease];
    if (method) 
	{
        [theRequest setHTTPMethod:method];
    }
    [theRequest setHTTPShouldHandleCookies:NO];
    
    // Set the request body if this is a POST request.
    BOOL isPOST = (method && [method isEqualToString:@"POST"]);
    if (isPOST)
	{
        // Set request body, if specified (hopefully so), with 'source' parameter if appropriate.
        NSString * finalBody = @"";
		if (body) 
		{
			finalBody = [finalBody stringByAppendingString:body];
		}
        
        if (finalBody) 
		{
            [theRequest setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
	
	// --------------------------------------------------------------------------------
	// modificaiton from the base clase
	// our version "prepares" the oauth url request
	// --------------------------------------------------------------------------------
	[theRequest prepare];
	
	[NSURLConnection connectionWithRequest:theRequest delegate:self];
	return nil;
}





- (void)updateView
{
	NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TwitterUpdate" ofType:@"html"] isDirectory:NO]];
	
	TwitterDialog * modalViewController = [[TwitterDialog alloc] initWithRequest:request 
																		delegate:self];
	[modalViewController show];
	[modalViewController release];
}

#pragma mark -
#pragma mark OADataFetcherDelegate

- (void)setRequestToken:(OAServiceTicket *)ticket withData:(NSData *)data
{
	NSString * dataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"setRequestToken, %@", dataString);
	
	[_requestToken release];
	_requestToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
	
	[self authorize];
 
}

- (void)setAccessToken:(OAServiceTicket *)ticket withData:(NSData *)data
{
	if (!ticket.didSucceed || !data) return;
	NSString * dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	NSLog(@"setAccessToken, %@", dataString);
	
	[_accessToken release];
	_accessToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
	
	if ([_delegate respondsToSelector:@selector(twitterAuthorizationComplete:consumer:)]) {
		[_delegate twitterAuthorizationComplete:_accessToken consumer:_consumer];
    }
}

- (void)outhTicketFailed:(OAServiceTicket *)ticket data:(NSError *)error
{
	NSLog(@"outhTicketFailed, %@", error);
	if ([_delegate respondsToSelector:@selector(postOnTwitterError:)]) {
		[_delegate postOnTwitterError:error];
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	if ([_delegate respondsToSelector:@selector(twitterLoginDialogLoaded)]) {
		[_delegate twitterLoginDialogLoaded];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *url=[[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	if ([url rangeOfString:@"/feed"].location != NSNotFound) {
		NSString *status=[url stringByReplacingOccurrencesOfString:@"file:///feed?" withString:@""];
		[self sendUpdate:status];
		return YES;
	}
	NSLog(@"=========================== webView : shouldStartLoadWithRequest ===========================");
	NSLog(@"%@", url);
	NSLog(@"=================================================================================");

	return TRUE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"=========================== webView : didFailLoadWithError ===========================");
	NSLog(@"error = %@", error);
	NSLog(@"=================================================================================");
	if ([_delegate respondsToSelector:@selector(postOnTwitterError:)]) {
		[_delegate postOnTwitterError:error];
    }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSString * dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"=========================== connection : didReceiveData ===========================");
	NSLog(@"%@", dataString);
	NSLog(@"=================================================================================");
	if ([_delegate respondsToSelector:@selector(twitterStatusWasUpdated)]) {
		[_delegate twitterStatusWasUpdated];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"=========================== connection : didFailWithError ===========================");
	NSLog(@"error = %@", error);
	NSLog(@"=================================================================================");
	if ([_delegate respondsToSelector:@selector(postOnTwitterError:)]) {
		[_delegate postOnTwitterError:error];
    }
}

- (void) onCloseDialog{
 	if ([_delegate respondsToSelector:@selector(onCloseDialog)]) {
		[_delegate onCloseDialog];
    }	
}

- (void) logout {
   _accessToken=nil;
   [_accessToken release];
   // _consumer =nil;
   // [_consumer release];
	_requestToken = nil;
    [_requestToken release];
}

@end
