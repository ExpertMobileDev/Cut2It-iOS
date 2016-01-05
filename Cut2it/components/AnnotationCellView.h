//
//  AnnotationCellViewCell.h
//  cut2it
//
//  Created by Mac on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

#import "Cut2itApi.h"
#import "Container.h"
#import "Media.h"
#import "Annotation.h"
#import "ShareViewController.h"
#import "CustomScrollView.h"
#import "UIImageThumbnailView.h"
#import "Attachment.h"
#import "AttachmentViewController.h"




@interface AnnotationCellView : UITableViewCell <ASIHTTPRequestDelegate,UIScrollViewDelegate,CustomScrollViewDelegate>


@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UIImageView *imageShadow;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UILabel *content;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;
@property (retain, nonatomic) IBOutlet UIButton *btnReply;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (retain, nonatomic) Annotation *_parentAnnotation;
@property (retain, nonatomic) Annotation *_rootAnnotation;
@property (retain, nonatomic) Annotation *_annotation;
@property (retain, nonatomic) IBOutlet UIButton *btnShare;
@property (retain, nonatomic) IBOutlet UIButton *btnAttachments;
@property (retain, nonatomic) IBOutlet  CustomScrollView* _scrollView;
@property (nonatomic) float scrollViewWidth;
@property (nonatomic) float scrollViewHeight;
@property (retain, nonatomic) IBOutlet UIImageView *imageBreaker;
@property (retain, nonatomic) IBOutlet UIImageView *imageSeparator;
@property (retain, nonatomic)  MPMoviePlayerViewController *theMovie;

-(void)fill:(Annotation *) rootAnnotation :(Annotation *) parentAnnotation :(Annotation *) annotation:(NSNumber*)userPk;
-(void)cellRezise:(float)contentHeight :(float)viewHeight :(float)btnHeight;
-(IBAction)remove:(id)sender;
-(IBAction)reply:(id)sender;
-(void)scrollTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)scrollTouchesEnd:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)loadImages;
-(void)playVideo:(id)sender;

@end
