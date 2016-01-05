//
//  Lookup.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeNode.h"

@interface Lookup : TreeNode

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *lookup;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *info;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
