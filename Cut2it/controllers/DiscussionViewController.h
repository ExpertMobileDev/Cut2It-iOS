//
//  AnnotationsView.h
//  cut2it
//
//  Created by Mac on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Annotation.h"
#import "AnnotationCellView.h"
#import "RootAnnotationCellView.h"
#import "ConfigureServiceViewController.h"
#import "FaceBookViewController.h"
#import "TweetComposeViewController.h"

@interface DiscussionViewController : BaseViewController<ASIHTTPRequestDelegate,UITableViewDelegate, UITableViewDataSource,FBComposeViewControllerDelegate,TweetComposeViewControllerDelegate>{
   
    
}


@property (nonatomic,retain)NSMutableArray *temparray;
@property (nonatomic,retain)NSMutableArray *temparrayNew;
@property (retain, nonatomic) IBOutlet UIImageView *yImage;
@property (retain, nonatomic) IBOutlet UIImageView *yBackImage;
@property (retain, nonatomic) IBOutlet UILabel *yTitle;
@property (retain, nonatomic) IBOutlet UILabel *yDescription;
@property (retain, nonatomic) IBOutlet UILabel *yStart;
@property (retain, nonatomic) IBOutlet UILabel *yEnd;

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UILabel *duration;

@property (retain, nonatomic) Annotation *selectedRootAnnotation;
@property (retain, nonatomic) Annotation *  entity;


@property (retain, nonatomic) IBOutlet UITableView *_table;
@property (retain, nonatomic) NSArray *annotations;
//@property (retain, nonatomic) NSMutableArray *annotations;
@property (retain, nonatomic) NSArray *rootAnnotations;
//@property (retain, nonatomic) NSMutableArray *rootAnnotations;
@property (nonatomic) float childContentHeight;
@property (nonatomic) float childViewHeight;
@property (nonatomic) float childBtnHeight;
@property (nonatomic) float rootContentHeight;
@property (nonatomic) float rootViewHeight;
@property (nonatomic) float rootBtnHeight;

@property (nonatomic) int countCell;
@property (nonatomic) int koef;
@property (nonatomic) int selectedCellRow;

@property (retain, nonatomic) NSArray *insertIndexPaths;
@property (retain, nonatomic) IBOutlet RootAnnotationCellView *rootCell;
@property (retain, nonatomic) YouTubeView *youTubeCell;

@property (retain, nonatomic) IBOutlet UIView *menu;
@property (retain, nonatomic) Annotation *  sharedAnnotation;
@property (retain, nonatomic) Annotation * sharedRootAnnotation;
@property (retain, nonatomic) Annotation * sharedParentAnnotation;

@property (nonatomic) BOOL isNextStepUpdatingChildAnnotations;
@property (nonatomic) BOOL isUpdatingChildAnnotations;
@property (nonatomic) BOOL isUpdatingRootAnnotations;

@property (nonatomic) BOOL isPost;

// Bhavya - 18th July 2013
@property (nonatomic) BOOL isTappedSameRow;
@property (nonatomic) int rowClicked;

- (void) annotationsStateChanged:(NSNotification*) notification;
-(void)  shareRootAnnotation:(id)sender;
-(void)  shareComment:(id)sender;
-(void) success:(BOOL) success;



@end
