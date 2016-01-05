//
//  CTileView.m
//  cut2it
//
//  Created by Eugene on 8/29/12.
//
//

#import "CTileView.h"

@implementation CTileView

- (id)initWithFrame:(CGRect)frame image:(UIImage *) img {
    self = [super initWithFrame:frame];
    if (self) {
        image = img.CGImage;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    
    CGRect imageRect;
	imageRect.origin = CGPointMake(0, 0);
	imageRect.size = CGSizeMake(width/2, height/2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextDrawTiledImage(context, imageRect, image);
}

@end
