//
//  Entity.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@implementation Entity

@synthesize pk;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.pk = [Util get:dictionary key:@"id"];
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary]; 
    [Util add:dic value:self.pk key:@"id"];    
    return dic;
}

- (void) dealloc {
    [pk release];
    [super dealloc];
}

@end
