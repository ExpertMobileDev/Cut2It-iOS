//
//  FaceBookViewController.h
//  cut2it
//
//  Created by Anand Kumar on 21/01/13.
//
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FacebookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import "FacebookSDK.h"

#import "BaseViewController.h"

@class FaceBookViewController;

enum FBComposeResult {
    FBComposeResultCancelled,
    FBComposeResultSent,
    FBComposeResultFailed
};
typedef enum FBComposeResult FBComposeResult;

@protocol FBComposeViewControllerDelegate <NSObject>
- (void)fbComposeViewController:(FaceBookViewController *)controller didFinishWithResult:(FBComposeResult)result;
- (void) sendtoFacebook:(NSString*)fbComment;

@end


@interface FaceBookViewController : UIViewController<FBFriendPickerDelegate,UITextViewDelegate,UIWebViewDelegate>{
   BOOL isPosted;
   IBOutlet UIBarButtonItem *shareBtn;
}

@property(nonatomic,retain)NSDictionary *postDict;
@property(nonatomic,retain)NSString *postUrlString;
@property(nonatomic,retain)NSArray *QuestionOptionsArray;
@property(nonatomic,retain)NSDictionary *imageDictionary;
@property(nonatomic,retain)IBOutlet UITableView *contentTableView;
@property(nonatomic,retain)NSDictionary<FBGraphUser> *fbuserDict;

@property(nonatomic,retain)IBOutlet UITextView *statusTxtView;
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign) id<FBComposeViewControllerDelegate> fbComposeDelegate;

-(IBAction)shareBtnAction:(id)sender;
-(IBAction)cancelBtnAction:(id)sender;
- (IBAction)pickFriendsButtonClick:(id)sender;
@end
