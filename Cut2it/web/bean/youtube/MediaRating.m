//
//  MediaRating.m
//  cut2it
//
//  Created by Eugene on 10/8/12.
//
//

#import "MediaRating.h"

@implementation MediaRating

@synthesize status;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        NSString *like = [Util get:dictionary key:@"likeStatus"];
        self.status = [like isEqualToString:@"LIKE"] ? LIKE: UNLIKE;
	}
	return self;
}

- (void) dealloc {
    [super dealloc];
}


@end
