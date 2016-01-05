//
//  TreeNode.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface TreeNode : Entity

@property (retain, nonatomic) NSNumber *parentId;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
