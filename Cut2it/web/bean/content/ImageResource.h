//
//  ImageResource.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lookup.h"
#import "ImageResourceVersion.h"

@interface ImageResource : Lookup

@property (retain, nonatomic) ImageResourceVersion *resourceVersion;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
