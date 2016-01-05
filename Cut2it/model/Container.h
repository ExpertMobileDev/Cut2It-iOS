//
//  Container.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Media.h"

@interface Container : NSObject

+ (id) shared;

@property (retain, nonatomic) Media *selected;
@property (retain, nonatomic) UIView *playerView;
@property (retain, nonatomic) NSNumber *annotationId;
@property (retain, nonatomic) NSURL *url;
@property (nonatomic) CGRect screen;

@end
