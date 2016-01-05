//
//  RequestAnnObj.h
//  cut2it
//
//  Created by admin on 6/7/13.
//
//

#import "Serializable.h"

@interface RequestAnnObj : Serializable

@property (retain, nonatomic) Serializable *data;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
