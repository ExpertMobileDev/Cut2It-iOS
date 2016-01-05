//
//  WatchView.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpViewController.h"
#import "PlayerDelegate.h"
#import "EditView.h"
#import "Annotation.h"
#import "SliderControl.h"
#import "ShapeView.h"
#import "MessageView.h"

@interface WatchView : UIView {
   UIImageView *selectCommentView;
    UILabel *currentLabel;
    UIView *playbackView;
    UIButton *play;
    UIView *menu;
    UIButton *like;
    UIButton *unlike;
    UIView *top;
    UIButton *close;
   //UIView *selectCommentView;
    //UILabel *selectLbl;
    float range;
    float start;
    float end;
    float duration;
}

@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic) NSArray *list;
@property (retain, nonatomic) MessageView *message;
@property (assign, nonatomic) id<PlayerDelegate, MessageDelegate> delegate;
@property (nonatomic) BOOL visible;

- (id)initWithFrame:(CGRect)frame title:(NSString *) title;
 
- (void) playerState:(MPMovieLoadState) state;
- (void) showHideView;
- (void) playback:(SliderControl *) slider;
- (void) playSegment:(float) start end:(float) end;
- (void) replayAnnotation:(NSNumber *) annotationId;

@end
