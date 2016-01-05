//
//  Server.m
//
//  Created by Anand Kumar on 18/01/13.
//  Copyright (c) 2013 Anand Kumar. All rights reserved.
//

#import "Server.h"
#import "Constant.h"




static Server *server;
@implementation Server

@synthesize _facebook,_permissions,_token,_uid,_picurl,userPermissions;


+(Server*)sharedServer{
    
    if(server == nil){
        server = [[Server alloc] init];
		NSLog(@"sharedServer");

		
		server._permissions =  [[NSArray alloc] initWithObjects:@"offline_access", nil];
		// Initialize Facebook
		
		
		// Initialize API data (for views, etc.)
		//apiData = [[DataSet alloc] init];
		
		// Initialize user permissions
		server.userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
		
		// Override point for customization after application launch.
		// Add the navigation controller's view to the window and display.
		//self.window.rootViewController = self.navigationController;
		//[self.window makeKeyAndVisible];
		
		// Check App ID:
		// This is really a warning for the developer, this should not
		// happen in a completed app
		if (kAppId ==  NO) {
			UIAlertView *alertView = [[UIAlertView alloc] 
									  initWithTitle:@"Setup Error" 
									  message:@"Missing app ID. You cannot run the app until you provide this in the code." 
									  delegate:self 
									  cancelButtonTitle:@"OK" 
									  otherButtonTitles:nil, 
									  nil];
			[alertView show];
			[alertView release];
		} else {
			// Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
			// be opened, doing a simple check without local app id factored in here
			NSLog(@"didFinishLaunchingWithOptions_11");
			NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
			BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
			NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
			if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
				([aBundleURLTypes count] > 0)) {
				NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
				if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
					NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
					if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
						([aBundleURLSchemes count] > 0)) {
						NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
						if ([scheme isKindOfClass:[NSString class]] && 
							[url hasPrefix:scheme]) {
							bSchemeInPlist = YES;
						}
					}
				}
			}
			// Check if the authorization callback will work
			BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
			if (!bSchemeInPlist || !bCanOpenUrl) {
				UIAlertView *alertView = [[UIAlertView alloc] 
										  initWithTitle:@"Setup Error" 
										  message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
										  delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil, 
										  nil];
				[alertView show];
				[alertView release];
			}
		}
		
		
    //server._facebook.accessToken=[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    //server._facebook.expirationDate=[NSDate distantFuture];
        //@"publish_stream",@"read_stream", @"offline_access",@"email"
    
        
       // [[Server sharedServer]._facebook authorize:kAppId permissions:[Server sharedServer]._permissions delegate:nil];

        //[[FBSession session] resume];
    }
    
    return server;
}

-(void)fbProcess{
	
	// Initialize Facebook
    _facebook = [[Facebook alloc] initWithAppId:kAppId];
    
    // Initialize API data (for views, etc.)
    //apiData = [[DataSet alloc] init];
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    //self.window.rootViewController = self.navigationController;
    //[self.window makeKeyAndVisible];
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (kAppId == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Setup Error" 
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code." 
                                  delegate:self 
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil, 
                                  nil];
        [alertView show];
        [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
		NSLog(@"didFinishLaunchingWithOptions_11");
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] && 
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:@"Setup Error" 
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, 
                                      nil];
            [alertView show];
            [alertView release];
        }
    }
	
	
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Server_handleOpenURL");
    return [server._facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Server_sourceApplication");
    return [server._facebook handleOpenURL:url];
}

- (void)fbDidLogin{
    NSLog(@"Server_fbDidLogin");
    
}
	

- (void)request:(FBRequest*)request didLoad:(id)result
{
    
    NSLog(@"result=%@",result);
}

-(void) requestDone{
	//NSLog(@"Done");
	
}


@end

