//
//  SliderControl.h
//  cut2it
//
//  Created by Eugene Maystrenko on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderControl : UIControl {
    UIView *playbackView;
    UIButton *replay;
    float sliderWidth;
    float rateWidth;
    float rateTime;
    float duration;
    BOOL replayed;
    BOOL close;
    BOOL manualSelect;
}

@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UIImageView *left;
@property (retain, nonatomic) UIImageView *right;
@property (retain, nonatomic) UIView *leftShadow;
@property (retain, nonatomic) UIView *rightShadow;
@property (nonatomic) float sliderTime;
@property (nonatomic) float leftTime;
@property (nonatomic) float rightTime;
@property(nonatomic,assign) BOOL manualSelect;

- (id)initWithFrame:(CGRect) frame player:(MPMoviePlayerController *) player;

- (void) current:(float) current;
- (void) current;
- (void) segment;
- (void) clean;
- (void) close;
-(void)markupSelected:(BOOL)selected;
    



@end
