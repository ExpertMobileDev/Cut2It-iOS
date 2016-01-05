//
//  EditView.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditView.h"
#import "AppDelegate.h"

@class WatchView;

@implementation EditView

@synthesize player;
@synthesize sliderView;
@synthesize shape;
@synthesize play;
@synthesize timeline;
@synthesize delegate;
@synthesize visible;
@synthesize mark;

- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   if (self) {
      self.backgroundColor = [UIColor clearColor];
      self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
      self.visible = NO;
      
      self.timeline = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 160, 40)];
      self.timeline.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timefragment_background"]];
      self.timeline.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
      self.timeline.textAlignment = UITextAlignmentCenter;
      self.timeline.textColor = [UIColor whiteColor];
      self.timeline.shadowColor = [UIColor blackColor];
      [self addSubview:self.timeline];
      [self.timeline release];
      
      UIImage *img = [UIImage imageNamed:@"bar_panel"];
      
      UIImageView *top = [[UIImageView alloc] initWithImage:img];
      top.frame = CGRectMake(0, 0, 480, 40);
      [self addSubview:top];
      [top release];
      
      UIImageView *bottom = [[UIImageView alloc] initWithImage:img];
      bottom.frame = CGRectMake(0, 280, 480, 40);
      [self addSubview:bottom];
      [bottom release];
      
      UIButton *help = [[UIButton alloc] initWithFrame:CGRectMake(10, 285, 30, 30)];////(165, 285, 30, 30)
      [help setImage:[UIImage imageNamed:@"help_f"] forState:UIControlStateNormal];
      [help setImage:[UIImage imageNamed:@"help_a"] forState:UIControlStateHighlighted];
      [help addTarget:self action:@selector(help:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:help];
      [help release];
      
      
      self.shape = [[ShapeView alloc] initWithFrame:CGRectMake(0, 80, 120, 210)];//(0, 80, 120, 210)
      [self.shape addTarget:self action:@selector(changeShape:) forControlEvents:UIControlEventValueChanged];
      [self addSubview:self.shape];
      [self.shape release];
      
      self.play = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
      [self.play setImage:[UIImage imageNamed:@"pause_f"] forState:UIControlStateNormal];
      [self.play setImage:[UIImage imageNamed:@"pause_a"] forState:UIControlStateHighlighted];
      [self.play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.play];
      [self.play release];
      
      
      mark = [[UIButton alloc] initWithFrame:CGRectMake(45, 285, 30, 30)];//(45, 285, 30, 30)
       mark.tag = 101;
      [mark setImage:[UIImage imageNamed:@"mark_f"] forState:UIControlStateNormal];
      [mark setImage:[UIImage imageNamed:@"mark_a"] forState:UIControlStateHighlighted];
      [mark setImage:[UIImage imageNamed:@"mark_a"] forState:UIControlStateSelected];
      [mark addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:mark];
      [self.mark release];
       
      /*
       UIImageView *cut2it = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"se_cut2it"]];
       cut2it.frame = CGRectMake(226.5, 290, 27.5, 20);
       [self addSubview:cut2it];
       [cut2it release];
       */
      
      
      UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(360, 290, 61, 24)];
      [share setImage:[UIImage imageNamed:@"NEXT-btn.png"] forState:UIControlStateNormal];
      [share setImage:[UIImage imageNamed:@"NEXT-btn_blue.png"] forState:UIControlStateHighlighted];
      //NEXT-btn_blue.png
      //[share setImage:[UIImage imageNamed:@"vm_share_f"] forState:UIControlStateNormal];
      //[share setImage:[UIImage imageNamed:@"vm_share_a"] forState:UIControlStateHighlighted];
      [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:share];
      [share release];
       
      
      UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(440, 285, 30, 30)];
      [close setImage:[UIImage imageNamed:@"vm_close_f"] forState:UIControlStateNormal];
      [close setImage:[UIImage imageNamed:@"vm_close_a"] forState:UIControlStateHighlighted];
      [close addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:close];
      [close release];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(playBackChanged:)
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
      
      UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resize:)];
      pan.minimumNumberOfTouches = 1;
      pan.maximumNumberOfTouches = 2;
      [self addGestureRecognizer:pan];
      [pan release];
      
      UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
      [self addGestureRecognizer:rotation];
      [rotation release];
      
      [self clearShape];
   }
   return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (area.type != Clear) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect point = CGRectMake(- area.width/2, - area.height/2, area.width, area.height);
        CGRect select = CGRectMake(- area.width/2-3, - area.height/2-3, area.width+6, area.height+6);
        CGContextSetRGBStrokeColor(context, area.red,area.green,area.blue, area.alpha);
        CGContextSetLineWidth(context, 5);
        
        CGContextTranslateCTM(context, area.x , area.y);
        CGContextRotateCTM(context, area.angle);
        if (area.type == Circle) {
            CGContextStrokeEllipseInRect(context, point);
            if (selected) {
                CGContextSetLineWidth(context, 2);
                CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
                CGContextStrokeEllipseInRect(context, select);
            }
        } else if (area.type == Square) {
            CGContextStrokeRect(context, point);
            if (selected) {
                CGContextSetLineWidth(context, 2);
                CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
                CGContextStrokeRect(context, select);
            }
        } else if (area.type == Triangle) {
            CGContextMoveToPoint   (context, CGRectGetMidX(point), CGRectGetMinY(point));
            CGContextAddLineToPoint(context, CGRectGetMaxX(point), CGRectGetMaxY(point));
            CGContextAddLineToPoint(context, CGRectGetMinX(point), CGRectGetMaxY(point));
            CGContextClosePath     (context);
            CGContextStrokePath    (context);
            if (selected) {
                CGContextSetLineWidth(context, 2);
                CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
                CGContextMoveToPoint   (context, CGRectGetMidX(select), CGRectGetMinY(select));
                CGContextAddLineToPoint(context, CGRectGetMaxX(select), CGRectGetMaxY(select));
                CGContextAddLineToPoint(context, CGRectGetMinX(select), CGRectGetMaxY(select));
                CGContextClosePath     (context);
                CGContextStrokePath    (context);
            }
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

- (void) changeShape: (id) sender {
    area.type = shape.type;
    if (area.type == Clear) {
        [self clearShape];
    }
    [self setNeedsDisplay];
    
}

- (void) color:(ColorPicker *) sender {
    area.red = sender.red;
    area.green = sender.green;
    
    area.blue = sender.blue;
    area.alpha = sender.alpha0;
    
    [self setNeedsDisplay];
}

- (void) clearShape {
    area.x = self.frame.size.width/2;
    area.y = self.frame.size.height/2;
    area.width = 50;
    area.height = 50;
    area.angle = 0;
    area.red = 1;
    area.green = 1;
    area.blue = 1;
    area.alpha = 1;
    selected = NO;
    
}

- (void) resize:(UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateEnded) {
        timeline.highlighted = NO;
    }
    if (selected) {
        if (sender.numberOfTouches == 1) {
            if (point.y > 45) {
                area.x = point.x;
                area.y = point.y;
                [self setNeedsDisplay];
            }
        } else if (sender.numberOfTouches == 2) {
            CGPoint one = [sender locationOfTouch:0 inView:self];
            CGPoint two = [sender locationOfTouch:1 inView:self];
            
            area.width = fabs(one.x - two.x);
            area.height = fabs(one.y - two.y);
            
            [self setNeedsDisplay];
        }
    } else if (timeline.highlighted) {
        float x = point.x < 405 && 65 < point.x ? point.x : timeline.center.x;
        float y = point.y < 265 && 60 < point.y ? point.y : timeline.center.y;
        timeline.center = CGPointMake(x, y);
    }
}

- (void) rotation:(UIRotationGestureRecognizer *) sender {
    area.angle = sender.rotation;
    [self setNeedsDisplay];
}

- (void) play:(UIButton *) sender {
   
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
         sliderView.manualSelect=YES;
        [self.player pause];
    } else {
        sliderView.manualSelect=NO;
        [self.player play];
    }
}

- (void) help:(UIButton *) sender {
    HelpViewController *blank = [[HelpViewController alloc] init];
    [(BaseViewController *) delegate presentModalViewController:blank animated:NO];
    [blank release];
}

- (void) mark:(UIButton *) sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    sender.selected = !sender.selected;
    markSelected = !markSelected;
    //appDelegate.markupSelected = !appDelegate.markupSelected;
    selected = NO;
   appDelegate.markupSelected = !appDelegate.markupSelected;
    //[sliderView markupSelected:appDelegate.markupSelected];
    [self.shape showHideView];
    [self setNeedsDisplay];
}

- (void) share:(id) sender {
    [self.player pause];
    
    area.time = self.sliderView.sliderTime;
    
    if ([delegate respondsToSelector:@selector(share:end:area:)]) {
        [delegate share:self.sliderView.leftTime end:self.sliderView.rightTime area:area];
	}
    shape.type = Clear;
    //selected=YES;
    if(shape.hidden==NO){
        self.shape.alpha = 0.0;
    }
    
    [self changeShape:nil];
    //[self.shape showHideView];

    //[self mark:nil];
    if(mark.selected){
    mark.selected = NO;
    
    }
    if(mark.highlighted){
        mark.highlighted=NO;
    }
    
    
    [mark setImage:[UIImage imageNamed:@"mark_f"] forState:UIControlStateNormal];
    [sliderView clean];
}




- (void) sigmentTime:(SliderControl *) sender {
    
    NSString *start = [Util timeFormat:sender.leftTime];
    NSString *end = [Util timeFormat:sender.rightTime];
    
    self.timeline.text = [NSString stringWithFormat:@"%@ - %@", start, end];
    /*
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.markupSelected){
        NSLog(@"appDelegate.markupSelected");
        if ([start isEqualToString:end]) {
            NSLog(@"Equal");
            int hours = sender.rightTime / 3600;
            int minutes = sender.rightTime / 60;
            int sec = fabs(round((int)sender.rightTime % 60));
            
            NSString *ch = hours <= 9 ? @"0": @"";
            NSString *cm = minutes <= 9 ? @"0": @"";
            sec = sec + 1;
            NSString *cs = sec <= 9 ? @"0": @"";
            NSString *finalStr = [NSString stringWithFormat:@"%@%i:%@%i:%@%i", ch, hours, cm, minutes, cs, sec];
            self.timeline.text = [NSString stringWithFormat:@"%@ - %@", start, finalStr];
            //return [NSString stringWithFormat:@"%@%i:%@%i:%@%i", ch, hours, cm, minutes, cs, sec];

        }
        
        else{
            self.timeline.text = [NSString stringWithFormat:@"%@ - %@", start, end];
        }
    }
    
    else{
        self.timeline.text = [NSString stringWithFormat:@"%@ - %@", start, end];
    }
     */
    
}

- (void) playerState:(MPMovieLoadState) state {
    if (!self.sliderView) {
        
        self.sliderView = [[SliderControl alloc] initWithFrame:CGRectMake(55, 0, 415, 45) player:self.player];
        [self.sliderView addTarget:[[self superview] viewWithTag:100] action:@selector(playback:) forControlEvents:UIControlEventValueChanged];
        [self.sliderView addTarget:self action:@selector(sigmentTime:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.sliderView];
        [self.sliderView release];
        
        
    }
}

- (void) playBackChanged:(NSNotification*) notification {
    
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        sliderView.manualSelect =NO;
        [self.play setImage:[UIImage imageNamed:@"pause_f"] forState:UIControlStateNormal];
        [self.play setImage:[UIImage imageNamed:@"pause_a"] forState:UIControlStateHighlighted];
    } else {
        sliderView.manualSelect=YES;
        [self.play setImage:[UIImage imageNamed:@"play_f"] forState:UIControlStateNormal];
        [self.play setImage:[UIImage imageNamed:@"play_a"] forState:UIControlStateHighlighted];

    }
}
//Commented By Anand HSPL on 7/2/2012
/*
- (void) showHideView {
    [UIView beginAnimations:@"showHideEdit" context:NULL];
	if (visible) {
		self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
	} else {
        self.frame = CGRectOffset(self.frame, self.frame.size.width, 0);
	}
    [UIView commitAnimations];
    self.visible = !self.visible;
 
 
}
 */

//Chanaged By Anand HSPL on 7/2/2012
- (void) showHideView {
    [UIView beginAnimations:@"showHideEdit" context:NULL];
	if (visible) {
		self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
        //saumiya 5 Feb
        //[self.sliderView close];
	} else {
        self.frame = CGRectOffset(self.frame, self.frame.size.width, 0);
	}
    [UIView commitAnimations];
    self.visible = !self.visible;
}
//Change End

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
    CGPoint point = [[touches anyObject] locationInView:self];
    timeline.highlighted = CGRectContainsPoint(self.timeline.frame, point);
    
    CGRect rect = CGRectMake(area.x - area.width/2, area.y - area.height/2, area.width, area.height);
    selected = CGRectContainsPoint(rect, point);
    [self setNeedsDisplay];
}

- (void) change:(UIButton *) sender {
    
    shape.type = Clear;
    //selected=YES;
    if(shape.hidden==NO){
        self.shape.alpha = 0.0;
    }
    
    
    [self changeShape:nil];
    //[self.shape showHideView];
    
    //[self mark:nil];
    if(mark.selected){
        mark.selected = NO;
        
    }
    if(mark.highlighted){
        mark.highlighted=NO;
    }
    
    
    [mark setImage:[UIImage imageNamed:@"mark_f"] forState:UIControlStateNormal];
    
    [self showHideView];
    WatchView *view = (WatchView *) [[self superview] viewWithTag:100];
    [view showHideView];
    [self.sliderView clean];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    [sliderView close];
    [player release];
    [sliderView release];
    [shape release];
    [play release];
    [timeline release];
    [mark release];
    [super dealloc];
}

@end
