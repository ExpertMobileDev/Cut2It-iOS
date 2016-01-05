//
//  ShapeView.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShapeView.h"

@implementation ShapeView

@synthesize type;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_mark_area"]];
        [self addSubview:background];
        [background release];
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *circle = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 20, 30, 30)];
        circle.tag = Circle;
        [circle setImage:[UIImage imageNamed:@"s_circle_f"] forState:UIControlStateNormal];
        [circle setImage:[UIImage imageNamed:@"s_circle_a"] forState:UIControlStateHighlighted];
        [circle addTarget:self action:@selector(shape:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:circle];
        [circle release];
        
        UIButton *square = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 60, 30, 30)];
        square.tag = Square;
        [square setImage:[UIImage imageNamed:@"s_square_f"] forState:UIControlStateNormal];
        [square setImage:[UIImage imageNamed:@"s_square_a"] forState:UIControlStateHighlighted];
        [square addTarget:self action:@selector(shape:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:square];
        [square release];
        
        

        UIButton *triangle = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 100, 30, 30)];
        triangle.tag = Triangle;
        [triangle setImage:[UIImage imageNamed:@"s_triangle_f"] forState:UIControlStateNormal];
        [triangle setImage:[UIImage imageNamed:@"s_triangle_a"] forState:UIControlStateHighlighted];
        [triangle addTarget:self action:@selector(shape:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:triangle];
        [triangle release];

        
        UIButton *arrow = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 100, 30, 30)];
        arrow.tag = Arrow;
        [arrow setImage:[UIImage imageNamed:@"s_arrow_f"] forState:UIControlStateNormal];
        [arrow setImage:[UIImage imageNamed:@"s_arrow_a"] forState:UIControlStateHighlighted];
        [arrow addTarget:self action:@selector(shape:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:arrow];
        [arrow release];
        
        UIButton *clear = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 140, 30, 30)];
        clear.tag = Clear;
        [clear setImage:[UIImage imageNamed:@"s_delete_f"] forState:UIControlStateNormal];
        [clear setImage:[UIImage imageNamed:@"s_delete_a"] forState:UIControlStateHighlighted];
        [clear addTarget:self action:@selector(shape:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clear];
        [clear release];
        
        ColorPicker *colorPicker = [[ColorPicker alloc] initWithFrame:CGRectMake(62.5, 25, 50, 140)];
        [colorPicker addTarget:self.superview action:@selector(color:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:colorPicker];
        [colorPicker release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
}

- (void) showHideView {	
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = self.alpha == 0 ? 1:0;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) shape:(UIButton *) sender {
    self.type = (Shape) sender.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
