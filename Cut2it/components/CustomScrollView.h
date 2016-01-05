//
//  CustomScrollView.h
//  cut2it
//
//  Created by Mac on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomScrollViewDelegate;

@interface CustomScrollView : UIScrollView {
    
	id <CustomScrollViewDelegate> customDelegate;
}

@property (nonatomic, assign) id <CustomScrollViewDelegate> customDelegate;

@end

@protocol CustomScrollViewDelegate

-(void)scrollTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)scrollTouchesEnd:(NSSet *)touches withEvent:(UIEvent *)event;

@end
