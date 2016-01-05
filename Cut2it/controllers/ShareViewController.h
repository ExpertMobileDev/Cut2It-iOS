//
//  ShareViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareOptionViewController.h"
#import "Annotation.h"
#import "YouTubeView.h"
#import "Container.h"
#import "ConfigureServiceViewController.h"
#import "UIImageThumbnailView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "Attachment.h"
#import "CustomScrollView.h"
#import "Effect.h"
#import "ASIHTTPRequestDelegate.h"

//BB0202: To support iOS8 and new facebook SDK.
#import <FacebookSDK/FacebookSDK.h>
//#import "FacebookSDK.h"

#import "TweetComposeViewController.h"
#import "FaceBookViewController.h"


@protocol AnnotationDelegate <NSObject>

- (void) addAnnotation:(Annotation *) annotation;


@end

/*
@protocol TweetComposeViewControllerDelegate <NSObject>
- (void)tweetComposeViewController:(TweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result;
- (void) sendtoTweeter;

@end
 */
/*
@class ShareViewController;

@protocol ShareViewControllerDelegate <NSObject>
- (void)shareViewController:(ShareViewController *)controller addAnnotation:(Annotation *) annotation;
@end
*/
 

@interface ShareViewController : BaseViewController <ASIHTTPRequestDelegate, UITextViewDelegate, ShareOptionViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TweetComposeViewControllerDelegate,FBComposeViewControllerDelegate> {
    BOOL video;
    BOOL edit;
    Effect *effect;
    NSNumber *selTabIndex;
}

@property (retain, nonatomic) IBOutlet UITextView *comment;
@property (retain, nonatomic) Annotation *entity;
@property (assign, nonatomic) id<AnnotationDelegate> annotationDelegate;
//@property (nonatomic, assign) id<ShareViewControllerDelegate> addAnnotationDelegate;
@property (retain, nonatomic) NSMutableArray *photoArray;

@property (retain, nonatomic) IBOutlet UIButton *btnAddPhoto;
@property (retain, nonatomic) IBOutlet UIButton *btnAddVideo;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;

@property (retain, nonatomic) IBOutlet  UIScrollView* _scrollView;
//@property (retain, nonatomic) id <ShareOptionViewControllerDelegate> customDelegate1;

@property (assign, nonatomic) NSNumber *selTabIndex;


- (id) initShareVideo;

- (IBAction)save:(id)sender;
- (IBAction)addVideo:(id)sender;
- (IBAction)addPhoto:(id)sender;

@end
