//
//  Error.m
//  cut2it
//
//  Created by Eugene Maystrenko on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerError.h"

@implementation ServerError

@synthesize name;
@synthesize msg;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.name = [Util get:dictionary key:@"name"];
        self.msg = [Util get:dictionary key:@"msg"];
	}
	return self;
}

- (void) dealloc {
    [name release];
    [msg release];
    [super dealloc];
}

@end
