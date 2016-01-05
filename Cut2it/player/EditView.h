//
//  EditView.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpViewController.h"
#import "PlayerDelegate.h"
#import "ShapeView.h"
#import "SliderControl.h"
#import "ColorPicker.h"

@interface EditView : UIControl {
    MarkedArea area;
    BOOL selected;
    BOOL markSelected;
    
}

@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic) SliderControl *sliderView;
@property (retain, nonatomic) ShapeView *shape;
@property (retain, nonatomic) UIButton *play;
@property (retain, nonatomic) UILabel *timeline;
@property (assign, nonatomic) id<PlayerDelegate> delegate;
@property (nonatomic) BOOL visible;
@property(retain,nonatomic)UIButton *mark;

- (void) showHideView;
- (void) changeShape: (id) sender;
- (void) playerState:(MPMovieLoadState) state;
- (void) clearShape;

@end
