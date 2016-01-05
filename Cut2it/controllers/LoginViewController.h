//
//  MainViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PlayerViewController.h"
#import "TabViewController.h"
#import "Authentication.h"
@class LoadingView;
@interface LoginViewController : BaseViewController <UITextFieldDelegate>{
   // LoadingView *loadingView;
    UIImageView *imgBackground;
}

@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,retain)  IBOutlet UIImageView *imgBackground;
//@property (nonatomic, retain) LoadingView *loadingView;

- (void)loginEmail:(id) sender;
- (IBAction)forgotUsername:(id)sender;
//- (void)showLoadingView;
@end
