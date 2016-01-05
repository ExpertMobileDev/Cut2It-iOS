//
//  VideoEntry.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Media.h"

@implementation Media

@synthesize videoId;
@synthesize title;
@synthesize description;
@synthesize youtubeUrl;
@synthesize duration;
@synthesize views;
@synthesize url;
@synthesize arrAnnotations;
// Bhavya - 08th Aug 2013
@synthesize thumbnailUrl;
@synthesize storageType;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.videoId = [Util get:dictionary key:@"videoId"];
        self.title = [Util get:dictionary key:@"title"];
        self.description = [Util get:dictionary key:@"description"];
        self.youtubeUrl = [Util get:dictionary key:@"youtubeUrl"];
        self.duration = [Util get:dictionary key:@"duration"];
        self.views = [Util get:dictionary key:@"viewsCount"];
        self.arrAnnotations = [Util getList:[Util get:dictionary key:@"annotations"] object:[Annotation class]];
        // Bhavya - 08th Aug 2013
        self.thumbnailUrl = [Util get:dictionary key:@"thumbnailUrl"];
        self.storageType = [Util get:dictionary key:@"storageType"];
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];

    [Util add:dic value:self.videoId key:@"videoId"];
    [Util add:dic value:self.title key:@"title"];
    [Util add:dic value:self.description key:@"description"];
    
    return dic;
}

- (void) dealloc{
    [videoId release];
    [title release];
    [description release];
    [youtubeUrl release];
    [duration release];
    [views release];
    [url release];
    [super dealloc];
}

@end
