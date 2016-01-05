//
//  ColorPicker.m
//  cut2it
//
//  Created by Eugene Maystrenko on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker

@synthesize slider;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha0;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *palette = [UIImage imageNamed:@"colorpicker_background"];

        UIImageView *background = [[UIImageView alloc] initWithImage:palette];
        background.frame = CGRectMake(22.5, 0, 5, 140);
        [self addSubview:background];
        [background release];
        
        self.slider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_slider"]];
        self.slider.center = CGPointMake(25, 5);
        [self addSubview:self.slider];
        [self.slider release];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(track:)];
        [self addGestureRecognizer:pan];
        [pan release];
      
        
        CGImageRef imageRef = palette.CGImage;
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        data = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
        bytesPerPixel = 4;
        bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                     bitsPerComponent, bytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(context);
        
   
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void) track:(UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self];
    if (point.y > 5 && point.y < self.frame.size.height - 5) {
        self.slider.center = CGPointMake(25, point.y);
    
        int byteIndex = 2 * bytesPerRow * point.y + 3 * bytesPerPixel;
        
        red    = data[byteIndex]     / 255.0;
        green  = data[byteIndex + 1] / 255.0;
        blue   = data[byteIndex + 2] / 255.0;
        alpha0 = data[byteIndex + 3] / 255.0;
    }
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void) dealloc {
    [slider release];
    free(data);
    [super dealloc];
}

@end
