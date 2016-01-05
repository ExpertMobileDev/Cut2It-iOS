//
//  AsynImageView.m
//  BonVitas
//
//  Created by Sayali Doshi on 18/12/12.
//
//

#import "AsynImageView.h"

@implementation AsynImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadImageFromURLString:(NSString *)theUrlString {
    self.image = nil;
    data = nil;
    connection = nil;
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    [urlCache setDiskCapacity:1024*1024*10];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:theUrlString]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:120.0];
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    
    if (response != nil)
    {
        data = [NSMutableData dataWithData:[response data]];
        NSLog(@"response from cache");
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        [urlCache storeCachedResponse:response forRequest:request];
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
        self.image = [UIImage imageWithData:data];
        return;
    }
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    //self.image = [[UIImage alloc] initWithData:data];
    if ((data != nil) && (data.length > 0)) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
        self.image = [UIImage imageWithData:data];
    }    
    //[self setImage:[UIImage imageWithData:data]];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"\n\tError : \n%@",[error description]);
    //self.image = [UIImage imageWithData:nil];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)c
                  willCacheResponse:(NSCachedURLResponse *)response {
	NSLog(@"willCacheResponse");
	return response;
}

// Handle SSL certificate check
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    /*
     if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
     if ([trustedHosts containsObject:challenge.protectionSpace.host])
     */
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
@end
