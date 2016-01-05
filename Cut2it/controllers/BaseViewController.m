//
//  BaseViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@class LoginViewController;

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize delegate;
@synthesize api;
@synthesize container;

- (id) init {
    self.delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.api = [Cut2itApi shared];
    self.container = [Container shared];
    return [super init];
}

- (void) viewWillAppear:(BOOL)animated {
    self.api.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    if (!self.delegate) self.delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (!self.api)self.api = [Cut2itApi shared];
    if (!self.container)
    {
        self.container = [Container shared];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction) back:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) error:(NSString *) message {
    NSLog(@"Error Message:%@",message);
    if (message) {
        [message retain];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        /*if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
            [UIView beginAnimations:@"Alert" context:nil];
            [UIView setAnimationDuration:0.1];
            alert.transform = CGAffineTransformRotate(alert.transform, M_PI/2);
            [UIView commitAnimations];
        }*/

    }
}

- (UIBarButtonItem *) createBarButtonWithName:(NSString *) name
                                        image:(NSString *) image
										width:(CGFloat) width
									   target:(id) target
									   action:(SEL) action {
	
	UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 32)];
	
	[button setTitle:name forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    if ([image isEqualToString:@"back"]) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    }

	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_%@_f", image]] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_%@_f", image]] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.layer.shadowOpacity = 1.0;   
    button.titleLabel.layer.shadowRadius = 0.0;
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button release];
	
	return item;
}

- (UIBarButtonItem *) createBarButtonWithImage:(NSString *) normal
									  selected:(NSString *) selected
										target:(id) target
										action:(SEL) action {
    
	UIImage *img_c = [UIImage imageNamed: normal];
	UIImage *img_h = [UIImage imageNamed: selected];
	
	UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, img_c.size.width, img_c.size.height)];
	
	[button setImage:img_c forState:UIControlStateNormal];
	[button setImage:img_h forState:UIControlStateSelected];
	[button setImage:img_h forState:UIControlStateHighlighted];
	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
	item.width=img_c.size.width;
	
	[button release];
	
	return item;
}

- (void) blankRotate {
//    UIViewController * blank = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//    [self presentModalViewController:blank animated:NO];
//    [self dismissModalViewControllerAnimated:NO];
//    [blank release];
}

- (void) setOrientation:(UIInterfaceOrientation)orientation {
    NSNumber* value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)dealloc {
	[delegate release];
    [api release];
    [container release];
    [super dealloc];
}

@end
