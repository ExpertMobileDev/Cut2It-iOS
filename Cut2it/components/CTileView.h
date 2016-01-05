//
//  CTileView.h
//  cut2it
//
//  Created by Eugene on 8/29/12.
//
//

#import <UIKit/UIKit.h>

@interface CTileView : UIView {
    CGImageRef image;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *) img;

@end
