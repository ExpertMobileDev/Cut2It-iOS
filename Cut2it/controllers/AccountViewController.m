//
//  AccountViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize scroll;
@synthesize username;
@synthesize firstname;
@synthesize lastname;
@synthesize email;
@synthesize password;
@synthesize confirm;
@synthesize imageView;
@synthesize choose;
@synthesize file;
@synthesize profile;
@synthesize isEditAccount;
@synthesize tmpTextField;
@synthesize saveEdit;
@synthesize profileImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*
        UIBarButtonItem *cancel = [self createBarButtonWithName:@"Cancel" image:@"rounded" width:68 target:self action:@selector(back:)];
        UIBarButtonItem *save = [self createBarButtonWithName:@"Save" image:@"rounded" width:68 target:self action:@selector(save:)];
        
        self.navigationItem.leftBarButtonItem = cancel;
        self.navigationItem.rightBarButtonItem = save;
         
        [cancel release];
        [save release];
        */
        
        //BB0202: don't need navigation bar
        self.navigationController.navigationBarHidden = YES;
        
        self.profile = [[UserProfile alloc] init];
        [self.profile release];
        
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    //BB0202: don't need navigation bar
    //self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
    saveEdit= FALSE;
    
    if(isEditAccount == TRUE)
    {
        [self loadUserData];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void) loadUserData
{
    self.username.userInteractionEnabled = FALSE;
    
    //Bhavya - 24th June 2013 (Client's change in requirement)
    self.email.userInteractionEnabled = FALSE;
    
    self.profile= [self.api getUserProfile];
    
    self.username.text= self.profile.username;
    self.username.alpha =50.0;
    self.firstname.text= self.profile.firstname;
    self.lastname.text= self.profile.lastname;
    self.email.text = self.profile.email;
    // Bhavya, 29th Oct 2013. Displayed password due to change in Client's requirement
    self.password.text = [Util getProperties:PASSWORD_HINT];
    self.confirm.text = [Util getProperties:PASSWORD_HINT];    
    
    if (self.profile.avatarResourceLookup) {
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.profile.avatarResourceLookup]]];
        if(self.imageView.image==nil)
        {
            self.imageView.image  = [UIImage imageNamed:@"s_avatar_default"];
        }
        
    } else {
        self.imageView.image  = [UIImage imageNamed:@"s_avatar_default"];
    }
    
    
 // Bhavya - end
    

}
- (void)requestFinished:(ASIHTTPRequest *) request {
  
    NSData *responseData = [request responseData];
    self.imageView.image = [UIImage imageWithData:responseData];
      [self release];
}

- (void) finish:(id) data
{
    NSLog(@"In AccountViewController");
}

- (void)viewDidUnload {
    [self setScroll:nil];
    [self setUsername:nil];
    [self setFirstname:nil];
    [self setLastname:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setConfirm:nil];
    [self setImageView:nil];
    [self setChoose:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) choise:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Delete Photo", nil];
     popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

- (void) save:(id) sender {
    
    
    
    BOOL validEmail=[self validateEmail:self.email.text];
    BOOL validConfirmPassword = FALSE;
    if(validEmail == TRUE)
    {
        validConfirmPassword=[self  validationConfirmPassword:self.password.text:self.confirm.text];
    }
    
    if(isEditAccount == FALSE && validConfirmPassword == TRUE && validEmail == TRUE)
    {
        self.profile.username = self.username.text;
        self.profile.firstname = self.firstname.text;
        self.profile.lastname = self.lastname.text;
        self.profile.email = self.email.text;
        self.profile.password = self.password.text;
        self.profile.temporaryFile = file.filename;
        
        UserProfile *user = [self.api registration:self.profile];
        if (user) {
            if(profileImage)
            {
                self.file = [self.api uploadPhoto:UIImagePNGRepresentation(profileImage) :user.pk];
            }            
            [Util setProperties:USERNAME value:user.username];
            [Util setProperties:PASSWORD value:user.password];
            [Util setProperties:PASSWORD_HINT value:user.password];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if(isEditAccount == TRUE && validEmail == TRUE  && validConfirmPassword == TRUE)
    {
        if(profileImage)
        {
            self.file = [self.api uploadPhoto:UIImagePNGRepresentation(profileImage) :self.profile.pk];
        }
         self.profile.firstname = self.firstname.text;
         self.profile.lastname = self.lastname.text;
         self.profile.email = self.email.text;
         self.profile.password = self.password.text;
         self.profile.temporaryFile = self.file.filename;

        [self.api editUserProfile: self.profile];
        
        [tmpTextField resignFirstResponder];
        [scroll setContentOffset: CGPointZero animated: YES];
    }
    
}

- (void) success:(BOOL) success
{
   
   if(success == TRUE && saveEdit==TRUE)
    {
        [Util setProperties:PASSWORD value:self.profile.password];
        [Util setProperties:PASSWORD_HINT value:self.profile.password];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(success == FALSE && saveEdit==TRUE)
    {
        self.profile = [self.api getUserProfile];
    }     
}

-(BOOL) validationConfirmPassword:(NSString*) firstPassword:(NSString*)  confirmPassword
{
    BOOL result = FALSE;
    if([firstPassword isEqualToString:confirmPassword])
    {
        result = TRUE;
    }
    else
    {
        NSString * message= @"Please check Password and Confirm Password!";
        [self performSelector:@selector(showAlert:) withObject:message];
    }
    
    
    return result;
}

-(BOOL) validateEmail: (NSString *) textEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:textEmail];
    if(isValid == FALSE)
    {
        NSString * message= @"Please check Email!";
        [self performSelector:@selector(showAlert:) withObject:message];
     
        
    }
    return isValid;
}

-(void) showAlert:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField {
    tmpTextField = textField;
    if(isEditAccount== FALSE)
    {
    [scroll setContentOffset: CGPointMake(0, textField.frame.origin.y - textField.frame.size.height) animated: YES];
    }
    else{
    [scroll setContentOffset: CGPointMake(0, textField.frame.origin.y  - textField.frame.size.height - 88) animated: YES];
    }
    textField.layer.borderWidth = 1;
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *) textField {
    textField.layer.borderWidth = 0;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    [scroll setContentOffset: CGPointZero animated: YES];
    return YES;
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    
	if (buttonIndex == 0) {
		[self takePhoto];
	} else if (buttonIndex == 1) {
		[self openPhoto];
	} else if (buttonIndex == 2) {
		[self deletePhoto];
	} else if (buttonIndex == 3) {
	}
}

- (void) openPhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}

- (void) takePhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing=YES;
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	
//	UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
//  self.file = [self.api uploadPhoto:UIImagePNGRepresentation(profileImage)];  
    
    profileImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = profileImage;
}

- (void) deletePhoto {
    self.imageView.highlighted = YES;
    self.imageView.image = nil;
}

- (void) dealloc {
    [file release];
    [profile release];
    [super dealloc];
}
- (IBAction)onTakeNewPhoto:(id)sender {
}

- (IBAction)onChoosePhotoFromLibrary:(id)sender {
}

- (IBAction)onNewPhoto:(id)sender {
}
@end
