//
//  Request.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Request.h"

@implementation Request

@synthesize data;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:[data dictionary] key:@"data"];
    
    return dic;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}

@end
