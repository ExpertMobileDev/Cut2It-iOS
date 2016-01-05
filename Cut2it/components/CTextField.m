//
//  CTextField.m
//  cut2it
//
//  Created by Eugene Maystrenko on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField

@synthesize indent;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 2;
    // Drawing code
}

- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 7, 16, 16);
}

- (CGRect)rightViewRectForBounds:(CGRect) bounds {
    return CGRectMake(274, 7, 16, 16);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , self.indent != 0 ? self.indent : 12 , 5 );
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , self.indent != 0 ? self.indent : 12  , 5 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , self.indent != 0 ? self.indent : 12  , 5 );
}

@end
