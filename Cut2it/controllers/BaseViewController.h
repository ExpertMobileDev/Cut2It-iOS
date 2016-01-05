//
//  BaseViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cut2itApi.h"
#import "Container.h"

@class AppDelegate;

@interface BaseViewController : UIViewController<APIDelegate>

@property (nonatomic, retain) AppDelegate *delegate;
@property (nonatomic, retain) Cut2itApi *api;
@property (nonatomic, retain) Container *container;

- (IBAction) back:(id)sender;
- (UIBarButtonItem *) createBarButtonWithName:(NSString *) name
                                        image:(NSString *) image
										width:(CGFloat) width
									   target:(id) target
									   action:(SEL) action;
- (UIBarButtonItem *) createBarButtonWithImage:(NSString *) normal
									  selected:(NSString *) selected
										target:(id) target
										action:(SEL) action;

- (void) setOrientation:(UIInterfaceOrientation)orientation;
- (void) blankRotate;
@end
