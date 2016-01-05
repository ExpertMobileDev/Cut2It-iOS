//
//  Request.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Serializable.h"

@interface Request : Serializable

@property (retain, nonatomic) Serializable *data;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
