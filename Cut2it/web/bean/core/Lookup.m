//
//  Lookup.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lookup.h"

@implementation Lookup


@synthesize name;
@synthesize path;
@synthesize lookup;
@synthesize type;
@synthesize info;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.name = [Util get:dictionary key:@"name"];
        self.path = [Util get:dictionary key:@"path"];
        self.lookup = [Util get:dictionary key:@"lookup"];
        self.type = [Util get:dictionary key:@"type"];
        self.info = [Util get:dictionary key:@"description"];       
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:self.name key:@"name"];
    [Util add:dic value:self.path key:@"path"];
    [Util add:dic value:self.lookup key:@"lookup"];
    [Util add:dic value:self.info key:@"description"];
    
    return dic;
}


- (void) dealloc {
    [name release];
    [path release];
    [lookup release];
    [type release];
    [info release];
    [super dealloc];
}

@end
