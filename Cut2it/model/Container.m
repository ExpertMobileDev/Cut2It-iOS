//
//  Container.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Container.h"

@implementation Container

static Container *instance;

@synthesize selected;
@synthesize annotationId;
@synthesize playerView;
@synthesize url;
@synthesize screen;

+ (id) shared {
    @synchronized([Container class]) {
        if (!instance){
            instance = [[self alloc] init];
            instance.screen = [[UIScreen mainScreen] bounds];
        }
        return instance;
    }
    
    return nil;
}

- (void) dealloc {
    [selected release];
    [annotationId release];
    [playerView release];
    [url release];
    [super dealloc];
}

@end
