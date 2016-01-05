//
//  ColorPicker.h
//  cut2it
//
//  Created by Eugene Maystrenko on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPicker : UIControl {
    unsigned char *data;
    NSUInteger bytesPerPixel;
    NSUInteger bytesPerRow;
}

@property (retain, nonatomic) UIImageView *slider;
@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic) CGFloat alpha0;

@end