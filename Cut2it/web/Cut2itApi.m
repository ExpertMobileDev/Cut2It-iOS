 //
//  Cut2itApi.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//sasha.maksimenko@gmail.com

#import "Cut2itApi.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "VideoViewController.h"
#import "Util.h"
//#import "SBJSON.h"

NSString *const FBSessionStateChangedNotification =
@"com.tesnew.app:FBSessionStateChangedNotification";

//Bd4qFTELB8BLzMcg1ODiw
//muZDXsbUpKxm7CWQ9ABiK6SRbnsqCNkcf2RZ6HMcqs


@implementation Cut2itApi

static Cut2itApi *instance;

//@synthesize facebook;
//@synthesize twitter;
@synthesize youtubeUrl;
@synthesize youtubeImageUrl;
@synthesize openflameUrl;
@synthesize gatewayBaseUrl;
@synthesize gatewayUrl;
@synthesize token;
@synthesize user;
@synthesize userFacebook;
@synthesize userTwitter;
@synthesize delegate;
@synthesize accessToken;
@synthesize hasCloseSession;
@synthesize fbUserName;
@synthesize videoThumbnailURL;
@synthesize imageCache = _imageCache;
@synthesize usernameCache = _usernameCache;
@synthesize accounts = _accounts;
@synthesize accountStore = _accountStore;

#pragma mark FaceBook Anand

-(NSString*)videoThumbnailString{
    NSLog(@"videoThumbnailURL");
    NSString *url = videoThumbnailURL;
    NSLog(@"imageYouTube_URL:%@",url);
    return url;
}



-(void)getFBUserInfo{
    NSLog(@"getFBUserInfo");
    
    if (FBSession.activeSession.isOpen) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"SessionOpen" forKey:@"KcheckSession"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"sessionStateChanged:isOpen123:%@",FBSession.activeSession.appID);
        //Added by saumiya
        [FBRequest requestForMe].session = [FBSession activeSession];
        //EOF
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *_user,
           NSError *error) {
             if (!error) {
                 // self.fbuserDict = user;
                 NSLog(@"user.name:%@",_user.name);
                 NSLog(@"user.id:%@",_user.id);
                 NSLog(@"user.Loc_ation:%@",_user.location);
                 NSString *taccessToken =  [[FBSession activeSession] accessToken];
                 self.accessToken = taccessToken;
                 self.fbUserName = _user.name;
                 if(self.accessToken){
                     NSLog(@"fbDidLogin:%@",accessToken);
                     NSLog(@"user.first_name:%@",_user.first_name);
                     NSLog(@"user.last_name:%@",_user.last_name);
                     [[NSUserDefaults standardUserDefaults] setValue:_user.first_name forKey:@"fbuserFirstName"];
                     [[NSUserDefaults standardUserDefaults] setValue:_user.last_name forKey:@"fbuserlastName"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     //[Util setProperties:FACEBOOK_Firstname value:userFacebook.firstName];
                     //[Util setProperties:FACEBOOK_Lastname value:userFacebook.lastName];
                     //[Util setProperties:_user.last_name value:FACEBOOK_Lastname];
                     [self fbDidLogin:accessToken];
                     
                 }
                 // NSLog(@"user:image:%@",user.);
                 
                 NSString *fbuid= _user.id;
                 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https:/graph.facebook.com/%@/picture?type=large", fbuid]];
                 NSData *data = [NSData dataWithContentsOfURL:url];
                 UIImage *image = [UIImage imageWithData:data];
                 NSLog(@"image:%@",image);
                 [[NSUserDefaults standardUserDefaults] setObject:_user.id forKey:@"kFacebookAccountTypeKey"];
                 [[NSUserDefaults standardUserDefaults] synchronize];

             }
         }];
        
    } else {
        NSLog(@"sessionStateChanged:NOOOO");
        //[Util removeProperties:FACEBOOK_USERNAME];
       // [Util removeProperties:FACEBOOK];
    }    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                [self getFBUserInfo];
                NSLog(@"User session found");
                [FBSession setActiveSession:session];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    hasCloseSession = NO;
    
    if(IPHONE_5)
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email",
                                @"user_likes",
                                nil];
        return [FBSession openActiveSessionWithReadPermissions:permissions
                                                  allowLoginUI:allowLoginUI
                                             completionHandler:^(FBSession *session,
                                                                 FBSessionState state,
                                                                 NSError *error) {
                                                 [self sessionStateChanged:session
                                                                     state:state
                                                                     error:error];
                                             }];
    }
    else{
       
        return [FBSession openActiveSessionWithReadPermissions:nil
                                                  allowLoginUI:allowLoginUI
                                             completionHandler:^(FBSession *session,
                                                                 FBSessionState state,
                                                                 NSError *error) {
                                                 [self sessionStateChanged:session
                                                                     state:state
                                                                     error:error];
                                             }];
    }
    
}

/*
 *
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
    [Util removeProperties:FACEBOOK_USERNAME];
    [Util removeProperties:FACEBOOK];
}



+ (id) shared {
   
    @synchronized([Cut2itApi class]) {
        if (!instance) {
            instance = [[self alloc] init];
            instance.openflameUrl = [NSString stringWithFormat:@"%@/openflame", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            
            /*
            instance.gatewayBaseUrl = [NSString stringWithFormat:@"%@/cut2it", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            instance.gatewayUrl = [NSString stringWithFormat:@"%@/cut2it/rest", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            //instance.gatewayUrl = [NSString stringWithFormat:@"%@/rest", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            NSArray *configs = [instance loadConfig];           
             */
            
            
            //// Changes for Production Server ///
            instance.gatewayBaseUrl = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            instance.gatewayUrl = [NSString stringWithFormat:@"%@/rest", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            //instance.gatewayUrl = [NSString stringWithFormat:@"%@/rest", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"url"]];
            NSArray *configs = [instance loadConfig];
            
            ////// Changes End ////
            
            
            
//            instance.facebook = [[Facebook alloc] initWithAppId:[Cut2itApi value:configs key:@"FACEBOOK_CONSUMER_KEY"]];
            /*
            instance.twitter  = [[TwitterConnect alloc] initWithConsumerKey:[Cut2itApi value:configs key:@"TWITTER_CONSUMER_KEY"] consumerSecret:[Cut2itApi value:configs key:@"TWITTER_CONSUMER_SECRET"]];
             */
            instance.youtubeUrl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"youtubeURL"];
            instance.youtubeImageUrl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"youtubeImageURL"];
            
            [configs release];
        }
        return instance;
    }
    
    return nil;
}

- (void) dealloc {
    //[facebook release];
    //[twitter release];
    [youtubeUrl release];
    [youtubeImageUrl release];
    [openflameUrl release];
    [gatewayBaseUrl release];
    [gatewayUrl release];
    [token release];
    [user release];
    [userFacebook release];
    [userTwitter release];
    
    [super dealloc];
}



+ (NSString *) value:(NSArray *) list key:(NSString *) key {
    for (ApplicationConfig *item in list) {
        if ([item.name isEqualToString:key]) {
            return item.value;
        }
    }
    return nil;
}

- (NSArray *) loadConfig {
   // NSString *url = [Util append:gatewayUrl, @"/application/configs/global", nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/application/configs/global", nil]; //http://96.241.223.72:9090 (Flash Server)
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    
    return [self dataList:request bean:[ApplicationConfig class]];
}

- (void) facebookLogin {
    //[facebook authorize:[NSArray arrayWithObjects:@"publish_stream",@"email",nil] delegate:self];
}

- (Authentication *) login:(NSString *)username password:(NSString *)password {
    
    //NSString *url = [Util append:openflameUrl, @"/rest/authority/sts/sign-in", nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/authority/sts/sign-in", nil]; //http://96.241.223.72:9090 (Flash Server)
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"user-name" value:username];
    [request addRequestHeader:@"password" value:password];    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:30];
    //request.shouldAttemptPersistentConnection = NO; // For Connection Failure error in iOS for ASIHttpRequest
    [request startSynchronous];
    
    
    return [self data:request bean:[Authentication class]];
}

- (void) logout {
    self.token = nil;
    //self.facebook.accessToken = nil;
    self.user = nil;
    self.userFacebook = nil;
    self.userTwitter = nil;
    //[self.twitter logout];
    
    [Util removeProperties:PASSWORD];
    [Util removeProperties:FACEBOOK_USERNAME];
    [Util removeProperties:FACEBOOK];
    //[Util removeProperties:FACEBOOK_Firstname];
    //[Util removeProperties:FACEBOOK_Lastname];
    [Util removeProperties:TWITTER_KEY];
    [Util removeProperties:TWITTER_SECRET];
    [Util removeProperties:TWITTER_USERNAME];
    [Util removeProperties:TWITTER_USER];
    [Util removeProperties:SEARCH];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbuserFirstName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbuserlastName"];
    
    
    //NSString *url = [Util append:openflameUrl, @"/console/logout", nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/authority/logout", nil]; // Flash Server API
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setRequestMethod:@"POST"]; //Flash Server
    //request.shouldAttemptPersistentConnection = NO; // For Connection Failure error in iOS for ASIHttpRequest
    [request startSynchronous];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if([[cookie domain] rangeOfString:@"facebook"].location != NSNotFound) {
            [storage deleteCookie:cookie];
        }
        if([[cookie domain] rangeOfString:@"twitter"].location != NSNotFound) {
            [storage deleteCookie:cookie];
        }
    }    
}

- (NSArray *) searchYouTube:(NSString *) term {
    
    NSString* escaped_value = (NSString *) CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL, /* allocator */
                                                                                   (CFStringRef)term,
                                                                                   NULL, /* charactersToLeaveUnescaped */
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8);
    
    
    //NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/search-by-phrase?phrase=", escaped_value, nil];//http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/search-by-phrase?phrase=", escaped_value, nil]; //http://96.241.223.72:9090 (Flash Server)
    
    [escaped_value release];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    return [self dataList:request bean:[Media class]];
}

// Used For playing media, when user clicks on mobile link in email. 
- (Media *) loadMedia:(NSString *) pk {
   // NSString *url = [Util append:gatewayUrl, @"/video/media/", [pk stringValue], nil]; //http://www.cut2it.com    
    NSString *url = [Util append:gatewayUrl, @"/video/media/", pk, nil]; //flash server
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
   // [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    return [self data:request bean:[Media class]];
}


- (Media *) loadMediaByVideoId:(NSString *) videoId {
    NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/read-by-video-id/", videoId, nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    return [self data:request bean:[Media class]];
}


// Videos uploaded by user (Library)
-(void) videoListByUserWithDelegate:(id)reqDelegate :(int)offset :(int)limit
{
    //NSString *url = [Util append:gatewayUrl, @"/video/media/recent", nil];// http://www.cut2it.com
    
    NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/recent?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil]; // http://96.241.223.72:9090 Flash url
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate=reqDelegate;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request setResponseClass:[Media class]];     
    [request startAsynchronous];
}

// For lazy loading and enable paging. Returns count of videos
- (int) totalvideoListByUserWithDelegate:(id)reqDelegate :(int) offset :(int) limit
{
    NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/recent?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //request.delegate = reqDelegate;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    //[request setResponseClass:[Media class]];
    [request startSynchronous];
    return [self dataListTotal:request bean:[Media class]];
}

- (NSArray *) followedList{
    
    NSString *url = [Util append:gatewayUrl, @"/video/media/followed-video", nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
   // [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    
    return [self dataList:request bean:[Media class]];
}

//- (NSArray *) starredList{
- (void) starredList{
    //NSString *url = [Util append:gatewayUrl, @"/video/media/starred", nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/video/media/starred", nil]; //http://96.241.223.72:9090 flash server url
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request setResponseClass:[Media class]];
    [request startAsynchronous];
    
    //return [self dataList:request bean:[Media class]];
}

// To resolve delegate issue
- (void) starredListWithDelegate:(id)reqDelegate :(int)offset :(int)limit{
    //NSString *url = [Util append:gatewayUrl, @"/video/media/starred", nil]; //http://www.cut2it.com
    NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/starred?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request setResponseClass:[Media class]];    
    [request startAsynchronous];
}

// For lazy loading and enable paging. Returns count of videos
- (int) totalStarredWithDelegate:(id)reqDelegate :(int) offset :(int) limit
{
    NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/starred?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //request.delegate = self;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    //[request setResponseClass:[Media class]];
    [request startSynchronous];
    return [self dataListTotal:request bean:[Media class]];
}

- (NSArray *) groupList{
    
    NSString *url = [Util append:gatewayUrl, @"/video/media/from-group", nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    return [self dataList:request bean:[Media class]];
}

//- (NSArray *) popularList{
- (void) popularList{
    //NSString *url = [Util append:gatewayUrl, @"/video/media/popular", nil]; //http://www.cut2it.com    
    //NSString *url = [Util append:gatewayUrl, @"/video/media/popular", nil]; //http://96.241.223.72:9090 (Flash Server)
    NSString *url = [Util append:gatewayUrl, @"/video/media/popular", nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
   // [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request setResponseClass:[Media class]];
    [request startAsynchronous];
    
    //return [self dataList:request bean:[Media class]];    
}

// For lazy loading and enable paging.
- (void) popularListWithDelegate:(id)reqDelegate :(int) offset :(int) limit{
    NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/popular?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil]; // http://96.241.223.72:9090 Flash url
   
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    self.delegate = reqDelegate;
    request.delegate = reqDelegate;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
   // [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request setResponseClass:[Media class]];
    [request startAsynchronous];    
    //return [self dataList:request bean:[Media class]];
}

// For lazy loading and enable paging.
- (int) totalPopularVideosWithDelegate:(id)reqDelegate :(int) offset :(int) limit{
     NSString *str_url=[[NSString alloc]initWithFormat:@"/video/media/popular?limit=%i&&offset=%i", limit, offset];
    NSString *url = [Util append:gatewayUrl, str_url, nil];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //request.delegate = self;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
  //  [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    return [self dataListTotal:request bean:[Media class]];
}


- (void) imageYouTube:(NSString *) videoId name:(NSString *) name delegate:(id<ASIHTTPRequestDelegate>) async {
    //$src = "http://img.youtube.com/vi/".$video_id."/default.jpg";
    //http://img.youtube.com/vi/niUDUp1TAvA/default.jpg
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *url = [Util append:youtubeImageUrl, @"/",videoId,@"/", name, nil];
    NSLog(@"imageYouTube_URL:%@",url);
    self.videoThumbnailURL = url;
    appDelegate.videoUrl = self.videoThumbnailURL;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [request setRequestMethod:@"GET"];
    [request setDelegate:async];
    [request startAsynchronous];
}

// Bhavya - 08th Aug 2013 (Method to get bytes from the image url)
- (void) imageThumbnail:(NSString*) url delegate:(id<ASIHTTPRequestDelegate>) async {
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"imageBytesYouTubeThumbnail_URL:%@",url);
    self.videoThumbnailURL = url;
    appDelegate.videoUrl = self.videoThumbnailURL;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [request setRequestMethod:@"GET"];
    [request setDelegate:async];
    [request startAsynchronous];
}

// Not in use after flash server. Server team has removed this method. 21st May 2013
- (void) image:(NSString *) lookup delegate:(id<ASIHTTPRequestDelegate>) async {
    
    [async retain];
    // NSString *url = [Util append:openflameUrl, @"/rest/content/resource/image/stream/",lookup,nil];
   // NSString *url = [Util append:gatewayBaseUrl, @"/rest/content/resource/image/stream/",lookup,nil]; // Flash Site Url
    
    NSString *url = [[NSString stringWithFormat:@"http://96.241.223.72:9090/userProfile/default.jpg", nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag= LookupType;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
   // [request setUseCookiePersistence:NO];
    [request setDelegate:async];
    [request startAsynchronous];
    
}

- (void) imageAttachment:(NSString *) url delegate:(id<ASIHTTPRequestDelegate>) async {

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag= LookupType;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
   // [request setUseCookiePersistence:NO];
    [request setDelegate:async];
    [request startAsynchronous];
    
}

// Upload Profile pic
- (ImageFile *) uploadPhoto:(NSData *) image :(NSString *) userid {
    
    NSString *str_url=[[NSString alloc]initWithFormat:@"/profile/upload?userId=%@", userid];
    NSString *url = [Util append:gatewayUrl, str_url, nil];
    
   // NSString *url = [Util append:gatewayUrl, @"/profile/upload",nil]; // flash server
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addData:image withFileName:@"avatar.png" andContentType:@"image/png" forKey:@"file"];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    
    return [self data:request bean:[ImageFile class]];
}



- (Folder *) readFolder:(NSString *) lookup {
    NSString *url = [Util append:openflameUrl, @"/rest/content/folder/list-by-lookup/", lookup, nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    
    return [self data:request bean:[Folder class]];
}

- (ImageResource *) createImageResource:(ImageFile *) file name:(NSString *) name parent:(NSNumber *) parentid {
    NSString *url = [Util append:openflameUrl, @"/rest/content/resource/image", nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    ImageResource *resource = [[ImageResource alloc] init];
    resource.name = name;
    resource.parentId = parentid;
    
    ImageResourceVersion *imageVersion = [[ImageResourceVersion alloc] init];
    imageVersion.title = name;
    imageVersion.culture = @"AMERICAN";
    imageVersion.width = file.width;
    imageVersion.height = file.height;
    imageVersion.resourceFileOriginalName = file.orgFilename;
    imageVersion.resourceFileTemporaryName = file.filename;
    
    resource.resourceVersion = imageVersion;
    [imageVersion release];
    
    NSString *json = [Util serialize:resource];
    [resource release];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    
    return [self data:request bean:[ImageResource class]];
}

- (UserProfile *) registration:(UserProfile *) profile {
    
    //http://www.cut2it.com/rest/profile/user-profile/register-open-flame-user
    
    //http://dev.cut2it.firejack.net:8080/cut2it/rest/profile/user-profile/register-open-flame-user
    //http://dev1.cut2it.com/cut2it/rest/profile/user-profile/register-open-flame-user
    
    //NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/register-open-flame-user", nil]; // http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/register", nil]; //http://96.241.223.72:9090 (Flash Server)
    
    //NSString *finalUrl = [self stringWithPercentEscape:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *json = [Util serialize:profile];
    
    [request setRequestMethod:@"POST"];
    request.shouldAttemptPersistentConnection = NO; // For Connection Failure error in iOS for ASIHttpRequest
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeOutSeconds:30];
    request.shouldAttemptPersistentConnection = NO; // For Connection Failure error in iOS for ASIHttpRequest
    
    [request startSynchronous];
    
    return [self data:request bean:[UserProfile class]];
}

- (NSString*)stringWithPercentEscape:(NSString*)urlStr {
    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[urlStr mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}

// Save the user profile after user edits it in Settings Tab.
-(void) editUserProfile:(UserProfile *) profile {
    NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/",profile.pk , nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:profile];
    
    [request setRequestMethod:@"PUT"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setResponseClass:[UserProfile class]];
    [request setDelegate:self];
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}
/*
 -(SimpleIdentifier *) editUserProfile:(UserProfile *) profile {
 NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/",[profile.pk stringValue] , nil];
 
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
 
 NSString *json = [Util serialize:profile];
 
 [request setRequestMethod:@"PUT"];
 [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
 [request setUseCookiePersistence:NO];
 [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
 [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
 [request startSynchronous];
 return [self data:request bean:[SimpleIdentifier class]];
 }
 */

- (UserProfile *) getUserProfile
{
    //NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/current", nil]; //http://www/cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/profile/user-profile/current", nil]; // flash server
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    
    return [self data:request bean:[UserProfile class]];
    
}

- (NSURL *) youtubeEncodedUrl:(NSString *) videoId {
    NSString *url = [Util append:youtubeUrl, @"/get_video_info?video_id=", videoId, @"&el=embedded&ps=default&hl=en_US&eurl=http://youtube.com",nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    NSDictionary *dic = [self readYoutubeInformation:request];
    
    NSString *reason = [dic objectForKey:@"reason"];
    if (reason) {
        [self error:reason];
        return nil;
    }
    
    NSURL *result = [NSURL URLWithString:[dic objectForKey:@"medium"]];
    if (!result) {
        result =  [NSURL URLWithString:[dic objectForKey:@"large"]];
    }
    if (!result) {
        result = [NSURL URLWithString:[dic objectForKey:@"medium"]];
    }
    return result;
}


- (Annotation *) createAnnotation:(Annotation *) annotation {
    NSLog(@"Create Anno");
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation", nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/video/annotation", nil]; //Flash url
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *json = [Util serialize:annotation];
    //json = [NSString stringWithFormat:@"{\"data\": {\"annotationType\":\"TEXT\", \"content\": \"Nice\",         \"endTime\": \"235\",\"imageAttachments\": [ ],  \"markedArea\": \"type=988563905;time=0.000000;x=0.000000;y=0.000000;width=0.000000;height=0.000000;angle=0.001803\", \"mediaId\": \"402881283e82d009013e82e2df730065\",  \"mediaVideoId\": \"w6ek5FCRI_4\",  \"startTime\": \"0\",  \"videoAttachments\": [ ]       }   }" ,nil];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    
    return [self data:request bean:[Annotation class]];
}

- (Annotation *) updateAnnotation:(Annotation *) annotation {
    NSLog(@"Update Anno");
   // NSString *url = [Util append:gatewayUrl, @"/video/annotation/",[annotation.pk stringValue], nil]; //http://www.cut2it.com
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/",annotation.pk, nil]; //Flash url
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *json = [Util serialize:annotation];
    
    [request setRequestMethod:@"PUT"];
    [request setTimeOutSeconds:30];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
 
    return [self data:request bean:[Annotation class]];
}


- (SimpleIdentifier *) loadTemplate:(NSString *) annotationId mediaId:(NSString *) mediaId type:(NSString *) type {
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/load-template-by-type?templateType=", type, nil];
    if (annotationId) {        
        url = [Util append:url,@"&annotationId=",annotationId];
    }
    if (mediaId) {
        url = [Util append:url,@"&mediaId=",mediaId];
    }
     
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request startSynchronous];
    
    return [self data:request bean:[SimpleIdentifier class]];
}

/*
- (Annotation *) shareFacebookAnnotation:(NSString *) fbtoken annotation:(Annotation *) annotation {
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-facebook?facebookAuthToken=", fbtoken, nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:annotation];
    NSLog(@"json_FB:%@",json);
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    [request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    
    return [self data:request bean:[Annotation class]];
}
 */



- (Annotation *) shareFacebookAnnotation:(NSString *) fbtoken annotation:(Annotation *) annotation comment:(NSString*)fbComment {
    
    NSString *fbuser= [Util getProperties:FACEBOOK_USERNAME];
    NSLog(@"fbuser:%@",fbuser);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *privacy= @"SELF";
    //NSString *comment = appDelegate.faceBookComment;
    
   // NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-facebook?facebookAuthToken=", fbtoken,@"&privacy=",privacy, @"&comment=",fbComment,nil]; //http://www.cut2it.com
    
    
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-facebook?facebookAuthToken=", fbtoken,@"&privacy=",privacy, @"&comment=",fbComment,nil]; // Flash Server
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlFBPost:%@",url);
    
    NSString *firstName =[[NSUserDefaults standardUserDefaults] objectForKey:@"fbuserFirstName"];
    NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbuserlastName"];
    // NSString *hello = @"data";    
    
    NSMutableString *myJSON= [NSMutableString stringWithString:@"{ \"data\" :"];
    
    [myJSON appendString: [NSString stringWithFormat: @"{ \"id\" : \"%@\", \"firstName\" : \"%@\", \"lastName\" : \"%@\" }}",
                           appDelegate.pk, firstName, lastName]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    //NSString *json = [Util serialize:finalDic];
    NSLog(@"json_FB:%@",myJSON);
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    //[request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request appendPostData:[myJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    NSLog(@"ResponseStatus Code: %d %@", request.responseStatusCode, request.responseStatusMessage);
    return [self data:request bean:[Annotation class]];
}

//http://www.cut2it.com/rest/video/annotation/share-to-twitter?twitterAuthToken=1198397670-IIZfXdj8jZteITdtg3wBaY5kwpmLcSadKr1t82x&twitterTokenSecret=k6aLm8UlarghAXNCqwFOqREFjLKrZt88kR8CgFPWac&comment=Test%20comment
/*
- (Annotation *) shareTwitterAnnotation:(NSString *) key secret:(NSString *)secret annotation:(Annotation *) annotation {
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-twitter?twitterAuthToken=", key, @"&twitterTokenSecret=", secret, nil];
    
     NSString *comment = @"HEllo ALL Twitter";
    
     NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-twitter?twitterAuthToken=", key, @"&twitterTokenSecret=", secret,@"&comment=",comment, nil];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlTwitterPost:%@",url);

    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:annotation];
    

    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    [request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
   
    
    return [self data:request bean:[Annotation class]];
}*/

- (Annotation *) shareTwitterAnnotation:(NSString *) key secret:(NSString *)secret annotation:(Annotation *) annotation comment:(NSString*)comment{
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-twitter?twitterAuthToken=", key, @"&twitterTokenSecret=", secret, nil];
    
   // NSString *comment = @"HEllo ALL Twitter";
    
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-twitter?twitterAuthToken=", key, @"&twitterTokenSecret=", secret,@"&comment=",comment, nil]; //http://www.cut2it.com
       
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/share-to-twitter?twitterAuthToken=", key, @"&twitterTokenSecret=", secret,@"&comment=",comment, nil]; //Flash Server
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlTwitterPost:%@",url);
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:annotation];
    
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    
    
    return [self data:request bean:[Annotation class]];

}


- (void) listAnnotation:(NSNumber *) mediaId {
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/by-video-id/", videoId, nil]; //http://www.cut2it.com
    
    //old api for cloud. It returns all the annotion with and without content
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/by-video-id/", mediaId, nil]; //Flash Server
    
    
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/by-video-id-mobile/", mediaId, nil];

    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setResponseClass:[Annotation class]];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) listAnnotationByRoot:(NSNumber *) rootIdAnnotation {
    //NSString *url = [Util append:gatewayUrl, @"/video/annotation/all-by-root?rootAnnotationId=", [rootIdAnnotation stringValue], nil];
    
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/all-by-root?rootAnnotationId=", rootIdAnnotation, nil]; //Flash Server Url
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request setResponseClass:[Annotation class]];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void) deleteAnnotation:(NSString *) rootIdAnnotation delegate:(id<ASIHTTPRequestDelegate>) async{
    [async retain];
    NSString *url = [Util append:gatewayUrl, @"/video/annotation/", rootIdAnnotation, nil]; //Flash Server Url
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag = DeleteType;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setRequestMethod:@"DELETE"];
    [request setDelegate:async];
    [request startAsynchronous];
    
    
   // return [self dataList:request bean:[Annotation class]];
}

// Bhavya - Create Media new = Create media + create annotation + update like/flag (flag means unlike)
- (Media *) createMediaNewWithAnnotation:(Media *)media :(Annotation *)annotation status:(LikeStatus)status
{
    // Convert annotation object in format given by client    
    
    NSString *url = [Util append:gatewayUrl, @"/video/media", nil];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:media];    
        
    // Create annotation array
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *content = @"";
    NSString *begin = @"";
    NSString *end = @"";
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    //when the video is recorder by device, no annotation detail will be passed to server. So this check "annotation!=nil" is done.
    if(annotation!=nil)
    {
        content = annotation.content;
        begin = [Util timeFormat:annotation.begin];
        end = [Util timeFormat:annotation.end];
        // Convert startTime's value to seconds
        NSNumber *numBegin = [Util dateToSecondConvert:begin];
        [Util add:dic value:numBegin key:@"startTime"];
        [Util add:dic value:content key:@"content"];
        // Convert endTime's value to seconds
        NSNumber *numEnd = [Util dateToSecondConvert:end];
        [Util add:dic value:numEnd key:@"endTime"];
        [Util addList:dic list:annotation.videoAttachments key:@"videoAttachments"];
        [Util add:dic value:serialize(annotation.markedArea) key:@"markedArea"];
        [Util add:dic value:annotation.annotationType key:@"annotationType"];        
        [Util addList:dic list:annotation.imageAttachments key:@"imageAttachments"];
        [arr addObject:dic];
    }
    
    
    NSDictionary *dicFinal = [Util deserialize:json];
    
    // delete video id from media object's json
    //NSMutableDictionary *dicToRemoveVideoId = [dicFinal mutableCopy];
    //[[dicToRemoveVideoId objectForKey:@"data"]removeObjectForKey:@"videoId"];
    // Add annotation object inside data object
    //[[dicToRemoveVideoId objectForKey:@"data"] setValue:arr forKey:@"annotations"];
    //[[dicFinal objectForKey:@"data"] setValue:arr forKey:@"annotations"];
    
    if(status!=nil)
    {
        NSString *like = status == LIKE ? @"LIKE" : @"FLAG";
        [[dicFinal objectForKey:@"data"] setValue:like forKey:@"likeStatus"];
    }
    
    [[dicFinal objectForKey:@"data"] setValue:arr forKey:@"annotations"];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicFinal options:NSJSONWritingPrettyPrinted error:&error];
 
    json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    
    return [self data:request bean:[Media class]];
}

// Create Media (To save the title and description of uploaded image/video from image gallery of device)
- (Media *) createMedia:(Media *) media {
    
    NSString *url = [Util append:gatewayUrl, @"/video/media", nil];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *json = [Util serialize:media];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token,nil]];
    //[request setUseCookiePersistence:NO];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    
    return [self data:request bean:[Media class]];
}


//Called after createMedia (when user choose a video to upload) (videoId is media.pk ie mediaid)
//- (void) uploadMedia:(NSData *) data videoId:(NSNumber *) videoId delegate:(id<ASIHTTPRequestDelegate>) async {
- (void) uploadMedia:(NSData *) data videoId:(NSString *) videoId delegate:(id<ASIHTTPRequestDelegate>) async {
    
    //NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/upload-deferred/", [videoId stringValue],nil]; //http://www.cut2it.com
    //NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/upload-deferred/", videoId, nil]; //Flash Server Url    
    NSString *url = [Util append:gatewayUrl, @"/video/media/upload-deferred/", videoId, nil]; //Flash Server Url
    
    NSLog(@"Upload Media called");
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request addData:data withFileName:@"iphone.mov" andContentType:@"multipart/form-data" forKey:@"file"];
    [request setDelegate:async];
    [request startAsynchronous];
}

// For later use 
- (void) uploadVideo:(NSString *) name data:(NSData *) video delegate:(id<ASIHTTPRequestDelegate>) async {
    NSString *url = [Util append:gatewayUrl, @"/video/media/youtube/upload",nil];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request setPostValue:@"cut2it" forKey:@"title"];
    [request setPostValue:@"cut2it" forKey:@"description"];
    [request addData:video withFileName:name andContentType:@"multipart/form-data" forKey:@"file"];
    [request setDelegate:async];
    [request startAsynchronous];
}

- (void) uploadCommentVideo:(NSString *) name  data:(NSData *) video  progress:(id) progress delegate:(id<ASIHTTPRequestDelegate>) async {
    //NSString *url = [Util append:openflameUrl, @"/rest/content/resource/upload/video?ttl=2h",nil];
    NSString *url = [Util append:gatewayUrl, @"/video/comment",nil];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag = VideoType;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
    //[request setUseCookiePersistence:NO];
    [request addData:video withFileName:name andContentType:@"multipart/form-data" forKey:@"file"];
    [request setDelegate:async];
    [request setUploadProgressDelegate:progress];
    [request startAsynchronous];
}

//as attachment
- (void) uploadImage:(NSString *)name data:(NSData *) image progress:(id) progress delegate:(id<ASIHTTPRequestDelegate>) async {
   // NSString *url = [Util append:openflameUrl, @"/rest/content/resource/upload/image?ttl=2h",nil];
    NSString *url = [Util append:gatewayUrl, @"/video/comment/image",nil];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag = ImageType;
    [request addData:image withFileName:name andContentType:@"image/png" forKey:@"file"];
    [request setDelegate:async];
    [request setUploadProgressDelegate:progress];
    [request startAsynchronous];
}

//Save like/dislike status of video
//- (void) mediaLike:(NSString *) pk status:(LikeStatus) status { // http://www.cut2it.com
- (void) mediaLike:(NSString *) pk status:(LikeStatus) status { // Flash Server
    NSString *like = status == LIKE ? @"LIKE" : @"FLAG";
    //NSString *url = [Util append:gatewayUrl, @"/video/media-rating/like-status?mediaId=", [pk stringValue], @"&likeStatus=", like,nil]; // http://www.cut2it.com
//    NSString *url = [Util append:gatewayUrl, @"/video/media-rating/like-status?mediaId=",pk , @"&likeStatus=", like,nil]; //Flash Server 
    
    NSString *url = [Util append:gatewayUrl, @"/video/media-rating/set-like-status?mediaId=",pk , @"&likeStatus=", like,nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
   // [request setUseCookiePersistence:NO];
    //[request setRequestMethod:@"PUT"]; // cut2it.com
    [request setRequestMethod:@"PUT"]; //Flash Server
    [request startAsynchronous];
 
}

//Check and load if like/dislike exists for a video
//- (MediaRating *) loadMediaLike:(NSNumber *) pk { // http://www.cut2it.com
- (MediaRating *) loadMediaLike:(NSString *) pk { // Flash Server
    
    if(pk!=nil && ![pk isEqualToString:@""])
    {
        NSString *url = [Util append:gatewayUrl, @"/video/media-rating/like-status?mediaId=", pk, nil];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        
        [request addRequestHeader:@"Cookie" value:[Util append:TOKEN,@"=",token, nil]];
        //[request setUseCookiePersistence:NO];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        return [self data:request bean:[MediaRating class]];
    }
    else{
        return nil;
    }
}

- (NetworkStatus) checkConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus];
}

#pragma mark -
#pragma mark processing response data

- (void) requestFinished:(ASIHTTPRequest *) request {
    if ([delegate respondsToSelector:@selector(finish:)]) {
        id data;
        if (request.single) {
            data = [self data:request bean:request.responseClass];
        } else
        { 
            data = [self dataList:request bean:request.responseClass];              
        }
        if (data) {
            [delegate finish:data];
            [data release];
        }
    }
}

//- (void) requestFinished:(ASIHTTPRequest *) request {
//    if ([delegate respondsToSelector:@selector(finish:)]) {
//        id data;
//        if (request.single) {
//            if((([[[request url] absoluteString] rangeOfString:@"/video/media/popular"].location!=NSNotFound || [[[request url] absoluteString] rangeOfString:@"video/media/starred"].location!=NSNotFound) && [delegate isKindOfClass:[HomeViewController class]]) || ([[[request url] absoluteString] rangeOfString:@"/video/media/recent"].location!=NSNotFound && [delegate isKindOfClass:[VideoViewController class]]))
//            {
//                data = [self data:request bean:request.responseClass];
//                if (data) {
//                    [delegate finish:data];
//                    [data release];
//                }
//            }
//        } else {
//            if((([[[request url] absoluteString] rangeOfString:@"/video/media/popular"].location!=NSNotFound || [[[request url] absoluteString] rangeOfString:@"video/media/starred"].location!=NSNotFound) && [delegate isKindOfClass:[HomeViewController class]]) || ([[[request url] absoluteString] rangeOfString:@"/video/media/recent"].location!=NSNotFound && [delegate isKindOfClass:[VideoViewController class]]))
//            {
//                data = [self dataList:request bean:request.responseClass];
//                if (data) {
//                    [delegate finish:data];
//                    [data release];
//                }
//            }
//        }
//        
//    }
//}


- (NSMutableArray *) dataList:(ASIHTTPRequest *) request bean:(Class) bean {
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSLog(@"Class %@",bean);
        NSLog(@"%@",response);
        NSDictionary *dic = [Util deserialize:response];
        BOOL success = [[dic objectForKey:@"success"] boolValue];
        NSString *message = [dic objectForKey:@"message"];
        NSArray *list = [dic objectForKey:@"data"];
              
        if ([delegate respondsToSelector:@selector(success:)]) {
            [delegate success:success];
        }
        
        if (success && list) {
            NSMutableArray *datas = [[NSMutableArray alloc] init];
            for (NSDictionary *data in list) {
                //id entity = [[bean alloc] initWithDictionary:data];
                id entity;
                if (bean == nil) {
                    entity = [[NSDictionary alloc] initWithDictionary:data];
                }
                else
                {
                    entity = [[bean alloc] initWithDictionary:data];
                }
                [datas addObject:entity];
                [entity release];
            }
            return datas;
        } else if (!success && list) {
            if(!message)
            {
                message = @"Request Failed";
                for (NSDictionary *data in list) {
                    ServerError *entity = [[ServerError alloc] initWithDictionary:data];
                    message = [Util append:message, entity.msg, @"\n", nil];
                    [entity release];
                }
                [self error:message];
            }
            
        } else if (!success){
            if(!message)
            [self error:message];
        }
        
    } else {
        NSString *message = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
        [self error:message];
    }
    
    //[delegate hideLoadingView];    
    return nil;
}

- (int) dataListTotal:(ASIHTTPRequest *) request bean:(Class) bean {
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSLog(@"Class %@",bean);
        NSLog(@"%@",response);
        NSDictionary *dic = [Util deserialize:response];
        BOOL success = [[dic objectForKey:@"success"] boolValue];
        NSString *message = [dic objectForKey:@"message"];
        NSArray *list = [dic objectForKey:@"data"];
        
        NSNumber *total;
        if([[dic objectForKey:@"total"] isKindOfClass:[NSString class]])
        {
            total = [[dic objectForKey:@"total"] intValue];
        }
        else if([[dic objectForKey:@"total"] isKindOfClass:[NSNumber class]]){
            total = [[dic objectForKey:@"total"] intValue];
        }        
        
        
        if ([delegate respondsToSelector:@selector(success:)]) {
            [delegate success:success];
        }
        
        if (success ) {           
            return total;
        } else if (!success && list) {
            message = @"Request Failed";
            for (NSDictionary *data in list) {
                ServerError *entity = [[ServerError alloc] initWithDictionary:data];
                message = [Util append:message, entity.msg, @"\n", nil];
                [entity release];
            }
            [self error:message];
        } else if (!success){
            if(![message isEqualToString:@""])
            {
                [self error:message];
            }            
        }
        
    } else {
        NSString *message = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
        [self error:message];
    }
    
    //[delegate hideLoadingView];
        
    return nil;
}


- (id) data:(ASIHTTPRequest *) request bean:(Class) bean {
    NSArray *datas = [self dataList:request bean:bean];
    id data = nil;
    if ([datas count] != 0) {
        data = [[datas objectAtIndex:0] retain];
        [datas release];
    }
    
    return data;
}

#pragma mark -
#pragma mark Facebook Delegate
/*
- (void) fbDidLogin:(NSString *) _accessToken {
    NSLog(@"fbDidLogin_accessToken:%@",accessToken);
   //Saumiya
   //    if(self.accessToken &&[delegate respondsToSelector:@selector(logged:)]){
       if(FBSession.activeSession.isOpen &&[delegate respondsToSelector:@selector(logged:)]){

        [Util setProperties:FACEBOOK value:accessToken];
        [Util setProperties:FACEBOOK_USERNAME value:fbUserName];
        [delegate logged:FacebookType];
    }

}
 */
 

- (void) fbDidLogin:(NSString *) Token {
    NSLog(@"accessToken:%@",accessToken);
    
   // NSString *url = [Util append:openflameUrl, @"/facebook-authentication/mobile?access_token=", accessToken, nil]; // cut2it.com
    
    NSString *url = [Util append:gatewayUrl, @"/authority/facebook-authentication/mobile?access_token=", Token, nil]; //flash server
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];

    //[request setRequestMethod:@"GET"]; //http://www.cut2it.com
    [request setRequestMethod:@"POST"]; //Flash Server
    if(accessToken!=nil)
    {
        [request addRequestHeader:@"access_token" value:Token];
    }    
    [request startSynchronous];
    Authentication *auth = [self data:request bean:[Authentication class]];
   
    if (auth) {
        if (!user) {
            self.user = auth.user;
            self.token = auth.token;
        }
       self.userFacebook = auth.user;
        [Util setProperties:FACEBOOK value:Token];
        [Util setProperties:FACEBOOK_USERNAME value:userFacebook.username];
        
       if (self.token && [delegate respondsToSelector:@selector(logged:)]) {
            [delegate logged:FacebookType];
        }
    }
    [auth release];
    
} 


#pragma mark -
#pragma mark Twitter Delegate

- (void) twitterAuthorizationCompletenew:(NSString *) oatoken consumer:(NSString *) consumerSecret {
 
 /* // 25th Sept 2013 - Bhavya, Server team is accessing the oatoken and consumerSecret by url parameters now instead of using headers.
    NSString *url = [Util append:gatewayUrl, @"/authority/twitter-authentication/mobile", nil]; //Flash Server new
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];    
    //[request setRequestMethod:@"GET"]; // cut2it.com
    [request setRequestMethod:@"POST"]; // flash server    
    [request addRequestHeader:@"access_token" value:oatoken];
    [request addRequestHeader:@"access_token_secret" value:consumerSecret];
    [request startSynchronous];
  */
    
    NSString *url = [Util append:gatewayUrl, @"/authority/twitter-authentication/mobile?access_token=", oatoken, @"&access_token_secret=", consumerSecret, nil]; // Cloud Server
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"]; // flash server
    [request startSynchronous];
    
    Authentication *auth = [self data:request bean:[Authentication class]];
    if (auth) {
        if (!user) {
            self.user = auth.user;
            self.token = auth.token;
        }
        
        [Util setProperties:TWITTER_USER value:self.userTwitter.username];
        self.userTwitter = auth.user;
        [Util setProperties:TWITTER_KEY value:oatoken];
        [Util setProperties:TWITTER_SECRET value:consumerSecret];
        [Util setProperties:TWITTER_USERNAME value:self.userTwitter.username];        

        /*
        if(appDelegate.fromTwitterWelcom){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTab" object:nil];
            //appDelegate.fromTwitterWelcom=NO;
        }
         */        
         
        if (self.token && [delegate respondsToSelector:@selector(logged:)]) {
            [delegate logged:TwitterType];
        }
        
    }
    //[delegate hideLoadingView];
    [auth release];
}


#pragma mark -
#pragma mark Youtube

- (NSDictionary *) readYoutubeInformation:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    if (error) {
        NSString *message = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
        [self error:message];
        return nil;
    }
    
    NSString *response = [request responseString];
    
    NSMutableDictionary *parts = [NSMutableDictionary dictionary];
    
    for (NSString *keyValue in [response componentsSeparatedByString:@"&"]) {
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:@"="];
        if ([keyValueArray count] < 2) {
            continue;
        }
        
        NSString *key = [[keyValueArray objectAtIndex:0] decodingURLFormat];
        NSString *value = [[keyValueArray objectAtIndex:1] decodingURLFormat];
        
        NSMutableArray *results = [parts objectForKey:key];
        
        if(!results) {
            results = [NSMutableArray arrayWithCapacity:1];
            [parts setObject:results forKey:key];
        }
        
        [results addObject:value];
    }
    
    
    if ([[[parts objectForKey:@"status"] objectAtIndex:0] isEqual:@"fail"]) {
        NSString *reason = [[parts objectForKey:@"reason"] objectAtIndex:0];
        if ([reason rangeOfString:@"<br/>"].location != NSNotFound) {
            reason = [reason substringToIndex:NSMaxRange([reason rangeOfString:@"<br/>"]) - 5];
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:reason,@"reason", nil];
    }
    
    NSString *fmtStreamMapString = [[parts objectForKey:@"url_encoded_fmt_stream_map"] objectAtIndex:0];
    NSArray *fmtStreamMapArray = [fmtStreamMapString componentsSeparatedByString:@","];
    
    NSMutableDictionary *videoDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *videoEncodedString in fmtStreamMapArray) {
        NSMutableDictionary *videoComponents = [videoEncodedString dictionaryFromQueryStringComponents];
        NSString *type = [[[videoComponents objectForKey:@"type"] objectAtIndex:0] decodingURLFormat];
        //NSLog(@"videoComponents:%@",videoComponents);
        if ([type rangeOfString:@"mp4"].length != NSNotFound) {
            NSString *url = [[[videoComponents objectForKey:@"url"] objectAtIndex:0] decodingURLFormat];
            
            NSString *sig = [[[videoComponents objectForKey:@"sig"] objectAtIndex:0] decodingURLFormat];
            NSString *quality = [[[videoComponents objectForKey:@"quality"] objectAtIndex:0] decodingURLFormat];
            url = [Util append:url,@"&signature=", sig, nil];
            [videoDictionary setObject:url forKey:quality];
        }
    }
    
    return videoDictionary;
}

#pragma mark -
#pragma mark cut2it Delegate

- (void) error:(NSString *) message {
    if ([delegate respondsToSelector:@selector(error:)]) {
		[delegate error:message];
	}
}

@end

@implementation NSString (QueryString)

- (NSString *) decodingURLFormat {
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)dictionaryFromQueryStringComponents {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    for (NSString *keyValue in [self componentsSeparatedByString:@"&"]) {
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:@"="];
        if ([keyValueArray count] < 2) {
            continue;
        }
        
        NSString *key = [[keyValueArray objectAtIndex:0] decodingURLFormat];
        NSString *value = [[keyValueArray objectAtIndex:1] decodingURLFormat];
        
        NSMutableArray *results = [parameters objectForKey:key];
        
        if(!results) {
            results = [NSMutableArray arrayWithCapacity:1];
            [parameters setObject:results forKey:key];
        }
        
        [results addObject:value];
    }
    
    return parameters;
}

@end

