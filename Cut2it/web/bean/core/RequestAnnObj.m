//
//  RequestAnnObj.m
//  cut2it
//
//  Created by admin on 6/7/13.
//
//

#import "RequestAnnObj.h"

@implementation RequestAnnObj

@synthesize data;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:[data dictionary] key:@"annotations"];
    
    return dic;
}

- (void) dealloc {
}


@end
