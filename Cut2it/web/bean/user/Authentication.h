//
//  Authentication.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Serializable.h"
#import "User.h"

@interface Authentication : Serializable

@property (retain, nonatomic) NSString *token;
@property (retain, nonatomic) User *user;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
