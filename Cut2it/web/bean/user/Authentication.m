//
//  Authentication.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Authentication.h"

@implementation Authentication

@synthesize token;
@synthesize user;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.token = [Util get:dictionary key:@"token"];
        self.user = [[User alloc] initWithDictionary:[Util get:dictionary key:@"user"]];
        
        [user release];
	}
	return self;
}

- (void) dealloc{
    [token release];
    [user release];
    [super dealloc];
}

@end
