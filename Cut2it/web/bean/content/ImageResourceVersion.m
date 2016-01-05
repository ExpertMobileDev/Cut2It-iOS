    //
    //  ImageResourceVersion.m
    //  Cut2it
    //
    //  Created by Eugene Maystrenko on 7/5/12.
    //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
    //

#import "ImageResourceVersion.h"

@implementation ImageResourceVersion

@synthesize title;
@synthesize culture;
@synthesize width;
@synthesize height;
@synthesize resourceFileOriginalName;
@synthesize resourceFileTemporaryName;
@synthesize version;

- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.title = [Util get:dictionary key:@"title"];
        self.culture = [Util get:dictionary key:@"culture"];
        self.width = [Util get:dictionary key:@"width"];
        self.height = [Util get:dictionary key:@"height"];
        self.resourceFileOriginalName = [Util get:dictionary key:@"resourceFileOriginalName"];
        self.resourceFileTemporaryName = [Util get:dictionary key:@"resourceFileTemporaryName"];
        self.version = [Util get:dictionary key:@"version"];
        
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:self.title key:@"title"];
    [Util add:dic value:self.culture key:@"culture"];
    [Util add:dic value:self.width key:@"width"];
    [Util add:dic value:self.height key:@"height"];
    [Util add:dic value:self.resourceFileOriginalName key:@"resourceFileOriginalName"];
    [Util add:dic value:self.resourceFileTemporaryName key:@"resourceFileTemporaryName"];
    [Util add:dic value:self.version key:@"version"];
    
    return dic;
}


- (void) dealloc {
    [title release];
    [culture release];
    [width release];
    [height release];
    [resourceFileOriginalName release];
    [resourceFileTemporaryName release];
    [version release];
    [super dealloc];
}
@end
