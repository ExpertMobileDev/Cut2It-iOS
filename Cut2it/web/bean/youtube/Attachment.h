//
//  Attachment.h
//  cut2it
//
//  Created by Mac on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Serializable.h"







@interface Attachment : Serializable


@property (retain, nonatomic) NSString *originalPath;
@property (retain, nonatomic) NSString *attachmentType;
@property (retain, nonatomic) NSString *temporaryFilename;
@property (retain, nonatomic) NSString *opfResourceName;
@property (retain, nonatomic) NSString * uploadDate;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) UIProgressView *progress;
@property (retain, nonatomic) NSString *imageUrl;

@property (retain, nonatomic) NSString *thumbnailUrl;
@property (retain, nonatomic) NSString *youtubeUrl;
@property (retain, nonatomic) NSString *videoId;

@property (retain, nonatomic) NSString *storageType;



- (id) initWithDictionary:(NSDictionary *) dictionary;

-(NSMutableDictionary *) dictionary;
@end
