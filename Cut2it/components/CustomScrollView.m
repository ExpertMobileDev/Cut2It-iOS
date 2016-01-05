//
//  CustomScrollView.m
//  cut2it
//
//  Created by Mac on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

@synthesize customDelegate;


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"touches began");
	[self.customDelegate scrollTouchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	NSLog(@"touches end");
    [self.customDelegate scrollTouchesEnd:touches withEvent:event];
}

@end
