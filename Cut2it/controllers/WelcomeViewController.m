//
//  HomeViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AccountsListViewController.h"
#import "AppDelegate.h"

#import "SVProgressHUD.h"

@implementation WelcomeViewController
@synthesize imgBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    if(IPHONE_5)
    {
        UIImage *background=[UIImage imageNamed:@"w_background_5@2x.png"];
        [imgBackground initWithImage:background];
    }
    else
    {
        UIImage *background=[UIImage imageNamed:@"w_background@2x.png"];
        [imgBackground initWithImage:background];
    }
    */
    
    //BB0202: not running on iOS8
    //[super blankRotate];
    
    //BB0202: don't show Intro anymore
    if (![Util getBoolProperties:INTRO]) {
        //[self performSelector:@selector(intro:) withObject:nil afterDelay:1];
        //showTab
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabView) name:@"showTab" object:nil];
        [Util setBoolProperties:INTRO value:YES];
    }
    // Do any additional setup after loading the view from its nib.
    
    //BB0202: Login
    /*loadingView = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
     [self.view addSubview:loadingView.view];
     [loadingView.view setHidden:YES];
     */
    
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
    UIBarButtonItem *login = [self createBarButtonWithName:@"Login" image:@"rounded" width:68 target:self action:@selector(loginEmail:)];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = login;
    
    [back release];
    [login release];
    
    self.editUsername.text = [Util getProperties:USERNAME];
    self.editPassword.text = [Util getProperties:PASSWORD_HINT];
    
    /*
    if(IPHONE_5)
    {
        UIImage *background=[UIImage imageNamed:@"l_background_5@2x.png"];
        [imgBackground initWithImage:background];
    }
    else
    {
        UIImage *background=[UIImage imageNamed:@"l_background@2x.png"];
        [imgBackground initWithImage:background];
    }
    */
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)showTabView{
    //- (void) logged:(LoginType) type
    TabViewController *controller = [[TabViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
   
}

- (void) hideLoadingView {
    NSLog(@"hideLoadingView_Welcome");

}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_editUsername setText:@""];
    [_editPassword setText:@""];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self autoAuth];
}

- (IBAction) intro:(id)sender {
    IntroViewController *controller = [[IntroViewController alloc] init];
    [self.navigationController presentModalViewController:controller animated:YES];
    [controller release];
    [Util setBoolProperties:INTRO value:YES];
}

- (void) autoAuth {
    NSString *username = [Util getProperties:USERNAME];
    NSString *password = [Util getProperties:PASSWORD];  
    
    if (password && FBSession.activeSession.isOpen) {
        Authentication *auth = [self.api login:username password:password];
        if (auth) {
            self.api.token = auth.token;
            self.api.user = auth.user;
            [self logged:OpenflameType];
            [auth release];
            return;
        }
    }
    
    NSString *token = [Util getProperties:FACEBOOK];
    if (token) {
        [self.api fbDidLogin:token];
        return;
    }
    
    NSString *key = [Util getProperties:TWITTER_KEY];
    NSString *secret = [Util getProperties:TWITTER_SECRET];
    if (key && secret) {
        [self.api twitterAuthorizationCompletenew:key consumer:secret];
        //OAToken *token = [[OAToken alloc] initWithKey:key secret:secret];
        //[self.api twitterAuthorizationComplete:token consumer:nil];
        //[token release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] init];
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
     appDelegate.fromTwitterWelcom =NO;
    appDelegate.fromFBWelcome =NO;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)registerUser:(UIButton *)sender {
    AccountViewController *controller = [[AccountViewController alloc] init];
    controller.isEditAccount = FALSE;
    controller.navigationItem.title = @"Register";
     AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
     appDelegate.fromTwitterWelcom =NO;
    appDelegate.fromFBWelcome =NO;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)facebook:(id)sender {
   // [self.api facebookLogin];
     AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fromTwitterWelcom =NO;
    appDelegate.fromFBWelcome =YES;
   NSLog(@"FB WelcomeView");
    [self.api openSessionWithAllowLoginUI:YES];
}

- (IBAction)twitter:(id)sender {
     AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fromTwitterWelcom =YES;
    appDelegate.fromFBWelcome =NO;
    [self openTwitterAccountController];
    //[self.api twitterLogin];
}


-(void)openTwitterAccountController{
    NSLog(@"openTwitterAccountController");
     self.navigationController.navigationBarHidden = NO;
    AccountsListViewController *accountsListViewController = [[AccountsListViewController alloc] init];
    //[self presentModalViewController:accountsListViewController animated:YES];
    [self.navigationController pushViewController:accountsListViewController animated:YES];
    [accountsListViewController release];
        
    
}


- (IBAction)develop:(id)sender {
    //Effect *effect = [[Effect alloc] init];
   // [effect start];
    EffectViewController *controller = [[EffectViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)onRemember:(id)sender {
    [self actionChecking];
}

- (IBAction)onCheck:(id)sender {

    [self actionChecking];
}

- (void) actionChecking {
    
    NSString * b_rememberPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Key_REMEMBER_PASSWORD"];
    
    if ( [b_rememberPassword isEqualToString:@"YES"] )
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Key_REMEMBER_PASSWORD"];
        [_btnCheck setBackgroundImage:[UIImage imageNamed:@"Checkbox.png"] forState:(UIControlState)normal];

    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Key_REMEMBER_PASSWORD"];
        [_btnCheck setBackgroundImage:[UIImage imageNamed:@"Checkbox_selected.png"] forState:(UIControlState)normal];
 
    }
    
}

#pragma mark -
#pragma mark Cut2it api delegate

- (void) logged:(LoginType) type {
    TabViewController *controller = [[TabViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)dealloc {
    [super dealloc];
}


//BB0202: Login Action
#pragma mark Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField {
    //textField.layer.borderWidth = 1;
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *) textField {
    //textField.layer.borderWidth = 0;
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    if ([textField isEqual:_editPassword])
    {
        [SVProgressHUD showWithStatus:@"Loggin in"];
        
        AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.fromTwitterWelcom =NO;
        appDelegate.fromFBWelcome =NO;

        
        [self loginEmail];
    }
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) loginEmail {
    
    NSString *result =[self verify];
    //[self showLoadingView];
    
    if([result isEqualToString:@"TRUE"]){
        
        Authentication *auth = [self.api login:_editUsername.text password:_editPassword.text];
        
        NSString * b_rememberPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"Key_REMEMBER_PASSWORD"];
        
        if ( [b_rememberPassword isEqualToString:@"NO"] )
        {
            [_editUsername setText:@""];
            [_editPassword setText:@""];
        }
        
        if (auth) {
            
            self.api.token = auth.token;
            self.api.user = auth.user;
            [auth release];
            
            [Util setProperties:USERNAME value:_editUsername.text];
            [Util setProperties:PASSWORD value:_editPassword.text];
            [Util setProperties:PASSWORD_HINT value:_editPassword.text];
            
            
            
            TabViewController *controller = [[TabViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            [controller release];
            
            if (self.container.selected) {
                PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:self.container.selected];
                [[self.delegate navigationController] pushViewController:player animated:NO];
                [player release];
            }
        }
        else
        {
            // Bhavya - 29th Oct 2013. Client's request to show alert on entering invalid credentials.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid credentials." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    else{
        //[self hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(NSString*)verify{
    NSString *message = nil;
    if([_editUsername.text length]==0){
        message = @"Please enter username.";
        return message;
    }
    if([_editPassword.text length]==0){
        message = @"Please enter Password.";
        return message;
        
    }
    return message = @"TRUE";
}

@end
