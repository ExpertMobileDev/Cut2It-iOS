//
//  MediaRating.h
//  cut2it
//
//  Created by Eugene on 10/8/12.
//
//

#import "Entity.h"

typedef NS_OPTIONS(NSUInteger, LikeStatus) {
    UNKNOWN,
    LIKE,
    UNLIKE
};

@interface MediaRating : Entity

@property (nonatomic) LikeStatus status;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
