//
//  Error.h
//  cut2it
//
//  Created by Eugene Maystrenko on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface ServerError : Entity

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *msg;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
