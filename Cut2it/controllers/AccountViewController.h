//
//  AccountViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageFile.h"
#import "ImageResource.h"
#import "UserProfile.h"
#import "Folder.h"
#import "AsynImageView.h"


//http://dev1.cut2it.firejack.net:8080
@interface AccountViewController : BaseViewController <ASIHTTPRequestDelegate,UIActionSheetDelegate ,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *firstname;
@property (retain, nonatomic) IBOutlet UITextField *lastname;
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UITextField *confirm;
//@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet AsynImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *choose;

@property (retain, nonatomic) IBOutlet UIButton *btnTermsCheck;
@property (retain, nonatomic) IBOutlet UIButton *btnNewPhoto;
@property (retain, nonatomic) IBOutlet UIScrollView *btnTakeNewPhoto;
@property (retain, nonatomic) IBOutlet UIButton *btnChoosePhotoFromLibrary;


- (IBAction)onTakeNewPhoto:(id)sender;
- (IBAction)onChoosePhotoFromLibrary:(id)sender;
- (IBAction)onNewPhoto:(id)sender;


@property (retain, nonatomic) IBOutlet UITextField *tmpTextField;
@property (nonatomic)  BOOL isEditAccount;
@property (retain, nonatomic) ImageFile *file;
// Bhavya - 6th Sept 2013, added profileImage (To make uploadPhoto api call after registration api call.)
@property (retain, nonatomic) UIImage *profileImage;
@property (retain, nonatomic) UserProfile *profile;
@property (nonatomic)  BOOL saveEdit;

- (IBAction) choise:(id)sender;
- (void) save:(id) sender;

- (void) openPhoto;
- (void) takePhoto;
- (void) deletePhoto;
-(void) showAlert:(NSString*) message;
-(BOOL) validateEmail: (NSString *) email;
-(BOOL) validationConfirmPassword:(NSString*) firstPassword:(NSString*)  confirmPassword;

@end
