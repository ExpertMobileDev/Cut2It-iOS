//
//  User.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize password;
@synthesize avatarResourceLookup;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.username = [Util get:dictionary key:@"username"];
        self.firstName = [Util get:dictionary key:@"firstName"];
        self.lastName = [Util get:dictionary key:@"lastname"];
        self.email = [Util get:dictionary key:@"email"];
        self.password = [Util get:dictionary key:@"password"];
        self.avatarResourceLookup = [Util get:dictionary key:@"avatarResourceLookup"];
	}
	return self;
}

- (void) dealloc{
    [username release];
    [super dealloc];
}

@end
