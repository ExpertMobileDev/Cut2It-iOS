//
//  SimpleIdentifier.m
//  cut2it
//
//  Created by Eugene on 9/6/12.
//
//

#import "SimpleIdentifier.h"

@implementation SimpleIdentifier

@synthesize identifier;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.identifier = [Util get:dictionary key:@"identifier"];
	}
	return self;
}

- (void) dealloc{
    [identifier release];
    [super dealloc];
}


@end
