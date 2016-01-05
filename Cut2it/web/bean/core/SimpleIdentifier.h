//
//  SimpleIdentifier.h
//  cut2it
//
//  Created by Eugene on 9/6/12.
//
//

#import "Serializable.h"

@interface SimpleIdentifier : Serializable

@property (retain, nonatomic) NSString *identifier;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
