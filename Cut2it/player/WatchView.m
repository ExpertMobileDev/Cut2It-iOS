//
//  WatchView.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WatchView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define START 81
#define END 354
#define RANGE 25

@implementation WatchView

@synthesize player;
@synthesize list;
@synthesize message;
@synthesize delegate;
@synthesize visible;

- (id)initWithFrame:(CGRect)frame title:(NSString *) t {
    
   self = [super initWithFrame:frame];
   if (self) {
      // Initialization code
      self.backgroundColor = [UIColor clearColor];
      
      selectCommentView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, 216, 13)];
      selectCommentView.image = [UIImage imageNamed:@"select&comment-btn.png"];
      //top.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_background_top"]];
      //selectCommentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_background_top"]];;
      //selectCommentView.alpha=0.8;
      selectCommentView.tag = 300;
      // selectCommentView.frame = CGRectOffset(selectCommentView.frame, 0, -selectCommentView.frame.size.height);
      selectCommentView.hidden = YES;
      selectCommentView.userInteractionEnabled = YES;
      //[selectCommentView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
      //[selectCommentView.layer setBorderWidth: 1.0];
      //selectCommentView.layer.cornerRadius = 2.5;
      //selectCommentView.layer.masksToBounds = YES;
      //selectCommentView.layer.borderColor = [UIColor whiteColor].CGColor;
      [self addSubview:selectCommentView];
      [selectCommentView release];
      
      /*
       UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, 256, 20)];
       selectLabel.backgroundColor = [UIColor clearColor];
       selectLabel.textColor = [UIColor whiteColor];
       selectLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
       selectLabel.text = @"SELECT & COMMENT";
       [selectCommentView addSubview:selectLabel];
       [selectLabel release];
       */
      
      
      top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 40)];
      top.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_background_top"]];
      //top.backgroundColor = [UIColor redColor];
      // top.frame = CGRectOffset(top.frame, 0, -top.frame.size.height);
      //top.frame = CGRectOffset(top.frame, 0, top.frame.size.height);
      top.hidden = NO;
      [self addSubview:top];
      [top release];
      
      UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 256, 20)];
      title.backgroundColor = [UIColor clearColor];
      title.textColor = [UIColor whiteColor];
      title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
      title.text = t;
      [top addSubview:title];
      [title release];
      
      like = [[UIButton alloc] initWithFrame:CGRectMake(329, 5, 30, 30)];
      [like setBackgroundImage:[UIImage imageNamed:@"vm_like_f"] forState:UIControlStateNormal];
      [like setBackgroundImage:[UIImage imageNamed:@"vm_like_a"] forState:UIControlStateHighlighted];
      [like setBackgroundImage:[UIImage imageNamed:@"vm_like_a"] forState:UIControlStateDisabled];
      [like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
      [top addSubview:like];
      [like release];
      
      unlike = [[UIButton alloc] initWithFrame:CGRectMake(370, 5, 30, 30)];
      [unlike setBackgroundImage:[UIImage imageNamed:@"vm_unlike_f"] forState:UIControlStateNormal];
      [unlike setBackgroundImage:[UIImage imageNamed:@"vm_unlike_a"] forState:UIControlStateHighlighted];
      [unlike setBackgroundImage:[UIImage imageNamed:@"vm_unlike_a"] forState:UIControlStateDisabled];
      [unlike addTarget:self action:@selector(unlike:) forControlEvents:UIControlEventTouchUpInside];
      [top addSubview:unlike];
      [unlike release];
      
      UIButton *scissors = [[UIButton alloc] initWithFrame:CGRectMake(412, 5, 30, 30)];
      [scissors setBackgroundImage:[UIImage imageNamed:@"vm_scissors_f"] forState:UIControlStateNormal];
      [scissors setBackgroundImage:[UIImage imageNamed:@"vm_scissors_a"] forState:UIControlStateHighlighted];
      [scissors addTarget:self action:@selector(swith:) forControlEvents:UIControlEventTouchUpInside];
      [top addSubview:scissors];
      [scissors release];
      
      UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(445, 5, 30, 30)];
      [share setBackgroundImage:[UIImage imageNamed:@"vm_share_f"] forState:UIControlStateNormal];
      [share setBackgroundImage:[UIImage imageNamed:@"vm_share_a"] forState:UIControlStateHighlighted];
      [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
      [top addSubview:share];
      [share release];
      
      menu = [[UIView alloc] initWithFrame:CGRectMake(340, 45, 135, 60)];
      menu.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_menu"]];
      menu.alpha = 0;
      [self addSubview:menu];
      [menu release];
      
      UIButton *video = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, 133, 29)];
      video.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
      video.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [video setTitle:@"    Entire Video" forState:UIControlStateNormal];
      [video setBackgroundImage:[UIImage imageNamed:@"vm_menu_top"] forState:UIControlStateHighlighted];
      [video addTarget:self action:@selector(video:) forControlEvents:UIControlEventTouchUpInside];
      [menu addSubview:video];
      [video release];
      
      UIButton *segment = [[UIButton alloc] initWithFrame:CGRectMake(1, 30, 133, 29)];
      segment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
      segment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [segment setTitle:@"    Select Segment" forState:UIControlStateNormal];
      [segment setBackgroundImage:[UIImage imageNamed:@"vm_menu_bottom"] forState:UIControlStateHighlighted];
      [segment addTarget:self action:@selector(segment:) forControlEvents:UIControlEventTouchUpInside];
      [menu addSubview:segment];
      [segment release];
      
      UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 480, 40)];
      bottom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_background"]];
      [self addSubview:bottom];
      [bottom release];
      
      play = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
      [play setImage:[UIImage imageNamed:@"play_f"] forState:UIControlStateNormal];
      [play setImage:[UIImage imageNamed:@"play_a"] forState:UIControlStateHighlighted];
      [play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
      [bottom addSubview:play];
      [play release];
      
      UIButton *stop = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
      [stop setImage:[UIImage imageNamed:@"vm_stop_f"] forState:UIControlStateNormal];
      [stop setImage:[UIImage imageNamed:@"vm_stop_a"] forState:UIControlStateHighlighted];
      [stop addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
      [bottom addSubview:stop];
      [stop release];
      
      close = [[UIButton alloc] initWithFrame:CGRectMake(440, 5, 30, 30)];
      [close setImage:[UIImage imageNamed:@"vm_close_f"] forState:UIControlStateNormal];
      [close setImage:[UIImage imageNamed:@"vm_close_a"] forState:UIControlStateHighlighted];
      [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
      close.enabled = NO;
      [bottom addSubview:close];
      [close release];
      
      playbackView = [[UIView alloc] initWithFrame:CGRectZero];
      playbackView.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
      playbackView.layer.cornerRadius = 4;
      [bottom addSubview:playbackView];
      [playbackView release];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(playBackChanged:)
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(playAnnotation:)
                                                   name:@"PlayAnnotationSegment"
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(close:)
                                                   name:@"ClosePlayerView"
                                                 object:nil];
       
       //pauseWhenReply
       
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(pauseandThenPlay:)
                                                    name:@"pauseWhenReply"
                                                  object:nil];
      
      [self performSelector:@selector(check) withObject:nil afterDelay:5];
      [self performSelector:@selector(showTOP) withObject:nil afterDelay:0.0];
      //        [NSTimer scheduledTimerWithTimeInterval:1.0
      //                                         target:self
      //                                       selector:@selector(showTOP:)
      //                                       userInfo:nil
      //                                        repeats:NO];
   }
   return self;
}

-(void)showTOP{
    //top.frame = CGRectOffset(top.frame, 0, top.frame.size.height);
    top.hidden = NO;
    [self performSelector:@selector(hideTop) withObject:nil afterDelay:4.0];
}

-(void)hideTop{
    //top.frame = CGRectOffset(top.frame, 0, -top.frame.size.height);
    top.hidden = YES;
    selectCommentView.hidden = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    for (Annotation *entity in self.list) {
        if (entity.mark && entity.markedArea.type != Clear) {
            MarkedArea area = entity.markedArea;
            CGRect point = CGRectMake(-area.width/2, -area.height/2, area.width, area.height);
            CGContextSetRGBStrokeColor(context, area.red,area.green,area.blue, area.alpha);
            
            CGContextTranslateCTM(context, area.x , area.y);
            CGContextRotateCTM(context, area.angle);
            if (area.type == Circle) {
                CGContextStrokeEllipseInRect(context, point);
            } else if (area.type == Square) {
                CGContextStrokeRect(context, point);
            } else if (area.type == Triangle) {
                CGContextMoveToPoint   (context, CGRectGetMidX(point), CGRectGetMinY(point));
                CGContextAddLineToPoint(context, CGRectGetMaxX(point), CGRectGetMaxY(point));
                CGContextAddLineToPoint(context, CGRectGetMinX(point), CGRectGetMaxY(point));
                CGContextClosePath     (context);
                CGContextStrokePath    (context);
            } else if (area.type == Arrow) {
                CGContextMoveToPoint   (context, CGRectGetMinX(point), CGRectGetMidY(point));
                CGContextAddLineToPoint(context, CGRectGetMaxX(point), CGRectGetMidY(point));
                CGContextMoveToPoint   (context, CGRectGetMinX(point), CGRectGetMidY(point) - 1);
                CGContextAddLineToPoint(context, CGRectGetMinX(point) + area.width/4, CGRectGetMidY(point) + 5);
                CGContextMoveToPoint   (context, CGRectGetMinX(point), CGRectGetMidY(point) - 1);
                CGContextAddLineToPoint(context, CGRectGetMinX(point) + area.width/4, CGRectGetMidY(point) - 5);
                CGContextStrokePath    (context);
            }
            CGContextRotateCTM(context, -area.angle);
            CGContextTranslateCTM(context, -area.x , -area.y);
        }
    }
}

- (void) playerState:(MPMovieLoadState) state {
    if ([delegate respondsToSelector:@selector(loadLike)]) {
        MediaRating *rating = [delegate loadLike];
        if (rating) {
            like.enabled = rating.status == UNLIKE;
            unlike.enabled = rating.status == LIKE;
            [rating release];
        }
    }
    
    duration = self.player.duration;
    range = (RANGE * duration) / (END - START);
    
    currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(377, 288, 47, 10)];
    currentLabel.backgroundColor = [UIColor clearColor];
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.font = [UIFont systemFontOfSize:12];
    currentLabel.text = [Util timeFormat:0];
    [self addSubview:currentLabel];
    [currentLabel release];
    
    UILabel *durationLable = [[UILabel alloc] initWithFrame:CGRectMake(377, 303, 47, 10)];
    durationLable.backgroundColor = [UIColor clearColor];
    durationLable.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    durationLable.font = [UIFont systemFontOfSize:12];
    durationLable.text = [Util timeFormat:duration];
    [self addSubview:durationLable];
    [durationLable release];
    
    self.message = [[MessageView alloc] initWithFrame:CGRectMake(5, 224, 470, 50)];
    self.message.delegate = delegate;
    [self addSubview:self.message];
    [self.message release];
    
    [self performSelector:@selector(check) withObject:nil afterDelay:2];
}

- (void) playBackChanged:(NSNotification *) notification {
   if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
      [play setImage:[UIImage imageNamed:@"pause_f"] forState:UIControlStateNormal];
      [play setImage:[UIImage imageNamed:@"pause_a"] forState:UIControlStateHighlighted];
      if (!top.hidden) {
         //top.frame = CGRectOffset(top.frame, 0, -top.frame.size.height);
         top.hidden = YES;
         selectCommentView.tag=300;
         //(150, 0, 200, 20)
         CGRect rect = CGRectMake(120, 0, 216, 13);
         selectCommentView.frame = rect;
      }
   } else {
      // selectCommentView.tag=300;
      [play setImage:[UIImage imageNamed:@"play_f"] forState:UIControlStateNormal];
      [play setImage:[UIImage imageNamed:@"play_a"] forState:UIControlStateHighlighted];
   }
}

- (void) check {
    close.enabled = YES;
}

- (void) replayAnnotation:(NSNumber *) annotationId {
    start = -1;
    end = -1;
    for (Annotation *annotation in self.list) {
        // Bhavya - Commented as it was showing exception 
        // if ([annotation.pk isEqualToNumber:annotationId]){
        if (annotation.pk.intValue == annotationId.intValue){
            [self playSegment:annotation.begin end:annotation.end];
            break;
        }
    }
}

-(void)pauseandThenPlay:(NSNotification*) notification{
    NSLog(@"pauseandThenPlay");
    [self.player pause];
    Annotation *annotation = [notification object];
    if(annotation){
        annotation.begin = self.player.currentPlaybackTime;
         
    }
}

- (void) playAnnotation:(NSNotification *) notification {
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    Annotation *annotation = notification.object;
    NSLog(@"player.CurrentPlayBack:%f",player.currentPlaybackTime);
    if (annotation) {
        [self playSegment:annotation.begin end:annotation.end];
        [self.player play];
    } else {
        
        [self.player pause];
    }
}

- (void) like:(UIButton *) sender {
    sender.enabled = NO;
    unlike.enabled = YES;
    if ([delegate respondsToSelector:@selector(like)]) {
        [delegate like];
    }
}

- (void) unlike:(UIButton *) sender {
    sender.enabled = NO;
    like.enabled = YES;
    if ([delegate respondsToSelector:@selector(unlike)]) {
        [delegate unlike];
    }
}

- (void) share:(id) sender {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         menu.alpha = menu.alpha == 0 ? 1:0;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) video:(id) sender {
    [self share:sender];
    if ([delegate respondsToSelector:@selector(shareVideo)]) {
        [delegate shareVideo];
    }
}

- (void) segment:(id) sender {
    [self share:sender];
    [self swith:sender];
}

- (void) play:(UIButton *) sender {
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        [self.player pause];
    } else {
        [self.player play];
        if (!message.hidden) [message done:sender];
        if (start !=-1) {
            EditView *view = (EditView *) [[self superview] viewWithTag:200];
            [view.sliderView current:start];
        }
        
    }
}

- (void) stop:(UIButton *) sender {
    [self.player pause];
    EditView *view = (EditView *) [[self superview] viewWithTag:200];
    [view.sliderView current:1];
    
    playbackView.frame = CGRectZero;
    start = -1;
    end = -1;
}

- (void) playSegment:(float) s end:(float) e {
    start = s;
    end = e;

    if (start != -1) {
        EditView *view = (EditView *) [[self superview] viewWithTag:200];
        [view.sliderView current:start];
    }
}

- (void) close:(id) sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"PlayAnnotationSegment"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ClosePlayerView"
                                                  object:nil];
    if ([delegate respondsToSelector:@selector(close)]) {
        [delegate close];
    }

}

- (void) playback:(SliderControl *) slider {
    float rate = (END - START) / duration;
    
    float currentTime = slider.sliderTime;
    if (isnan(currentTime)) return;
    
    currentLabel.text = [Util timeFormat:currentTime];
    playbackView.frame = CGRectMake(81, 16, (rate * currentTime), 8);
    
    for (Annotation *entity in self.list) {
        if (entity.button) entity.button.selected = NO;
    }
    
    for (Annotation *entity in self.list) {
        if (!entity.button) {
            for (Annotation *item in self.list) {
                if (entity != item && !item.sub && item.button && abs(entity.begin - item.begin) <= range) {
                    entity.button = item.button;
                    entity.sub = YES;
                    entity.button.tag = 11;
                    
                    UIImageView *multi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vm_plus"]];
                    multi.center = CGPointMake(12.5, 12.5);
                    [entity.button addSubview:multi];
                    [multi release];
                    break;
                }
            }
            
            if (!entity.button) {
                float position = (rate * entity.begin) + START;
                if (position > END) {
                    position = END;
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
                [button setImage:[UIImage imageNamed:@"vm_gray"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"vm_blue"] forState:UIControlStateHighlighted];
                [button setImage:[UIImage imageNamed:@"vm_blue"] forState:UIControlStateDisabled];
                [button setImage:[UIImage imageNamed:@"vm_white"] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(view:) forControlEvents:UIControlEventTouchUpInside];
                button.center = CGPointMake(position, 300);
                button.selected = NO;
                button.tag = 10;
                entity.button = button;
                entity.sub = NO;
                [self addSubview:button];
                [button  release];
            }
            
            for (Annotation *item in self.list) {
                if (entity != item && !item.button && !item.sub) {
                    if (abs(entity.begin - item.begin) <= range) {
                        if (entity.button.tag == 10) {
                            entity.button.tag = 11;
                            UIImageView *multi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vm_plus"]];
                            multi.center = CGPointMake(12.5, 12.5);
                            [entity.button addSubview:multi];
                            [multi release];
                        }
                        item.button = entity.button;
                        item.sub = YES;
                    }
                }
            }
        }
        
        if (entity.button.enabled) {
            entity.button.selected = entity.button.selected || (entity.begin < currentTime && entity.end > currentTime && currentTime != duration);
        }
    }
    
    [self setNeedsDisplay];
    
    if (self.player.playbackState == MPMoviePlaybackStatePlaying && end != -1 && currentTime >= end) {
        [self.player pause];
    }
}

- (void) showHideView {
    [UIView beginAnimations:@"showHideView" context:NULL];
	if (visible) {
		self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
	} else {
        self.frame = CGRectOffset(self.frame, self.frame.size.width, 0);
	}
    [UIView commitAnimations];
    self.visible = !self.visible;
    
    
    
}

- (void) view:(UIButton *) sender {
    if (!message.hidden) {
        [message clear];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (Annotation *entity in self.list) {
        if ([sender isEqual:entity.button]) {
            [array addObject:entity];
        }
    }
    [self.player pause];
    [message show:array];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
   UITouch *_touch = [[event allTouches] anyObject];
   if(_touch.view.tag == 300){
      if (top.hidden){
         top.hidden = NO;
         [self.player pause];
         //(150, 0, 200, 20)
         CGRect rect = top.frame;
         rect.origin.x=120;
         rect.origin.y = rect.origin.y + rect.size.height;
         rect.size.width =216;
         rect.size.height = 13;
         selectCommentView.frame = rect;
         selectCommentView.tag=302;
      }
      else {
         [self.player play];
         //selectCommentView.tag=301;
      }
   }
   
   CGPoint point = [[touches anyObject] locationInView:self];
   if (message.hidden && point.y < 280 && 40 < point.y) {
      [UIView beginAnimations:@"showHideViewTopPanel" context:NULL];
      if (top.hidden) {
         //top.frame = CGRectOffset(top.frame, 0, top.frame.size.height);
         [self.player pause];
         top.hidden = NO;
         //(150, 0, 200, 20)
         CGRect rect = top.frame;
         rect.origin.x=120;
         rect.origin.y = rect.origin.y + rect.size.height;
         rect.size.width =216;
         rect.size.height = 13;
         selectCommentView.frame = rect;
         selectCommentView.tag=302;
      } else {
         [self.player play];
      }
      [UIView commitAnimations];
   }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   
   UITouch *aTouch = [touches anyObject];
   
   //here you have location of user's finger
   CGPoint location = [aTouch locationInView:self];
   if (message.hidden && location.y < 280 && 40 < location.y) {
      [UIView beginAnimations:@"showHideViewTopPanel" context:NULL];
      if (top.hidden) {
         //top.frame = CGRectOffset(top.frame, 0, top.frame.size.height);
         [self.player pause];
         top.hidden = NO;
         //(150, 0, 200, 20)
         CGRect rect = top.frame;
         rect.origin.x=120;
         rect.origin.y = rect.origin.y + rect.size.height;
         rect.size.width =216;
         rect.size.height = 13;
         selectCommentView.frame = rect;
      } else {
         [self.player play];
      }
      [UIView commitAnimations];
   }
   
   
}

- (void) swith:(id) sender {
    BOOL help = [Util getBoolProperties:HELP];
    if (!help) {
        HelpViewController *blank = [[HelpViewController alloc] init];
        [(BaseViewController *) delegate presentModalViewController:blank animated:NO];
        [blank release];
    }
    
    [self showHideView];
    EditView *view = (EditView *) [[self superview] viewWithTag:200];
    [view showHideView];
    [view.sliderView current];
    [self.player pause];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"PlayAnnotationSegment"
                                                  object:nil];
    [player release];
    [list release];
    [message release];
    [super dealloc];
}

@end
