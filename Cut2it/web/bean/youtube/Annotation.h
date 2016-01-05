//
//  AnnotationEntity.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "PlayerDelegate.h"
//#import "JSON.h"
#import "Attachment.h"

@interface Annotation : Entity

@property (retain, nonatomic) NSString *firstName;
@property (retain, nonatomic) NSString *lastName;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *avatarLookUp;
@property (retain, nonatomic) NSString *userId;
@property (retain, nonatomic) NSNumber *parenId;
@property (retain, nonatomic) NSNumber *rootId;

@property (retain, nonatomic) NSNumber *videoId;
@property (retain, nonatomic) NSString *mediaId;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *annotationType;
@property (retain, nonatomic) IBOutlet NSMutableArray *attachmnets;
@property (nonatomic) MarkedArea markedArea;
@property (nonatomic) long begin;
@property (nonatomic) long end;
@property (nonatomic) long childrenCount;

@property (retain, nonatomic) UIButton *button;
@property (nonatomic) BOOL mark;
@property (nonatomic) BOOL sub;

@property (nonatomic) float viewHeight;
@property (nonatomic) float contentHeight;
@property (retain, nonatomic) Annotation *parentAnnotation;
@property (retain, nonatomic) NSMutableArray *imageAttachments;
@property (retain, nonatomic) NSMutableArray *videoAttachments;
//@property (retain, nonatomic) Attachment * attachment;

@property (nonatomic) BOOL isShowAttachments;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSMutableDictionary *) dictionary;

@end
