//
//  ShapeView.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPicker.h"

enum {
    Clear    = 0,
    Circle   = 1,
    Square   = 2,
    Triangle = 3,
    Arrow    = 4
    
}; typedef NSUInteger Shape;

@interface ShapeView : UIControl

@property (nonatomic) Shape type;

- (void) showHideView;
- (void) shape:(UIButton *) sender;

@end
