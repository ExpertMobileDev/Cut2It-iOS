//
//  Cut2itApi.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "Facebook.h"
//#import "TwitterConnect.h"
#import "Reachability.h"

#import "ServerError.h"
#import "Authentication.h"
#import "Media.h"
#import "ImageFile.h"
#import "ImageResource.h"
#import "ImageResourceVersion.h"
#import "Folder.h"
#import "UserProfile.h"
#import "Annotation.h"
#import "User.h"
#import "SimpleIdentifier.h"
#import "ApplicationConfig.h"
#import "MediaRating.h"


//#import "FacebookSDK.h"
#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FaceBookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>


#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

extern NSString *const FBSessionStateChangedNotification;

//374922952600989 --APPID FB

//AAAFUZCY1obZA0BAAGOZB7gkfkFyCYIAMnA7nfMPSJIm4IZAyEGvhR1gk8PCwWVq42j3qOQpXgM31ZBbduSHMVOtvvL6abPmqlAbM5eSUKfgZDZD

typedef enum {
    OpenflameType,
    FacebookType,
    TwitterType
} LoginType;


typedef enum {
    DeleteType,
    CreateType,
    UpdateType,
    LookupType,
    VideoType,
    ImageType
} RequestType;

@protocol APIDelegate <NSObject>
@optional
- (void) logged:(LoginType) type;
- (void) success:(BOOL) success;
- (void) finish:(id) data;
- (void) error:(NSString *) message;
-(void)fbLogged:(LoginType) type;
-(void)hideLoadingView;
- (void)showLoadingView;
@end

@interface Cut2itApi : NSObject</*TwitterConnectDelegate,*/ ASIHTTPRequestDelegate>

//@property (retain, nonatomic) Facebook *facebook;
//@property (retain, nonatomic) TwitterConnect *twitter;
@property (retain, nonatomic) NSString *youtubeUrl;
@property (retain, nonatomic) NSString *youtubeImageUrl;

@property (retain, nonatomic) NSString *openflameUrl;
@property (retain, nonatomic) NSString *gatewayBaseUrl;
@property (retain, nonatomic) NSString *gatewayUrl;
@property (retain, nonatomic) NSString *token;
@property (retain, nonatomic) User *user;
@property (retain, nonatomic) User *userFacebook;
@property (retain, nonatomic) User *userTwitter;
@property (assign, nonatomic) id<APIDelegate> delegate;
@property(nonatomic,retain)NSString *accessToken;
@property (nonatomic,retain)NSString *fbUserName;
@property(assign)BOOL hasProductURL,hasCloseSession;
@property (nonatomic,retain) NSString* videoThumbnailURL;
+ (id) shared;

// For New Twitter Added By Anand HSPL on 07/1/13//
@property (strong, nonatomic) NSCache *usernameCache;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;



//// Added By Anand HSPL on 18/1/13//
-(void)publish;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (BOOL)openSessionWithAllowLoginUIandPublish:(BOOL)allowLoginUI;
- (void) closeSession;
////////
-(NSString*)videoThumbnailString;
- (NetworkStatus) checkConnection;
- (void) facebookLogin;
- (void) fbDidLogin:(NSString *) accessToken;
- (void) twitterLogin;
//- (void) twitterAuthorizationComplete:(OAToken *) oatoken consumer:(OAConsumer *) consumer;
- (void) twitterAuthorizationCompletenew:(NSString *) oatoken consumer:(NSString *) consumerSecret ;//Anand HSPL
- (Authentication *) login:(NSString *)username password:(NSString *)password;
- (void) logout;
- (NSArray *) searchYouTube:(NSString *) term;
- (Media *) loadMedia:(NSNumber *) pk;
- (Media *) loadMediaByVideoId:(NSString *) videoId;
- (void) imageYouTube:(NSString *) videoId name:(NSString *) name delegate:(id<ASIHTTPRequestDelegate>) async;
- (NSURL *) youtubeEncodedUrl:(NSString *) videoId;
- (void) image:(NSString *) lookup delegate:(id<ASIHTTPRequestDelegate>) async;
- (ImageFile *) uploadPhoto:(NSData *) image :(NSString *) userid;
- (Folder *) readFolder:(NSString *) lookup;

- (ImageResource *) createImageResource:(ImageFile *) file name:(NSString *) name parent:(NSNumber *) parentid;
- (UserProfile *) registration:(UserProfile *) profile;

//- (Annotation *) createAnnotation:(Annotation *) annotation;
- (Annotation *) updateAnnotation:(Annotation *) annotation;
- (Annotation *) createAnnotation:(Annotation *) annotation;
//- (Annotation *) shareFacebookAnnotation:(NSString *) fbtoken annotation:(Annotation *) annotation;
//- (Annotation *) shareTwitterAnnotation:(NSString *) key secret:(NSString *)secret annotation:(Annotation *) annotation;
- (Annotation *) shareTwitterAnnotation:(NSString *) key secret:(NSString *)secret annotation:(Annotation *) annotation comment:(NSString*)comment;

- (Annotation *) shareFacebookAnnotation:(NSString *) fbtoken annotation:(Annotation *) annotation comment:(NSString*)fbComment;
- (SimpleIdentifier *) loadTemplate:(NSNumber *) annotationId mediaId:(NSNumber *) mediaId type:(NSString *) type;
- (void) listAnnotation:(NSNumber *) videoId;
- (void) listAnnotationByRoot:(NSNumber *) rootIdAnnotation;

- (void) deleteAnnotation:(NSNumber *) rootIdAnnotation delegate:(id<ASIHTTPRequestDelegate>) async;
- (void) uploadVideo:(NSString *) name data:(NSData *) video delegate:(id<ASIHTTPRequestDelegate>) async;
- (void) mediaLike:(NSNumber *) pk status:(LikeStatus) status;
- (MediaRating *) loadMediaLike:(NSNumber *) pk;

- (NSMutableArray *) dataList:(ASIHTTPRequest *) request bean:(Class)bean;
- (id) data:(ASIHTTPRequest *) request bean:(Class) bean;
- (NSDictionary *) readYoutubeInformation:(ASIHTTPRequest *) request;
- (void) error:(NSString *) message;
//- (NSArray *) starredList;
-(void)starredList;
- (void) starredListWithDelegate:(id)reqDelegate :(int)offset :(int)limit;
- (int) totalStarredWithDelegate:(id)reqDelegate :(int) offset :(int) limit;
- (NSArray *) groupList;
//- (NSArray *) popularList;
-(void)popularList;
- (void) popularListWithDelegate:(id)reqDelegate :(int) offset :(int) limit;
- (void) videoListByUser;
-(void) videoListByUserWithDelegate:(id) reqDelegate;
-(void) videoListByUserWithDelegate:(id)reqDelegate :(int)offset :(int)limit;
- (int) totalvideoListByUserWithDelegate:(id)reqDelegate :(int) offset :(int) limit;
- (NSArray *) followedList;
- (UserProfile *) getUserProfile;
- (void) editUserProfile:(UserProfile *) profile;
- (Media *) createMedia:(Media *) media;
- (void) uploadMedia:(NSData *) data videoId:(NSNumber *) videoId delegate:(id<ASIHTTPRequestDelegate>) async;
- (void) uploadImage:(NSString *)name data:(NSData *) image progress:(id) progress delegate:(id<ASIHTTPRequestDelegate>) async;
- (void) uploadCommentVideo:(NSString *) name  data:(NSData *) video progress:(id) progress delegate:(id<ASIHTTPRequestDelegate>) async;
- (void) imageAttachment:(NSString *) url delegate:(id<ASIHTTPRequestDelegate>) async;

- (int) totalPopularVideosWithDelegate:(id)reqDelegate :(int) offset :(int) limit;
- (int) dataListTotal:(ASIHTTPRequest *) request bean:(Class) bean;
- (Media *) createMediaNewWithAnnotation:(Media *) media :(Annotation *)annotation status:(LikeStatus)status;
- (void) imageThumbnail:(NSString*) url delegate:(id<ASIHTTPRequestDelegate>) async;
@end

@interface NSString (QueryString)

- (NSString *) decodingURLFormat;
- (NSMutableDictionary *) dictionaryFromQueryStringComponents;

@end



