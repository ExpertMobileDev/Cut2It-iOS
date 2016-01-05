//
//  TreeNode.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

@synthesize parentId;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.parentId = [Util get:dictionary key:@"parentId"];       
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:self.parentId key:@"parentId"];
    
    return dic;
}


- (void) dealloc {
    [parentId release];
    [super dealloc];
}

@end
