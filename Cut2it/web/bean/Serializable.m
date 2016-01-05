//
//  Serializable.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Serializable.h"

@implementation Serializable

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super init]) {
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    return [NSMutableDictionary dictionary];
}

@end
