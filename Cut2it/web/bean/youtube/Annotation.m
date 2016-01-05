//
//  AnnotationEntity.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation

@synthesize firstName;
@synthesize lastName;
@synthesize username;
@synthesize parenId;
@synthesize rootId;
@synthesize avatarLookUp;
@synthesize userId;


@synthesize videoId;
@synthesize mediaId;
@synthesize title;
@synthesize content;
@synthesize annotationType;
@synthesize markedArea;
@synthesize begin;
@synthesize end;
@synthesize button;
@synthesize mark;
@synthesize sub;

@synthesize viewHeight;
@synthesize contentHeight;
@synthesize parentAnnotation;
@synthesize imageAttachments;
@synthesize videoAttachments;
@synthesize childrenCount;
@synthesize isShowAttachments;
@synthesize attachmnets;



- (id) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.title = [Util get:dictionary key:@"title"];
        self.content = [Util get:dictionary key:@"content"];
        self.annotationType = [Util get:dictionary key:@"annotationType"];
        self.begin = [[Util get:dictionary key:@"startTime"] longValue];
        self.end = [[Util get:dictionary key:@"endTime"] longValue];
        self.parenId = [Util get:dictionary key:@"parentAnnotationId"];
        self.rootId = [Util get:dictionary key:@"rootAnnotationId"];
        self.userId = [Util get:dictionary key:@"userId"];
        self.firstName = [Util get:dictionary key:@"firstName"];
        self.lastName = [Util get:dictionary key:@"lastName"];
        self.username = [Util get:dictionary key:@"username"];
        self.avatarLookUp =[Util get:dictionary key:@"avatarLookup"];
        self.childrenCount = [[Util get:dictionary key:@"childrenCount"] longValue];
        self.imageAttachments = [Util getList:[Util get:dictionary key:@"imageAttachments"] object:[Attachment class]];
        self.videoAttachments =[Util getList:[Util get:dictionary key:@"videoAttachments"] object:[Attachment class]];
      
        NSString *area = [Util get:dictionary key:@"markedArea"];
        if (![Util isEmpty:area])
            self.markedArea = deserialize(area);
	}
	return self;
}

- (NSMutableDictionary *) dictionary {
    NSMutableDictionary *dic = [super dictionary];
    
    NSMutableDictionary *mediaDict = [super dictionary];
//    [Util add:mediaDict value:self.videoId key:@"id"];
//    [Util add:mediaDict value:self.mediaId key:@"videoId"];
//    [Util add:dic value:mediaDict key:@"media"];
    [Util add:dic value:self.videoId key:@"mediaId"];
    [Util add:dic value:self.mediaId key:@"mediaVideoId"];
    [Util add:dic value:self.title key:@"title"];
    [Util add:dic value:self.content key:@"content"];
    [Util add:dic value:self.annotationType key:@"annotationType"];
    [Util add:dic value:serialize(self.markedArea) key:@"markedArea"];
    [Util add:dic value:[NSString stringWithFormat: @"%ld", self.begin] key:@"startTime"];
    [Util add:dic value:[NSString stringWithFormat: @"%ld", self.end] key:@"endTime"];
    [Util add:dic value:self.parenId key:@"parentAnnotationId"];
    [Util add:dic value:self.rootId key:@"rootAnnotationId"];
    [Util add:dic value:self.userId key:@"userId"];
    [Util addList:dic list:self.imageAttachments key:@"imageAttachments"];
    [Util addList:dic list:self.videoAttachments key:@"videoAttachments"];
    
    return dic;
}

struct MarkedArea deserialize(NSString *markedArea) {
    NSArray *properties = [markedArea componentsSeparatedByString:@";"];
    
    struct MarkedArea area;
    area.time = -1;
    
    for (NSString *property in properties) {
        NSArray *value = [property componentsSeparatedByString:@"="];
        
        if ([[value objectAtIndex:0] isEqual:@"type"]) {
            area.type = [[value objectAtIndex:1] integerValue];
        } else if ([[value objectAtIndex:0] isEqual:@"x"]) {
            area.x = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"time"]) {
            area.time = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"y"]) {
            area.y = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"width"]) {
            area.width = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"height"]) {
            area.height = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"angle"]) {
            area.angle = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"red"]) {
            area.red = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"green"]) {
            area.green = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"blue"]) {
            area.blue = [[value objectAtIndex:1] floatValue];
        } else if ([[value objectAtIndex:0] isEqual:@"alpha"]) {
            area.alpha = [[value objectAtIndex:1] floatValue];
        }
    }
    return area;
}

NSString *serialize(struct MarkedArea markedArea) {
    return [NSString stringWithFormat:@"type=%i;time=%f;x=%f;y=%f;width=%f;height=%f;angle=%f;red=%f;green=%f;blue=%f;alpha=%f",
            markedArea.type,
            markedArea.time,
            markedArea.x,
            markedArea.y,
            markedArea.width,
            markedArea.height,
            markedArea.angle,
            markedArea.red,
            markedArea.green,
            markedArea.blue,
            markedArea.alpha];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"pk=%@ begin=%ld end=%ld content=%@ button=%@", self.pk, self.begin, self.end , self.content, self.button];
}

- (BOOL) isEqual:(id)object {
    return [object isKindOfClass:[Annotation class]] && ([[object pk] intValue] == [self.pk intValue]);
}

- (void) dealloc {
    [videoId release];
    [mediaId release];
    [title release];
    [content release];
    [annotationType release];
    [button release];
    [firstName release];
    [lastName release];
    [avatarLookUp release];
    [userId release];
    [parentAnnotation release];
    [parenId release];
    [rootId release];
    [imageAttachments release];
    [videoAttachments release];
    [attachmnets release];
    
    [super dealloc];
}

@end
