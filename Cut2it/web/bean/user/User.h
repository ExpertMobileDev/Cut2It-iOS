//
//  User.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface User : Entity

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *firstName;
@property (retain, nonatomic) NSString *lastName;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *avatarResourceLookup;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
