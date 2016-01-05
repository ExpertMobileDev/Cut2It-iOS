//
//  UserProfile.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface UserProfile : Entity

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *firstname;
@property (retain, nonatomic) NSString *lastname;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *avatarResourceLookup;
@property (retain, nonatomic) NSString *temporaryFile;
@property (retain, nonatomic) NSString *userIdPk;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
