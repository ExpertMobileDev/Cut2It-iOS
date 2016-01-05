//
//  AppDelegate.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FacebookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import "FacebookSDK.h"

#import "ConfigureServiceViewController.h"

//NSString *const FBSessionStateChangedNotification =
//@"com.tesnew.app:FBSessionStateChangedNotification";


@implementation AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize hasProductURL,hasCloseSession;;
@synthesize requestDictionary;
@synthesize postParams = _postParams;
//@synthesize accessToken;
@synthesize shareCont;
@synthesize pk;
@synthesize videoUrl;
@synthesize playerCont;
@synthesize videoTitle;
@synthesize fromMail;
@synthesize account;
@synthesize fromTwitterWelcom;
@synthesize videoID;
@synthesize faceBookComment;
@synthesize markupSelected;
@synthesize replyClicked;
@synthesize fromFBWelcome;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // [TestFlight takeOff:@"cf9c146cd00c8836b2640650d1a2e049_MTI3NDg3MjAxMi0wOS0wMyAwNTozODoyOS4xODgyNjM"];
       fromMail = NO;
    hasCloseSession = NO;
    markupSelected=NO;
    self.requestDictionary = [[NSMutableDictionary alloc] init];
    
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
                                                                [UIColor whiteColor], UITextAttributeTextColor,
                                                                [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                nil]];
    window.backgroundColor=[UIColor blackColor];
    [window makeKeyAndVisible];
    return YES;
    
    
    //BB0202: initiate the KEY_VALUES here.
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Key_REMEMBER_PASSWORD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Key_TERMSNCONDITIONS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url {

    return YES;
}
 */


/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *) url {
    NSLog(@"handleOpenURL");
    NSArray *path = [[url path] componentsSeparatedByString:@"/"];
    if ([path count] >= 2) {
        Container *container = [Container shared];
        Cut2itApi *api = [Cut2itApi shared];
        if ([Util isNumber:[path objectAtIndex:1]]) {
            container.selected = [api loadMedia:[NSNumber numberWithInt:[[path objectAtIndex:1] intValue]]];
            if ([path count] == 3) container.annotationId = [NSNumber numberWithFloat:[[path objectAtIndex:2] floatValue]];
            if (api.token) {
                PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:container.selected];
                [self.navigationController pushViewController:player animated:YES];
                [player release];
            } else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
                [login release];
            }
        }
    }
    return YES;         
}
*/

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *) window {
    if ([self.navigationController.topViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//http://dev1.cut2it.com:8080/cut2it/rest/video/media-rating/like-status?mediaId=1
//http://dev1.cut2it.com:8080/cut2it/rest/video/annotation/by-video-id/nap-Dzfjpu0
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //if(fromMail==YES){
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ClosePlayerView" object: nil];
    //}    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBSession.activeSession handleDidBecomeActive];
    /*
    if(fromFBWelcome){
    TabViewController *controller = [[TabViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    }
     */
    
   
     
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) dealloc {
    [window release];
    [navigationController release];
    [super dealloc];

}


/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    if(fromMail){
    NSArray *path = [[url path] componentsSeparatedByString:@"/"];
    if ([path count] >= 2) {
        Container *container = [Container shared];
        Cut2itApi *api = [Cut2itApi shared];
        if ([Util isNumber:[path objectAtIndex:1]]) {
            container.selected = [api loadMedia:[NSNumber numberWithInt:[[path objectAtIndex:1] intValue]]];
            if ([path count] == 3) container.annotationId = [NSNumber numberWithFloat:[[path objectAtIndex:2] floatValue]];
            if (api.token) {
                PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:container.selected];
                [self.navigationController pushViewController:player animated:YES];
                [player release];
            } else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
                [login release];
            }
        }
        else if ([[path objectAtIndex:1] isKindOfClass:[NSString class]]) {
            container.selected = [api loadMedia:[path objectAtIndex:1]];
            if ([path count] == 3) container.annotationId = [NSNumber numberWithFloat:[[path objectAtIndex:2] floatValue]];
            if (api.token) {
                PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:container.selected];
                [self.navigationController pushViewController:player animated:YES];
                [player release];
            } else {
                LoginViewController *login = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
                [login release];
            }
        }
    }
    return YES;
    }
    
    return [FBSession.activeSession handleOpenURL:url];
}



@end
