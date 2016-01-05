//
//  ImageFile.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface ImageFile : Serializable

@property (retain, nonatomic) NSString *filename;
@property (retain, nonatomic) NSString *orgFilename;
@property (retain, nonatomic) NSString *height;
@property (retain, nonatomic) NSString *width;
@property (retain, nonatomic) NSString *updated;


- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
