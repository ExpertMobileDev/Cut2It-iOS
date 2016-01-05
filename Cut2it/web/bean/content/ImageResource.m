//
//  ImageResource.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageResource.h"

@implementation ImageResource

@synthesize resourceVersion;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.resourceVersion = [[ImageResourceVersion alloc] initWithDictionary:[Util get:dictionary key:@"resourceVersion"]];
        
        [self.resourceVersion release];
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:[self.resourceVersion dictionary] key:@"resourceVersion"];
    
    return dic;
}

- (void) dealloc {
    [resourceVersion release];
    [super dealloc];
}

@end
