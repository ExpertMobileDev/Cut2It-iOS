//
//  HomeViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PlayerViewController.h"
#import "LoginViewController.h"
#import "AccountViewController.h"
#import "IntroViewController.h"
#import "Effect.h"

@interface WelcomeViewController : BaseViewController
{
    UIImageView *imgBackground;
}

@property (nonatomic,retain) IBOutlet UIImageView *imgBackground;
@property (nonatomic, retain) IBOutlet UITextField *editUsername;
@property (nonatomic, retain) IBOutlet UITextField *editPassword;
@property (nonatomic, retain) IBOutlet UIButton *btnCheck;
@property (nonatomic, retain) IBOutlet UIButton *btnRemember;

- (IBAction)login:(id)sender;
- (IBAction)registerUser:(UIButton *)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)intro:(id)sender;
- (IBAction)develop:(id)sender;

- (IBAction)onRemember:(id)sender;
- (IBAction)onCheck:(id)sender;

- (void) loginEmail;
- (void) actionChecking;

@end
