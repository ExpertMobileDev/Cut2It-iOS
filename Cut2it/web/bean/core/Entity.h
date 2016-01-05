//
//  Entity.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Serializable.h"

@interface Entity : Serializable

@property (retain, nonatomic) NSNumber *pk;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
