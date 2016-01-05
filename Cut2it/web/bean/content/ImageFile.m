//
//  ImageFile.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageFile.h"

@implementation ImageFile

@synthesize filename;
@synthesize orgFilename;
@synthesize width;
@synthesize height;
@synthesize updated;


- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
		self.filename = [Util get:dictionary key:@"filename"];
        self.orgFilename = [Util get:dictionary key:@"orgFilename"];
        self.width = [Util get:dictionary key:@"width"];
        self.height = [Util get:dictionary key:@"height"];
        self.updated = [Util get:dictionary key:@"updated"];
         
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    [Util add:dic value:self.filename key:@"filename"];
    [Util add:dic value:self.orgFilename key:@"orgFilename"];
    [Util add:dic value:self.width key:@"width"];
    [Util add:dic value:self.height key:@"height"];
    [Util add:dic value:self.updated key:@"updated"];

    return dic;
}

- (void) dealloc {
    [updated release];
    [filename release];
    [orgFilename release];
    [width release];
    [height release];
    [super dealloc];
}

@end
