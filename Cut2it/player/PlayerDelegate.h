//
//  PlayerDelegate.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaRating.h"

@protocol PlayerDelegate <NSObject>

struct MarkedArea {
    NSUInteger  type;
    CGFloat time;
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    CGFloat angle;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
};
typedef struct MarkedArea MarkedArea;

@required
- (void) share:(float) start end:(float) end area:(MarkedArea) area;
@optional
- (void) shareVideo;
- (MediaRating *) loadLike;
- (void) like;
- (void) unlike;
- (void) close;
@end
