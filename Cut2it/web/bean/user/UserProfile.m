//
//  UserProfile.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize username;
@synthesize email;
@synthesize firstname;
@synthesize lastname;
@synthesize password;
@synthesize avatarResourceLookup;
@synthesize temporaryFile;
@synthesize userIdPk;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.username = [Util get:dictionary key:@"username"];
        self.email = [Util get:dictionary key:@"email"];
        self.firstname = [Util get:dictionary key:@"firstName"];
        self.lastname = [Util get:dictionary key:@"lastName"];
        self.password = [Util get:dictionary key:@"password"];
        self.avatarResourceLookup = [Util get:dictionary key:@"avatarResourceLookup"];
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:self.username key:@"username"];
    [Util add:dic value:self.email key:@"email"];
    [Util add:dic value:self.firstname key:@"firstName"];
    [Util add:dic value:self.lastname key:@"lastName"];
    [Util add:dic value:self.password key:@"password"];
    [Util add:dic value:self.avatarResourceLookup key:@"avatarResourceLookup"];
    [Util add:dic value:self.temporaryFile key:@"temporaryFile"];
    
    return dic;
}

- (void) dealloc {
    [username release];
    [email release];
    [firstname release];
    [lastname release];
    [password release];
    [avatarResourceLookup release];
    [temporaryFile release];
    [super dealloc];
}

@end
