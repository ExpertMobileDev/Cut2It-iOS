//
//  PlayerViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareViewController.h"
#import "WatchView.h"
#import "EditView.h"
#import "DiscussionViewController.h"
#import "Annotation.h"
#import "MessageView.h"
#import "ShareViewController.h"


@interface PlayerViewController : BaseViewController <PlayerDelegate, MessageDelegate, ASIHTTPRequestDelegate,AnnotationDelegate> {
    UIImageView *thumbnail;
    UIActivityIndicatorView *indicator;
    UIView *letterbox;
    UIView *pillarbox;
    float current;
    NSNumber *selTabIndex;
}

@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic) WatchView *watchView;
@property (retain, nonatomic) EditView *editView;
@property (retain, nonatomic) NSMutableArray *annotations;
@property (nonatomic) BOOL isMore;
@property (retain, nonatomic) Annotation * selectedAnnotation;
@property (nonatomic,retain)NSMutableArray *temparray;
@property (nonatomic, assign) NSNumber *selTabIndex;

- (id) initWithMedia:(Media *) media;
- (id) initWithContentURL:(NSURL *) url media:(Media *) media;
- (void) addCoustomAnnotation:(Annotation *) annotation;
@end
