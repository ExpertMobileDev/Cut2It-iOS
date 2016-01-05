//
//  SliderControl.m
//  cut2it
//
//  Created by Eugene Maystrenko on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SliderControl.h"
#import "AppDelegate.h"

CGFloat const VISIBLE_WIDTH = 365;

@implementation SliderControl

@synthesize player;
@synthesize timer;
@synthesize left;
@synthesize right;
@synthesize leftShadow;
@synthesize rightShadow;
@synthesize sliderTime;
@synthesize leftTime;
@synthesize rightTime;
@synthesize manualSelect;

- (id)initWithFrame:(CGRect) frame player:(MPMoviePlayerController *) p {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.player = p;
        
        [NSThread detachNewThreadSelector:@selector(loadThums:) toTarget:self withObject:nil];
        
        replay = [[UIButton alloc] initWithFrame:CGRectMake(385, 5, 30, 30)];
        [replay setImage:[UIImage imageNamed:@"replay_f"] forState:UIControlStateNormal];
        [replay setImage:[UIImage imageNamed:@"replay_a"] forState:UIControlStateHighlighted];
        [replay addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:replay];
        [replay release];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(track:)];
        [self addGestureRecognizer:pan];
        [pan release];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 40, VISIBLE_WIDTH, 5)];
        line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"progressbar_white"]];
        [self addSubview:line];
        [line release];
        
        playbackView = [[UIView alloc] initWithFrame:CGRectMake(5, 40, 0, 5)];
        playbackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"progressbar_red"]];
        [self addSubview:playbackView];
        [playbackView release];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    return self;
}

- (void) loadThums:(id) sender {
    duration = self.player.duration;
    float image_width = 40.5;
    float interval = duration * image_width/VISIBLE_WIDTH;
    sliderWidth = 5;
    
    if (interval != 0) {
        for (float i = 0; i <= duration; i+=interval) {
            UIImage *img = [self.player thumbnailImageAtTime:i timeOption:MPMovieTimeOptionNearestKeyFrame];
            if (!img) {
                i -= (interval-1);
                continue;
            }
            
            UIImageView *iview = [[UIImageView alloc] initWithImage:img];
            if (VISIBLE_WIDTH < (sliderWidth + image_width)) {
                image_width = VISIBLE_WIDTH - sliderWidth + 5;
            }
            iview.frame = CGRectMake(sliderWidth, 5, image_width, 30);
            [self addSubview:iview];
            [iview release];
            sliderWidth += image_width;
        }
    }
    
    rateWidth = VISIBLE_WIDTH / duration;
    rateTime = duration / VISIBLE_WIDTH;
    
    self.leftShadow = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftShadow.backgroundColor = [UIColor blackColor];
    self.leftShadow.alpha = 0.7;
    [self addSubview:self.leftShadow];
    [self.leftShadow release];
    
    self.rightShadow = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightShadow.backgroundColor = [UIColor blackColor];
    self.rightShadow.alpha = 0.7;
    [self addSubview:self.rightShadow];
    [self.rightShadow release];
    
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playback_background"]];
    [self addSubview:border];
    [border release];
    
    UIImage *segment_a = [UIImage imageNamed:@"segment_a"];//cancel_a@2x.png
   // UIImage *segment_a = [UIImage imageNamed:@"cancel_a@2x.png"];
    UIImage *segment_f = [UIImage imageNamed:@"segment_f"];//segment_f
    self.left = [[UIImageView alloc] initWithImage:segment_f highlightedImage:segment_a];
    self.left.center = CGPointMake(0, 20);
    [self addSubview:self.left];
    [self.left release];
    
    self.right = [[UIImageView alloc] initWithImage:segment_f highlightedImage:segment_a];
    self.right.center = CGPointMake(VISIBLE_WIDTH, 20);
    [self addSubview:self.right];
    [self.right release];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect) rect {
}

#pragma mark Touch tracking

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
    CGPoint point = [[touches anyObject] locationInView:self];
    left.highlighted = CGRectContainsPoint(self.left.frame, point);
    right.highlighted = CGRectContainsPoint(self.right.frame, point);
    
}
//Commented by Anand HSPL on 07/2/2013
/*
- (void) track:(UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
        left.highlighted = NO;
        right.highlighted = NO;
        left.highlighted = NO;
        right.highlighted = NO;
        [self update];
    }
    
    if (left.highlighted && point.x < self.right.center.x - 13 && point.x > 0) {
        self.left.center = CGPointMake(point.x, self.left.center.y);
        self.leftShadow.frame = CGRectMake(5, 5, point.x, 30);
    } else if (right.highlighted && point.x > self.left.center.x + 13 && point.x < VISIBLE_WIDTH) {
        float current = point.x * rateTime;
        self.player.currentPlaybackTime = current;
        self.right.center = CGPointMake(point.x, self.right.center.y);
        self.rightShadow.frame = CGRectMake(point.x, 5, sliderWidth - point.x, 30);
    }
}
 */

//Changed By Anand HSPL on 7/02/2013
- (void) track:(UIPanGestureRecognizer *) sender {
    //NSLog(@"track");
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        left.highlighted = NO;
        right.highlighted = NO;
        left.highlighted = NO;
        right.highlighted = NO;
        self.manualSelect= YES;
        [self update];
    }

    
    if (left.highlighted && point.x < self.right.center.x - 13 && point.x > 0) {
        self.left.center = CGPointMake(point.x, self.left.center.y);
        self.leftShadow.frame = CGRectMake(5, 5, point.x, 30);
       // NSLog(@"left center %@",NSStringFromCGPoint(self.left.center));
    } else if (right.highlighted && point.x > self.left.center.x + 13 && point.x < VISIBLE_WIDTH) {
        float current = point.x * rateTime;
        self.player.currentPlaybackTime = current;
        self.right.center = CGPointMake(point.x, self.right.center.y);
        
        self.rightShadow.frame = CGRectMake(point.x, 5, sliderWidth - point.x, 30);
        [self.player pause];
       // NSLog(@"right center %@",NSStringFromCGPoint(self.right.center));
        
    }
}
// End Change

//Commented by Anand HSPL on 07/2/2013
/*
- (void) timer:(NSTimer *) t {
    if (close) [timer invalidate];
    float current = self.player.currentPlaybackTime;
    if (replayed && rightTime - current <= 1) {
        [self.player pause];
        [replay setImage:[UIImage imageNamed:@"replay_f"] forState:UIControlStateNormal];
        [replay setImage:[UIImage imageNamed:@"replay_a"] forState:UIControlStateHighlighted];
        replayed = NO;
        return;
    }
    if (!isnan(current)) {
        current = current * rateWidth;
        playbackView.frame = CGRectMake(5, 40, current, 5);
        if (!replayed) {
            if (self.left.center.x - current > 0) {
                current = self.left.center.x + 5;
            }
            self.right.center = CGPointMake(current + 10, self.left.center.y);
            self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
        }
        [self update];
    }
}
 
 
 */

//Changed By Anand HSPL on 7/02/2013
- (void) timer:(NSTimer *) t {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
    
    if (close) [timer invalidate];
    float current = self.player.currentPlaybackTime;
    if (replayed && rightTime - current <= 1) {
        
       // NSLog(@"Reached");
        [self.player pause];
        [replay setImage:[UIImage imageNamed:@"replay_f"] forState:UIControlStateNormal];
        [replay setImage:[UIImage imageNamed:@"replay_a"] forState:UIControlStateHighlighted];
        replayed = NO;
        
        return;
        
    }
    
    
    if (!isnan(current)) {
        current = current * rateWidth;
        playbackView.frame = CGRectMake(5, 40, current, 5);
       // NSLog(@"replayed %d",replayed);
       // NSLog(@"manualSelect:%d",self.manualSelect);

        
        if (!replayed) {
           // NSLog(@"Not replayed");
            /*
            if (self.left.center.x - current > 0) {
                current = self.left.center.x + 5;
            }
             */
            //NSLog(@"current %f",current);
              //if(rightTime - current >1)
           if(!self.manualSelect){
               //NSLog(@"not_manualSelect ");
               
               if (self.left.center.x - current > 0) {
                   current = self.left.center.x + 5;
               }

                self.right.center = CGPointMake(current + 10, self.left.center.y);
            //NSLog(@"rc timer %@",NSStringFromCGPoint(self.right.center));
            self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
                
            }
        }
        [self update];
    }
}

// End Change

- (void) update {
    
    self.sliderTime = playbackView.frame.size.width * rateTime;
    
    self.leftTime = self.left.center.x * rateTime;
    self.rightTime = (self.right.center.x - 9) * rateTime;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) current:(float) current {
    self.player.currentPlaybackTime = current;
    [self current];
}


- (void) current {
    NSLog(@"current");
    self.manualSelect = YES;
    float current = self.player.currentPlaybackTime;
    if (current == 0) current ++;
    
    self.left.center = CGPointMake((current - 1) * rateWidth, self.left.center.y);
    self.leftShadow.frame = CGRectMake(5, 5, self.left.center.x, 30);
    
    playbackView.frame = CGRectMake(5, 40, current * rateWidth, 5);
    self.right.center = CGPointMake(current * rateWidth + 13, self.left.center.y);
    self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
    [self update];
    
}

- (void) replay:(UIButton *) sender {
   //[self update];
    self.manualSelect = YES;
    [self update];
    
    
    if (replayed) {
        [replay setImage:[UIImage imageNamed:@"replay_f"] forState:UIControlStateNormal];
        [replay setImage:[UIImage imageNamed:@"replay_a"] forState:UIControlStateHighlighted];
        
        self.player.currentPlaybackTime = rightTime;
        [self.player pause];
       
    } else {
        [replay setImage:[UIImage imageNamed:@"vm_stop_f"] forState:UIControlStateNormal];
        [replay setImage:[UIImage imageNamed:@"vm_stop_a"] forState:UIControlStateHighlighted];
        
        [self.player play];
        self.player.currentPlaybackTime = leftTime;
    }
    
    replayed = !replayed;
}

-(void)markupSelected:(BOOL)selected{
    NSLog(@"markupSelected:%d",selected);
   
    if(selected){
        manualSelect=YES;
        if (self.timer != nil)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        CGPoint point = self.left.center;
        self.right.center = CGPointMake(point.x + 10 , self.left.center.y);
        NSLog(@"rc timer1:%@n %@",[Util timeFormat:self.leftTime],[Util timeFormat:self.rightTime]);
        self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
       
        [self performSelector:@selector(restartTimer) withObject:nil afterDelay:0.4];
            
    }
    else{
         manualSelect=NO;
        
                
        //self.player.currentPlaybackTime = rightTime;

       
        

    }
    [self update];
    
    /*
    if(selected){
        float current = self.player.currentPlaybackTime;;
        
        if (!isnan(current)) {
            //float current = point.x * rateTime;
            //float difference = self.rightTime-self.leftTime;
            //NSLog(@"difference:%f",difference);
            //self.player.currentPlaybackTime = self.leftTime;
            //current = current * rateWidth;
            //NSLog(@"current:%f",current);
            //if(difference>1.0){
            //  difference = 1.0;
            //}
            
            CGPoint point = self.left.center;
           
            self.right.center = CGPointMake(point.x + 10 , self.left.center.y);
            NSLog(@"rc timer1:%@n %@",[Util timeFormat:self.leftTime],[Util timeFormat:self.rightTime]);
            self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
            self.player.currentPlaybackTime = self.leftTime;
            [self.player pause];
             [self update];
            
        }
        
    }
    else{
         [self.player play];
         //self.player.currentPlaybackTime = self.rightTime;
         //[self update];
         NSLog(@"rc timer2:%@n %@",[Util timeFormat:self.leftTime],[Util timeFormat:self.rightTime]);
        
    }
    */
    
}

-(void)restartTimer{
     self.player.currentPlaybackTime = self.leftTime;
    if (self.timer == nil)
    {
        manualSelect=NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timer:)
                                                    userInfo:nil
                                                     repeats:YES];
        
    }
    
    

}

- (void) segment {
    NSLog(@"segment");
    float current = self.player.currentPlaybackTime;
    float x = current * rateWidth;
    if (self.left.center.x - x > 0) {
        x = self.left.center.x + 5;
    }
    self.right.center = CGPointMake(x + 10, self.left.center.y);
    self.rightShadow.frame = CGRectMake(self.right.center.x, 5, sliderWidth - self.right.center.x, 30);
    
    [self update];
}

- (void) clean {
    self.left.center = CGPointMake(0, self.left.center.y);
    self.manualSelect = YES;
    self.leftShadow.frame = CGRectMake(5, 5, 0, 30);
    self.right.center = CGPointMake(VISIBLE_WIDTH, self.right.center.y);
    self.rightShadow.frame = CGRectMake(sliderWidth, 5, 0, 30);
    
}

- (void) close {
    [timer invalidate];
    close = YES;
}

- (void) dealloc {
    [player release];
    [timer release];
    [left release];
    [right release];
    [leftShadow release];
    [rightShadow release];
    [super dealloc];
}

@end
