//
//  ApplicationConfig.h
//  cut2it
//
//  Created by Eugene on 10/8/12.
//
//

#import "Serializable.h"

@interface ApplicationConfig : Serializable

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *value;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
