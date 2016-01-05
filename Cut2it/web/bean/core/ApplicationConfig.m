//
//  ApplicationConfig.m
//  cut2it
//
//  Created by Eugene on 10/8/12.
//
//

#import "ApplicationConfig.h"

@implementation ApplicationConfig

@synthesize name;
@synthesize value;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.name = [Util get:dictionary key:@"name"];
        self.value = [Util get:dictionary key:@"value"];
	}
	return self;
}

- (void) dealloc{
    [name release];
    [value release];
    [super dealloc];
}
@end
