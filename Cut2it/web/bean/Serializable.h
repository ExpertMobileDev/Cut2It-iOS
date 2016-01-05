//
//  Serializable.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Serializable : NSObject

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;


@end
