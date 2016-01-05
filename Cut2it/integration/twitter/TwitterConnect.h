//
//  TwitterConnect.h
//  Twitter
//
//  Created by Admin Admin on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterDialog.h"

#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"

#define API_FORMAT						@"json"
#define TWITTER_MAX_MESSAGE_LENGTH      140

@protocol TwitterConnectDelegate;

@interface TwitterConnect : NSObject <TwitterDialogDelegate> {

	NSString * _consumerKey;
	NSString * _consumerSecret;
	
	id<TwitterConnectDelegate> _delegate;
	
	@private
	OAConsumer * _consumer;
	OAToken * _requestToken;
	OAToken * _accessToken;
}

@property (nonatomic, retain) NSString * consumerKey;
@property (nonatomic, retain) NSString * consumerSecret;
@property (nonatomic, assign) id<TwitterConnectDelegate> delegate;

#pragma mark init
- (id)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret;

#pragma mark TwitterConnect
- (void)twitterConnect:(id<TwitterConnectDelegate>) delegate;

#pragma mark TwitterRequest
- (NSString *)queryStringWithBase:(NSString *)base
					   parameters:(NSDictionary *)params 
						 prefixed:(BOOL)prefixed;

- (NSString *)sendRequestWithMethod:(NSString *)method 
                               path:(NSString *)path 
                    queryParameters:(NSDictionary *)params 
                               body:(NSString *)body 
                        requestType:(int)requestType 
                       responseType:(int)responseType;

#pragma mark Twitter
- (NSString *)sendUpdate:(NSString *)status;
- (NSString *)sendUpdate:(NSString *)status inReplyTo:(unsigned long)updateID;
- (void)updateView;
- (void) logout;

@end


@protocol TwitterConnectDelegate<NSObject>

//@required
//- (void) twitterAuthorizationComplete:(OAToken *) token consumer:(OAConsumer *) consumer;
@optional
- (void) onCloseDialog;
- (void) twitterLoginDialogLoaded;
- (void) twitterStatusWasUpdated;
- (void) postOnTwitterError:(NSError *)error;

@end
