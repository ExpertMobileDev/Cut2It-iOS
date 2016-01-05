//
//  MainViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "LoadingView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize imgBackground;

#pragma mark Loading Screen
/*
- (void) hideLoadingView {
    //[self dismissModalViewControllerAnimated:YES];
    [loadingView.spinner stopAnimating];
    [loadingView.view setHidden:YES];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

- (void)showLoadingView {
	NSLog(@"showLoadingView");
    //[self presentModalViewController:loadingView animated:YES];
    
    [loadingView.view setHidden:NO];
    [loadingView.spinner startAnimating];
    [self.view bringSubviewToFront:loadingView.view];
}
 */
#pragma mark Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
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
    
    self.username.text = [Util getProperties:USERNAME];
    self.password.text = [Util getProperties:PASSWORD_HINT];
    
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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField {
    textField.layer.borderWidth = 1;
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *) textField {
    textField.layer.borderWidth = 0;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loginEmail:(id) sender {
    
    NSString *result =[self verify];
    //[self showLoadingView];
    
    if([result isEqualToString:@"TRUE"]){     
        
    Authentication *auth = [self.api login:username.text password:password.text];
        
    if (auth) {
        
        self.api.token = auth.token;
        self.api.user = auth.user;
        [auth release];
        
        [Util setProperties:USERNAME value:username.text];
        [Util setProperties:PASSWORD value:password.text];
        [Util setProperties:PASSWORD_HINT value:password.text];
		
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
    if([username.text length]==0){
        message = @"Please enter username.";
        return message;
    }
    if([password.text length]==0){
        message = @"Please enter Password.";
        return message;
        
    }
    return message = @"TRUE";
}

- (IBAction)forgotUsername:(id)sender {
}

- (void)dealloc {
    [super dealloc];
    //[loadingView release];
}

@end
