//
//  TitleViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController

@synthesize name;
@synthesize desc;
@synthesize customDelegate;
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView contentSizeToFit];

    self.navigationController.navigationBarHidden = NO;
    self.title = @"Add Title";
    
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"rounded" width:68 target:self action:@selector(backToCamera:)];
    UIBarButtonItem *next = [self createBarButtonWithName:@"Save" image:@"rounded" width:68 target:self action:@selector(save:)];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = next;
    
//    desc.layer.borderColor = [UIColor whiteColor].CGColor;
//    desc.layer.cornerRadius = 2;
//    
//    desc.autocapitalizationType = UITextAutocapitalizationTypeSentences;
//    name.autocapitalizationType = UITextAutocapitalizationTypeSentences;   

}

- (void)viewDidUnload {
    [super viewDidUnload];
     self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (BOOL)textViewShouldBeginEditing:(UITextView *) textView {
//    [UIView beginAnimations:@"resizeComent" context:NULL];
//    CGRect frame = self.desc.frame;
//    self.desc.frame =  CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 105);
//    textView.layer.borderWidth = 1;
//    [UIView commitAnimations];
    
    UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
    [save setTitle:@"Done" forState:UIControlStateNormal];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    [UIView beginAnimations:@"resizeComent1" context:NULL];
//    CGRect frame = self.desc.frame;
//    self.desc.frame =  CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 278);
//    textView.layer.borderWidth = 0;
//    [UIView commitAnimations];
    
    
    UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
    [save setTitle:@"Save" forState:UIControlStateNormal];
    return YES;
}

- (void) effect:(UIButton *) sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"Next"]) {
        EffectViewController *controller = [[EffectViewController alloc] init];
        controller.name = name.text;
        controller.desc = desc.text;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [desc resignFirstResponder];
    }

}

- (void) save:(UIButton *) sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"Save"]) {
        Media *media = [[Media alloc] init];
        media.title = name.text;
        media.description = desc.text;
        
        // Bhavya -  //Media *created = [self.api createMedia:media];
        Media *created = [self.api createMediaNewWithAnnotation:media :nil status:nil];
        
        NSLog(@"container %@",self.container);
        NSLog(@"container url %@",self.container.url);
        NSLog(@"created obj %@",created);


        // bhavya - added if condition
        if(created)
        {
            created.url = self.container.url;
            
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadMedia"                                             object: created];
            
        }
        
    } else {
        [desc resignFirstResponder];
    }
}

- (void) backToCamera:(UIButton *) sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    if(type == RecordType)
    {
    [self.customDelegate callCamera];
    }
    else if(type == LibraryType)
    {
    [self.customDelegate callVideoLibrary];
    }
    else{
        
    }
   
}

- (void)dealloc {
}

@end
