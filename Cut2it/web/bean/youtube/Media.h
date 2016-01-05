//
//  VideoEntry.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "Annotation.h"

@interface Media : Entity

@property (retain, nonatomic) NSString *videoId;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *youtubeUrl;
@property (retain, nonatomic) NSString *duration;
@property (retain, nonatomic) NSNumber *views;
@property (retain, nonatomic) NSURL *url;
@property (retain, nonatomic) NSArray *arrAnnotations;
// Bhavya - 08th Aug 2013
@property (retain, nonatomic) NSString *thumbnailUrl;
@property (retain, nonatomic) NSString *storageType;

- (id) initWithDictionary:(NSDictionary *) dictionary;
- (NSMutableDictionary *) dictionary;

@end
