//
//  ImageResourceVersion.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface ImageResourceVersion : Entity

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *culture;
@property (retain, nonatomic) NSString *width;
@property (retain, nonatomic) NSString *height;
@property (retain, nonatomic) NSString *resourceFileOriginalName;
@property (retain, nonatomic) NSString *resourceFileTemporaryName;
@property (retain, nonatomic) NSString *version;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
