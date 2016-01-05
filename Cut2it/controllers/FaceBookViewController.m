//
//  FaceBookViewController.m
//  cut2it
//
//  Created by Anand Kumar on 21/01/13.
//
//

#import "FaceBookViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface FaceBookViewController ()

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSMutableDictionary *postParams;

@end

@implementation FaceBookViewController
@synthesize postParams = _postParams;
@synthesize statusTxtView;
@synthesize webView;
@synthesize fbComposeDelegate = _fbComposeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"FaceBook123";    

    webView.delegate = self;
    //[self embedYouTube:@"http://www.youtube.com/v/zdckvKMpBdU" frame:webView.frame];
    
    statusTxtView.layer.borderWidth = 1.5f;
    statusTxtView.layer.borderColor = [[UIColor blackColor] CGColor];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
   AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   [super viewWillAppear:animated];
    [statusTxtView becomeFirstResponder];
   isPosted = NO;
   [shareBtn setEnabled:YES];
    appDelegate.faceBookComment = nil;
    if(appDelegate.videoTitle && ![appDelegate.videoTitle isEqualToString:@" "]){
   statusTxtView.text = [NSString stringWithFormat:@"%@",appDelegate.videoTitle];
        appDelegate.faceBookComment= [NSString stringWithFormat:@"%@",statusTxtView.text];
    }
  
}



-(void)getSuccesNotification:(NSNotification *)notify{
    
    NSLog(@"getSuccesNotification");
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (appdelegate.isfbError == NO) {
        [self.view removeFromSuperview];
    }
    sleep(3);
    UIAlertView *alertvw =[[UIAlertView alloc] initWithTitle:@"Result" message:@"Your message is now posted on Facebook." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alertvw show];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ButtonAction
-(IBAction)shareBtnAction:(id)sender{
   NSLog(@"shareBtnAction");
//    if(IPHONE_5)
//    {
//        // Ask for publish_actions permissions in context
//        if ([FBSession.activeSession.permissions
//             indexOfObject:@"publish_actions"] == NSNotFound) {
//            // No permissions found in session, ask for it
//            [FBSession.activeSession
//             reauthorizeWithPublishPermissions:
//             [NSArray arrayWithObject:@"publish_actions"]
//             defaultAudience:FBSessionDefaultAudienceFriends
//             completionHandler:^(FBSession *session, NSError *error) {
//                 
//                 if (!error) {
//                     // If permissions granted, publish the story
//                     [self publishStory];
//                 } else {
//                 }
//             }];            
//            
//        } else {            
//            // If permissions present, publish the story
//            [self publishStory];
//        }
//    }
    
    [self.fbComposeDelegate sendtoFacebook:statusTxtView.text];
    //[self.fbComposeDelegate sendtoFacebook];
    [self.fbComposeDelegate fbComposeViewController:self didFinishWithResult:TweetComposeResultSent];
    //[self.statusTxtView resignFirstResponder];
          
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.statusTxtView isFirstResponder] &&
        (self.statusTxtView != touch.view))
    {
        //[self.statusTxtView resignFirstResponder];
    }
}

-(IBAction)cancelBtnAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.faceBookComment = nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //appDelegate.faceBookComment = nil;
    appDelegate.faceBookComment= [NSString stringWithFormat:@"%@",statusTxtView.text];
    //[statusTxtView resignFirstResponder];
    //[self shareBtnAction:nil];
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
        
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
        
    return YES;
}

/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [statusTxtView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
 */

#pragma Publish

-(void)sharetoFB{
    
    NSLog(@"FBSession.activeSession.isOpen:%d",FBSession.activeSession.isOpen);
    
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];       
        
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }   
    
}

// not in use
-(void)getPostParameter{   
   // NSString *image=  [[_QuestionOptionsArray objectAtIndex:0] objectForKey:@"metaImage"];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];    
   // NSString *linkString = [NSString stringWithFormat:@" http://54.208.178.138/cut2it/video?annotationId=%@",appDelegate.pk];
    NSString *linkString = [NSString stringWithFormat:@" http://54.208.178.138/cut2it/video?annotationId=%@",appDelegate.pk]; // cloud server     
    
//    NSString *image = [NSString stringWithFormat:@"{\"name\":\"http://bit.ly/bJZakA\",\"href\":\"http://bit.ly/bJZakA\",\"media\":[{\"type\":\"flash\",\"swfsrc\":\"http://www.youtube.com/v/Wti6m3Y28_M&amp;hl=en_US&amp;fs=1\",\"imgsrc\":\"http://www.hooraysociety.com/DNA/DNA.jpg\",\"width\":\"100\",\"height\":\"80\",\"expanded_width\":\"300\",\"expanded_height\":\"200\"}]}"];
//     
    
    CGRect frame=   CGRectMake(20, 20, 50, 50);
   NSString *url = @" http://www.youtube.com/watch?v=zdckvKMpBdU";
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    //    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"320\" height=\"480\"><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"480\"></embed></object></div></body></html>",videoUrl,videoUrl]    ;

    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     linkString, @"link",
     @"http://54.208.178.138", @"caption",
     statusTxtView.text, @"message",
      appDelegate.videoUrl, @"picture",
     nil];
}

-(void)publishStory{
    NSLog(@"publishStory");    
    NSLog(@"post params %@",self.postParams);       
}

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    
    webView.frame=frame;
    [webView loadHTMLString:html baseURL:nil];
} 
 
-(void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}

@end
