//
//  AppDelegate.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"
#import "LoginViewController.h"
#import "Cut2itApi.h"
#import "Container.h"

#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FacebookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import "FacebookSDK.h"

//#import "TestFlight.h"
#import "ShareViewController.h"
#import "PlayerViewController.h"

//extern NSString *const FBSessionStateChangedNotification;
//com.cutToIt.app
//http://www.cut2it.com

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
//    NSString *accessToken;
    ShareViewController*shareCont;
    PlayerViewController *playerCont;
    BOOL fromTwitterWelcom;
    BOOL markupSelected;
    BOOL replyClicked;
    BOOL fromFBWelcome;
    
}

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *navigationController;
@property(assign) BOOL hasProductURL,hasCloseSession;
@property(assign) BOOL isfbError;
@property(nonatomic,retain) NSMutableDictionary *requestDictionary;
@property (nonatomic,retain) NSString * videoTitle;
//@property(nonatomic,retain)NSString *accessToken;
@property(nonatomic,retain) ShareViewController *shareCont;
@property (retain, nonatomic) NSNumber *pk;
@property (nonatomic,retain) NSString*videoID;
@property (strong, nonatomic) ACAccount *account;
//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
//- (void) closeSession;
-(void)getFBUserInfo;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (nonatomic,retain) NSString *videoUrl;
@property (nonatomic,retain) PlayerViewController *playerCont;
@property (nonatomic,assign) BOOL fromMail;
@property (nonatomic,assign) BOOL replyClicked;
@property (nonatomic,assign) BOOL fromTwitterWelcom;
@property (nonatomic,assign) BOOL markupSelected;
@property (nonatomic,retain) NSString *faceBookComment;
@property (nonatomic,assign) BOOL fromFBWelcome;

@end
