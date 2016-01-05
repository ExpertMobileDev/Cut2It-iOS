//
//  TitleViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "EffectViewController.h"
#import "TPKeyboardAvoidingScrollView.h"


#import <MobileCoreServices/UTCoreTypes.h>

typedef enum {
    RecordType,
    LibraryType
} CameraType;

@protocol TitleViewControllerDelegate
-(void) callCamera;
-(void) callVideoLibrary;
@end


@interface TitleViewController : BaseViewController <ASIHTTPRequestDelegate, UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextView *desc;
@property (retain, nonatomic) id <TitleViewControllerDelegate> customDelegate;
@property (nonatomic) int type;

@end
