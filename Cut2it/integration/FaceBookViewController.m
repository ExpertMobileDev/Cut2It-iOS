//
//  FaceBookViewController.m
//  Undrel
//
//  Created by Mukesh Sharma on 10/31/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import "FaceBookViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ContentViewCell.h"
#import "UIImage+Scale.h"
#import "ServerClass.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

NSString *const kPlaceholderPostMessage = @"Say something about this...";
@interface FaceBookViewController (){
    UIActivityIndicatorView *activity;
    UIView *loadingview;
    NSString *alertText;
    
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *postImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;
@property (retain, nonatomic) IBOutlet UIView *popView;
@property(nonatomic,retain)UIView *bgView;
@property (assign, readwrite, nonatomic) NSInteger cornerRadius;
@property(nonatomic,retain) IBOutlet UIView *footerView,*headerView;
- (IBAction)sybtItAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *profilePic;
@property (retain, nonatomic) IBOutlet UILabel *profileName;
@property (retain, nonatomic) IBOutlet UILabel *profilelocation;

@end

@implementation FaceBookViewController
@synthesize postDict;
#pragma mark - Helper methods

/*
 * This sets up the placeholder text.
 */
- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}




@synthesize postMessageTextView;
@synthesize postImageView;
@synthesize postNameLabel;
@synthesize postCaptionLabel;
@synthesize postDescriptionLabel;
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;


/*
 * Publish the story
 */
- (void)publishStory
{
    AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  /*  [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:nil
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             
             appdelgate.isfbError = YES;
             alertText = @"Network error! Please try later.";
             
             //[NSString stringWithFormat:@"error: domain = %@, code = %d",error.domain, error.code]
         } else {
             appdelgate.isfbError = NO;
             alertText = @"Your SYBR is now posted on Facebook";
             //[[NSNotificationCenter defaultCenter] postNotificationName:@"facebookPostingNotify" object:nil];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
         
         
         
     }];
   
   
   [FBRequestConnection startForPostStatusUpdate:@"test" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    */
    NSLog(@"postParams_postDict:%@",self.postParams);
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
    
    
        
        if (error) {
            
            appdelgate.isfbError = YES;
            alertText = @"Network error! Please try later.";
            
            [[[UIAlertView alloc] initWithTitle:@"Result" message:alertText delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            //[NSString stringWithFormat:@"error: domain = %@, code = %d",error.domain, error.code]
        } else {
            appdelgate.isfbError = NO;
            alertText = @"Your SYBR is now posted on Facebook";
            //self.singletonServerClass = [ServerClass singleton];
            //[self.singletonServerClass callAddQuestionOptionApi];
            [self.singletonServerClass performSelector:@selector(callAddQuestionOptionApi) withObject:nil afterDelay:3.0];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"facebookPostingNotify" object:nil];
        }
        // Show the result in an alert
      
    
    
    }];
    
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSuccesNotification:)  name:@"KsuccessNotification" object:nil];
     self.singletonServerClass = [ServerClass singleton];
    //[self.view addSubview:contentView];
//    contentView.layer.cornerRadius = 10.0f;
//    contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    contentView.layer.borderWidth = 2.0f;
     
    
    
//    CGRect frame = CGRectMake(self.contentTableView.frame.origin.x, self.contentTableView.frame.origin.y, self.contentTableView.frame.size.width, self.QuestionOptionsArray.count*85);
   // CGRect frame = CGRectMake(10, 50, 310, 300);
    
    //self.contentTableView .frame.size.height = 300;
//    self.contentTableView.backgroundView.backgroundColor = [UIColor clearColor];
//    self.contentTableView.backgroundView.frame =frame;
    
    // Do any additional setup after loading the view from its nib.
    
    
    
    /*
    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,320, 568)];
   // self.bgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.77];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = .75f;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.popView];
    [self.bgView bringSubviewToFront:self.popView];
    [UIView commitAnimations];

    */
    //self.view.backgroundColor = [UIColor clearColor];
   // self.view.alpha = 0.0f;
}

-(void)getSuccesNotification:(NSNotification *)notify{
    
    NSLog(@"getSuccesNotification");
    [self removeLoadingScreen];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (appdelegate.isfbError == NO) {
        [self.view removeFromSuperview];
    }
    sleep(3);
    UIAlertView *alertvw =[[UIAlertView alloc] initWithTitle:@"Result" message:@"Your SYBR is now posted on Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alertvw show];
    
}

- (int)currentWidth
{
    UIScreen *screen = [UIScreen mainScreen];
    return (!UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) ? screen.bounds.size.width : screen.bounds.size.height;
}

- (void)viewDidAppear:(BOOL)animated{
   // AppDelegate *appdelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    viewController.QuestionOptionsArray = self.QuestionOptions;
//    viewController.imageDictionary = self.imageDictionary;
//    viewController.fbuserDict = self.fbuserDict;
   // NSLog(@"QuestionOptionsArray:%@",_QuestionOptionsArray);
  //  NSLog(@"imageDictionary:%@",_imageDictionary);
//NSLog(@"fbuserDict:%@",_fbuserDict);
   // NSLog(@"postDict:%@",postDict);
  //  [self addsubView];
 /*
    NSString *link = [[NSString alloc] init];
    NSString *message = [[NSString alloc] init];
    NSString *picture = [[NSString alloc] init];
    NSString *name = [[NSString alloc] init];
    NSString *caption = [[NSString alloc] init];
    NSString *description = [[NSString alloc] init];
    
    link = self.postUrlString;
    message = @"Testing Social Framework";
    picture = [[_QuestionOptionsArray objectAtIndex:0] objectForKey:@"metaImage"];
    name = @"i have a few choices to make. Help me make a better choice,click here";
    caption = @"www.sybr.com";
    description = @"SYBR  is a new way of using social media to ask questions to a friend for an advice on buying. Post your choices and friends will help you make a better choice.";
    
    postDict = @{
    @"link": link,
    @"message" : message,
    @"picture" : picture,
    @"name" : name,
    @"caption" : caption,
    @"description" : description,
    };
    
    
    NSLog(@"POSTDICT333333:%@",postDict);
    */
  /*
    NSLog(@"appdelegate.questionId:%@",appdelegate.questionId);
    NSString *image=  [[_QuestionOptionsArray objectAtIndex:0] objectForKey:@"metaImage"];
    NSString *linkString = [NSString stringWithFormat:@"http://demo.webviaapp.com/undrel/sybrit/%@#yrtyryrtgg",appdelegate.questionId];
    NSLog(@"image:%@ linkString:%@",image,linkString);
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     linkString, @"link",
      image, @"picture",
     @"i have a few choices to make. Help me make a better choice,click here.", @"name",
     @"www.sybr.com", @"caption",
     @"SYBR  is a new way of using social media to ask questions to a friend for an advice on buying. Post your choices and friends will help you make a better choice.", @"description",
     nil];
    NSLog(@"postParams:%@",self.postParams);
    */
//    self.postParams =
//    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//     @"https://developers.facebook.com/ios", @"link",
//     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
//     @"Facebook SDK for iOS", @"name",
//     @"Build great social apps and get more installs.", @"caption",
//     @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
//     nil];
//
    
    [self resetPostMessage];
  /*
    NSLog(@"postDict=%@",postDict);
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams
                                  objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams
                                      objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   [self.postParams objectForKey:@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];
    */
    CGRect frame = CGRectMake(15, 18,290, 55+(self.QuestionOptionsArray.count*60)+44);
    self.contentTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.contentTableView.tableHeaderView = self.headerView;
    self.contentTableView.tableFooterView = self.footerView;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource =self;
    self.contentTableView.scrollEnabled = YES;
    
    self.contentTableView.layer.cornerRadius = 10.0f;
    self.contentTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.contentTableView.layer.borderWidth = 2.0f;
    
    [self.view addSubview:self.contentTableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(291, 15, 25, 25)];
    
    //set title, font size and font color
    // [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"webviewclose"] forState:UIControlStateNormal];
    
    
    //set action of the button
    [button addTarget:self action:@selector(removepopView:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.view addSubview:button];
    
    
  //  NSLog(@"fbuserDict:%@",self.fbuserDict);
    NSString *fbuid= self.fbuserDict.id;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https:/graph.facebook.com/%@/picture?type=large", fbuid]];
    NSLog(@"ProfilePic_url:%@",url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.profilePic.image = [UIImage imageWithData:data];
    self.profileName.text = self.fbuserDict.first_name;
    //self.profilelocation.text = self.fbuserDict.location;
    
    
    
    //[self.contentTableView reloadData];
}
-(void)removepopView:(id)sender{
    [self.view removeFromSuperview];
}


-(void)viewDidUnload{
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [self setPopView:nil];
    [self setProfilePic:nil];
    [self setProfileName:nil];
    [self setProfilelocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
//    [UIView animateWithDuration:0.4
//                          delay:0.1
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _backgroundView.alpha = 1;
//                     } completion:nil];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}


#pragma mark - Action methods
- (IBAction)cancelButtonAction:(id)sender {
    [[self presentingViewController]
     dismissModalViewControllerAnimated:YES];
    //[self.view removeFromSuperview];
    //[self.view release];
}


- (IBAction)shareButtonAction:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self addLoadingScreen];
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
//    if (![self.postMessageTextView.text
//          isEqualToString:kPlaceholderPostMessage] &&
//        ![self.postMessageTextView.text isEqualToString:@""]) {
//        //[self.postParams setObject:self.postMessageTextView.text
//                            forKey:@"message"];
//    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
     /*   [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];*/
        [self publishStory];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}


#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

#pragma mark - UIAlertViewDelegate methods
- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self removeLoadingScreen];
    if (appdelegate.isfbError == NO) {
        [self removepopView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookPostingNotify" object:nil];
    }
    
//    [[self presentingViewController]
//     dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_popView release];
    [_profilePic release];
    [_profileName release];
    [_profilelocation release];
    [super dealloc];
}

-(void)addLoadingScreen{
    NSLog(@"addLoadingScreen");
    CGRect frame = CGRectMake(0, 0, 320, 480);
    loadingview = [[UIView alloc] initWithFrame:frame];
    
    loadingview.backgroundColor = [UIColor clearColor];
    loadingview.userInteractionEnabled = NO;
    loadingview.alpha = 1.0f;
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(155, 230, 30, 30)];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingview addSubview:activity];
    UILabel *pleaseWait = [[UILabel alloc] init];
    pleaseWait.frame = CGRectMake(110, 245, 90, 50);
    pleaseWait.text = @"Please Wait..";
    pleaseWait.font = [UIFont boldSystemFontOfSize:14];
    pleaseWait.textColor = [UIColor lightGrayColor];
    pleaseWait.backgroundColor = [UIColor clearColor];
    [loadingview addSubview: pleaseWait];
    pleaseWait.opaque = NO;
    pleaseWait.alpha = 1.0;
    //[pleaseWait release];
    [activity startAnimating];
    [activity release];
    [self.view addSubview:loadingview];
    
}


-(void)removeLoadingScreen{
    [activity startAnimating];
    [loadingview removeFromSuperview];
    [loadingview release];
}


#pragma mark UITableView Methods.......
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [self.QuestionOptionsArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    return 60;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//     static NSString *MyIdentifier = @"MyIdentifier";
//     
//     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//     
//     if(cell ==nil){
//     
//         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
//              
//              
//              }
    NSString *MyIdentifier = [NSString stringWithFormat:@"%i-%i",indexPath.section,indexPath.row];
    
	ContentViewCell *cell = (ContentViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if(cell ==nil){
		NSLog(@"NILLLLLL");
		
		cell=[[[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier indexes:indexPath] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.frame=CGRectMake(0.0, 0.0, 320.0,120.0);
        
    }
    NSDictionary *datadict = [self.QuestionOptionsArray objectAtIndex:indexPath.row];
    NSLog(@"datadict:%@",datadict);
    NSLog(@"imageDictionary:%@",self.imageDictionary);
    cell.detaillbl.text = [datadict objectForKey:@"metaTitle"];
    UIImage *cellImge = [self.imageDictionary objectForKey:[datadict objectForKey:@"metaImage"]];
    cell.imageVw.image = [UIImage imageWithImage:cellImge scaledToSize:CGSizeMake(41, 70)];
    cell.imageVw.contentMode = UIViewContentModeScaleAspectFit;
    NSString *detailDescription = [datadict objectForKey:@"metaDescription"];
    if (detailDescription!=nil) {
        cell.detailDescriptionLabel.text =detailDescription;
    }
    
    
    return cell;

}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(self.footerView == nil) {
        //allocate the view if it doesn't exist yet
        self.footerView  = [[UIView alloc] init];
        //WithFrame:CGRectMake(0, 0, 290, 120)
        self.footerView.backgroundColor = [UIColor redColor];
        
        self.footerView.alpha = 1.0;
        self.footerView.opaque = NO;
        
        
        //create the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(92, 3, 136, 43)];
        
        //set title, font size and font color
       // [button setTitle:@"Click Me" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"sybrit"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        //set action of the button
        [button addTarget:self action:@selector(clickPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [self.footerView addSubview:button];
    }
    
    //return the view for the footer
    return self.footerView;
}
*/
- (IBAction)sybtItAction:(id)sender {
    
    AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[self.singletonServerClass addQuestionApiCalling];
    //[appdelgate.requestDictionary setValue:self.QuestionOptions forKey:@"QuestionOptions"];
    [self addLoadingScreen];
    //[self.singletonServerClass addQuestionApiCallingWithRequest:appdelgate.requestDictionary];
      // NSDictionary *AddQuestioDictinary=     [self.singletonServerClass performSelector:@selector(addQuestionApiCallingWithRequest:) withObject:appdelgate.requestDictionary afterDelay:0.5];
    
    NSDictionary *AddQuestionDictinary= [self.singletonServerClass addQuestionApiCallingWithRequest:appdelgate.requestDictionary];
    NSLog(@"AddQuestioDictinary:%@",AddQuestionDictinary);
    //[self sharetoSybrit];
    [self getPostParameter];
    [self performSelector:@selector(sharetoSybrit) withObject:nil afterDelay:2.0];
}

-(void)getPostParameter{
    AppDelegate *appdelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelegate.questionId:%@",appdelegate.questionId);
    NSString *image=  [[_QuestionOptionsArray objectAtIndex:0] objectForKey:@"metaImage"];
    NSString *linkString = [NSString stringWithFormat:@"http://demo.webviaapp.com/undrel/sybrit/%@#yrtyryrtgg",appdelegate.questionId];
    NSLog(@"image:%@ linkString:%@",image,linkString);
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     linkString, @"link",
     image, @"picture",
     @"i have a few choices to make. Help me make a better choice,click here.", @"name",
     @"www.sybr.com", @"caption",
     @"SYBR  is a new way of using social media to ask questions to a friend for an advice on buying. Post your choices and friends will help you make a better choice.", @"description",
     nil];
    NSLog(@"postParams:%@",self.postParams);
}

-(void)sharetoSybrit{
   
    NSLog(@"FBSession.activeSession.isOpen:%d",FBSession.activeSession.isOpen);
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    //    if (![self.postMessageTextView.text
    //          isEqualToString:kPlaceholderPostMessage] &&
    //        ![self.postMessageTextView.text isEqualToString:@""]) {
    //        //[self.postParams setObject:self.postMessageTextView.text
    //                            forKey:@"message"];
    //    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        NSLog(@"No permissions found in session, ask for it");
        
       //  No permissions found in session, ask for it
              /* [FBSession.activeSession
                 reauthorizeWithPublishPermissions:
                 [NSArray arrayWithObject:@"publish_actions"]
                 defaultAudience:FBSessionDefaultAudienceFriends
                 completionHandler:^(FBSession *session, NSError *error) {
                     if (!error) {
                         // If permissions granted, publish the story
                        // [self publishStory];
                         [self performSelector:@selector(publishStory) withObject:nil afterDelay:2.0];
                     }
                 }];*/
       // [self publishStory];
        [self performSelector:@selector(publishStory) withObject:nil afterDelay:2.0];
    } else {
        // If permissions present, publish the story
//        [self publishStory];
        [self performSelector:@selector(publishStory) withObject:nil afterDelay:2.0];
    }

}
@end
