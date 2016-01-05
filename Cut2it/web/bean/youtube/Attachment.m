//
//  Attachment.m
//  cut2it
//
//  Created by Mac on 11/1/12.
//
//

#import "Attachment.h"

@interface Attachment ()

@end

@implementation Attachment


@synthesize attachmentType;
@synthesize temporaryFilename;
@synthesize opfResourceName;
@synthesize originalPath;
@synthesize uploadDate;
@synthesize imageUrl;
@synthesize thumbnailUrl;
@synthesize youtubeUrl;
@synthesize videoId;
@synthesize storageType;


- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        self.attachmentType = [Util get:dictionary key:@"attachmentType"];
        self.temporaryFilename = [Util get:dictionary key:@"temporaryFilename"];
        self.opfResourceName =[Util get:dictionary key:@"opfResourceName"];
        self.originalPath = [Util get:dictionary key:@"originalPath"];
        self.uploadDate = [Util get:dictionary key:@"uploadDate"];
        self.imageUrl = [Util get:dictionary key:@"imageUrl"];
        self.thumbnailUrl = [Util get:dictionary key:@"thumbnailUrl"];
        self.youtubeUrl = [Util get:dictionary key:@"youtubeUrl"];
        self.videoId = [Util get:dictionary key:@"videoId"]; 
       
        
        
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];

    [Util add:dic value:self.attachmentType key:@"attachmentType"];
    [Util add:dic value:self.temporaryFilename key:@"temporaryFilename"];
    [Util add:dic value:self.opfResourceName key:@"opfResourceName"];
    [Util add:dic value:self.originalPath key:@"originalPath"];
    [Util add:dic value:self.uploadDate key:@"uploadDate"];
    
    return dic;
}


- (void) dealloc {
    [uploadDate release];
    [originalPath release];
    [opfResourceName release];
    [temporaryFilename release];
    [attachmentType release];
    [_image release];
    [_progress release];
    [imageUrl release];
    
    [super dealloc];
}
@end
