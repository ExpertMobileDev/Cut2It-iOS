//
//  ShareViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"

//BB0202: use newer FaceBOOKSDK
#import <FacebookSDK/FacebookSDK.h>
//#import "FacebookSDK.h"

#import "AppDelegate.h"
#import "FaceBookViewController.h"
#import "TweetComposeViewController.h"
#import "TabViewController.h"

#define IMAGE_WIDTH 60
#define IMAGE_HEIGHT 50
#define PADDING 2

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize comment;
@synthesize entity;
@synthesize annotationDelegate;
//@synthesize addAnnotationDelegate = _addAnnotationDelegate;
@synthesize photoArray;

@synthesize btnAddPhoto;
@synthesize btnAddVideo;
@synthesize btnSave;
//@synthesize customDelegate1;

@synthesize _scrollView;
@synthesize selTabIndex;

- (id) initShareVideo {
    video = YES;
    return [super init];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Comment";      
    /*
     
     //Commented by Anand HSPL on 17/1/13/
     
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"rounded" width:68 target:self action:@selector(back:)];
     */
    
    //// Added by Anand HSPL on 17/1/13////
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
    //////////////////////////
    
    
    UIBarButtonItem *save = [self createBarButtonWithName:@"Next" image:@"rounded" width:68 target:self action:@selector(share:)];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = save;
    
    [back release];
    [save release];
    
    Media *media = self.container.selected;
    
    NSString *start = [Util timeFormat:entity.begin];
    NSString *end = [Util timeFormat:entity.end];
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (media.title) {
        appDelegate.videoTitle = media.title;
    }
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YouTubeCellView" owner:self options:nil];
    YouTubeView *cell = (YouTubeView *)[nib objectAtIndex:0];
    CGRect rect = cell.frame;
    rect.origin.y = 64;
    cell.frame = rect;
    
    [self.view addSubview:cell];
    [cell fill:media dutation:[NSString stringWithFormat:@"Start %@ - End %@", start, end]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(create:)
                                                 name:@"CreateAnnotation"
                                               object:nil];
    
    
    entity.imageAttachments = [NSMutableArray array];
    entity.videoAttachments = [NSMutableArray array];
    
    self.photoArray = [NSMutableArray array];
    
    effect = [[Effect alloc] init];
    

        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_annotation_comment"]];
        background.frame = comment.frame;
        [self.view insertSubview:background belowSubview:comment];
        [background release];
        
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_attach"]];

}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    [self stopAllShake];
    [UIView beginAnimations:@"resizeComent" context:NULL];
    CGRect frame = self.comment.frame;
    self.comment.frame =  CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100);
    [UIView commitAnimations];
    
    /*
    UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
    [save setTitle:@"Done" forState:UIControlStateNormal];
    save.hidden = NO;
     */
     
    
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
    [UIView beginAnimations:@"resizeComent1" context:NULL];
    CGRect frame = self.comment.frame;
    self.comment.frame =  CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,205);
    [UIView commitAnimations];
    /*
    UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
    [save setTitle:@"Share" forState:UIControlStateNormal];
    save.hidden = NO;//video;
    */
    
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    
}


- (void) viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CreateAnnotation"
                                                  object:nil];
   // self.annotationDelegate = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    btnSave.hidden = YES;
//    [self blankRotate];
    [self setOrientation:UIInterfaceOrientationPortrait];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) save:(UIButton *) sender {
    
    NSLog(@"save");
    
   
    NSString *message = entity.pk ? @"Annotation updated" : @"Annotation saved";
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAnnotation"
                                                        object: nil];    
    if(entity.pk)
    {
        if([comment.text length]!=0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }   
    
}

- (IBAction) back:(id)sender {
    [comment resignFirstResponder];
    
     //// Added By Anand(HSPL) on 16/1/13///
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshAnnotation"
                                                        object: nil];
    
    if([comment.text isEqualToString:@""])
    {
        [super back:sender];
        if (entity.parenId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAnnotations"
                                                                object: nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayVideoNotification" object:entity.parentAnnotation];
        }

        return;
    }
     
    
    if(!entity.pk) {
        NSString  * message = @"You haven't saved the annotation. Delete it and return to player ?";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                       delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel",nil];
        alert.tag=2;
        [alert show];
        [alert release];
    } else {
        [super back:sender];
        if (entity.parenId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAnnotations"
                                                                object: nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayVideoNotification" object:entity.parentAnnotation];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==2 ) {
        if(buttonIndex==0)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"CreateAnnotation"
                                                          object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(buttonIndex==1)
        {
            return;
        }
       
    }
}

- (void) share:(id)sender
{
    NSString *title = [sender titleForState:UIControlStateNormal];
    [self save:nil];
    if([comment.text length]!=0){
        
        [self performSelector:@selector(pushController) withObject:nil afterDelay:1.2];
    }
    else{
         [self performSelector:@selector(pushController) withObject:nil afterDelay:0.0];
    }
    /*
    if ([title isEqualToString:@"Done"]) {
        [comment resignFirstResponder];
    } else {
        [self save:nil];
        [self performSelector:@selector(pushController) withObject:nil afterDelay:1.2];
       
    }
     */
}

-(void)pushController{
    ShareOptionViewController *controller = [[ShareOptionViewController alloc] init];
    controller.customDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) create:(NSNotification *) notification {
    NSLog(@"create");
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    Annotation *result = notification.object;
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //[comment.text length]!= 0
    
    
    Annotation *annotation;
    NSLog(@"entity.pk");
    
    if (!entity.pk)
    {
        NSLog(@"tab index is %@", self.selTabIndex); // Bhavya - to check if it is video from Youtube search.
        if(self.selTabIndex.intValue == 2)
        {
            Media *media = self.container.selected;
            Media *created = [self.api createMediaNewWithAnnotation :media :entity status:nil];
            self.container.selected = created;
            annotation = [created.arrAnnotations objectAtIndex:0];
        }
        else
        {
            annotation = [self.api createAnnotation:entity];
        }
        
    } else
    {
        //if([[comment text] length] != 0){
        NSLog(@"tab index is %@", self.selTabIndex);
        annotation = [self.api updateAnnotation:entity];
        //}
    }
    
    if (annotation) {
        if(entity){
        entity.pk = annotation.pk;
        }
        appDelegate.pk = annotation.pk;
        
        if([comment.text length]!= 0 && entity.content!=nil){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addannotationNotification"                                                         object: annotation];
           /*
           if ([annotationDelegate respondsToSelector:@selector(addAnnotation:)]) {
            [self.annotationDelegate addAnnotation:annotation];
           }
             */
            
             
        //[self.addAnnotationDelegate shareViewController:self addAnnotation:annotation];
        
        }
            [annotation release];
    }
    if (result) {
        result.pk = entity.pk;
        result.videoId = entity.videoId;
        result.content = entity.content;
        result.begin = entity.begin;
        result.end = entity.end;
    }
}

//- (void) success:(BOOL) success{
//    NSLog(@"success_Create_Update_Share");
//    [self performSelector:@selector(pushController) withObject:nil afterDelay:1.2];
//}


#pragma mark - Thumbnails
-(void)loadImages {
    int count = [self.photoArray count];
    
    for (UIView *subview in [self._scrollView subviews]) {
        if (edit) {
            [self stopShake:subview];
        }
        [subview removeFromSuperview];
    }
    
    [self._scrollView setContentSize:CGSizeMake((IMAGE_WIDTH + PADDING)* count+ 20, 54)];
    
    for (int i=0; i<count; i++) {
        CGRect imageFrame = CGRectMake(i * (IMAGE_WIDTH + PADDING), PADDING, IMAGE_WIDTH, IMAGE_HEIGHT);
        
        UIView *cell = [[UIView alloc] initWithFrame:imageFrame];
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = i;
        if (edit) [self shakeView:cell];
           
        Attachment *attachment = [self.photoArray objectAtIndex:i];
        UIImageView *image = [[UIImageView alloc] initWithImage:attachment.image];
        image.frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
        image.layer.masksToBounds = YES;
        image.layer.borderColor = [UIColor whiteColor].CGColor;
        image.layer.borderWidth = 2.5;
        [cell addSubview:image];
        [image release];
        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecieved:)];
        [cell addGestureRecognizer:tap];
        [tap release];
        
        if (attachment.progress) {
            [cell addSubview:attachment.progress];
        }
        
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(15.5, 10.5, 29, 29)];
        btnDelete.tag = 101;
        btnDelete.hidden = !edit;
        [btnDelete addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setBackgroundImage:[UIImage imageNamed:@"button_delete"] forState:UIControlStateNormal];
        [cell addSubview:btnDelete];
        [btnDelete release];
        
        [self._scrollView addSubview:cell];
        [cell release];
    }
}

- (void) tapRecieved:(UILongPressGestureRecognizer *) tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        for (UIView *cell in _scrollView.subviews) {
            if (edit)
                [self stopShake:cell];
            else
                [self shakeView:cell];
            UIButton *del = (UIButton *) [cell viewWithTag:101];
            del.hidden = edit;
        }
        edit = !edit;
    }
}

-(void) shakeView:(UIView *) view {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.04, 0, 0, 1)];
    NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-0.04, 0, 0, 1)];
    animation.values = [NSArray arrayWithObjects:valLeft, valRight, nil];
    
    animation.autoreverses = YES;
    animation.duration = 0.15;
    animation.repeatCount = HUGE_VALF;
    
    [view.layer addAnimation:animation forKey:@"SpringboardShake"];
}

-(void) stopShake:(UIView *) view {
    [view.layer removeAnimationForKey:@"SpringboardShake"];
}

- (void) stopAllShake {
    if (edit) {
        for (UIView *cell in _scrollView.subviews) {
            [self stopShake:cell];
            UIButton *del = (UIButton *) [cell viewWithTag:101];
            del.hidden = edit;
        }
        edit = NO;
    }
}
#pragma  mark - Upload  Photo  and  Video

-(void)  deleteCell:(UIButton *)sender {
    UIView *cell = sender.superview;
    int i = cell.tag;
    
    Attachment *attachment = [self.photoArray objectAtIndex:i];

    [entity.imageAttachments removeObject:attachment];
    [entity.videoAttachments removeObject:attachment];
    
    [self.photoArray removeObjectAtIndex:i];
    [self loadImages];
}

- (IBAction)addPhoto:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    popupQuery.tag = 1;
    [popupQuery release];
    
}

- (IBAction)addVideo:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Video Camera", @"Video Library", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    popupQuery.tag =2;
    [popupQuery release];
    
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    [self stopAllShake];
    if(actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self takePhoto];
        } else if (buttonIndex == 1) {
            [self openPhoto];
        }
    } else if(actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            [self videoCamera];
        } else if (buttonIndex == 1) {
            [self videoLibrary];
        }
    }
}

#pragma mark - Photo
- (void) takePhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing=YES;
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}

- (void) openPhoto {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}


#pragma mark - Video
-(void) videoCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
	}
}

-(void) videoLibrary {
    
    // TEST
    
    
    /*  btnAddPhoto.userInteractionEnabled = FALSE;
     btnAddVideo.userInteractionEnabled= FALSE;
     btnSave.userInteractionEnabled= FALSE;
     
     btnAddPhoto.alpha = 0.5;
     btnAddVideo.alpha= 0.5;
     btnSave.alpha= 0.5;
     
     NSURL *url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/sample3.mov"]]];
     
     [effect generateImage:url handle:^(UIImage *image) {
     self.uploadingImage =image;
     
     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
     [dic  setObject:(UIImage *)image forKey:@"image"];
     [dic setValue:@"VIDEO" forKey:@"type"];
     [dic setValue:@"tmp" forKey:@"filename"];
     [self.photoArray addObject:dic];
     
     
     dic = nil;
     [self loadImages];
     }];
     
     // MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
     //  moviePlayer.shouldAutoplay = NO;
     //  UIImage *thumbnail = [[moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame] retain];
     // self.uploadingImage =thumbnail;
     
     NSData *data = [[NSData alloc]initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
     [self.api uploadCommentVideo:@"sample3.mov" data:data delegate:self];
     [data release];
     */
    
    
    

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    Attachment *attachment = [[Attachment alloc]init];
    attachment.originalPath = [Util generateName:6];
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(2, 38, 56, 10)];
    attachment.progress = progress;
    [progress release];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadVideoNotification"
                                                            object: nil];
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [effect generateImage:url handle:^(UIImage *image) {
            attachment.image = image;
            [self.photoArray addObject:attachment];
            [attachment release];
            [self loadImages];
        }];
        
        attachment.attachmentType = @"VIDEO";
        NSData *data = [[NSData alloc]initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        [self.api uploadCommentVideo:attachment.originalPath data:data progress:attachment.progress delegate:self];
        [data release];
    } else if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        attachment.attachmentType = @"IMAGE";
        attachment.image = [info objectForKey: UIImagePickerControllerOriginalImage];

        [self.api uploadImage:attachment.originalPath data:UIImagePNGRepresentation(attachment.image) progress:attachment.progress delegate:self];
        
        [self.photoArray addObject:attachment];
        [attachment release];
        [self loadImages];
    }
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    if(request.tag == VideoType || request.tag == ImageType) {
        ImageFile *file = [self.api data:request bean:[ImageFile class]];
        if(file) {
            Attachment *attachment = [self getAttachment:file];
            [attachment.progress removeFromSuperview];
            attachment.progress = nil;
            [file release];
            if(request.tag == ImageType) {
                [entity.imageAttachments addObject:attachment];
            } else if(request.tag == VideoType) {
                [entity.videoAttachments addObject:attachment];
            }
        }
    }
}

-(Attachment *) getAttachment:(ImageFile *) file {
    for(Attachment * im in photoArray) {
        if([im.originalPath isEqualToString:file.orgFilename]) {
            im.temporaryFilename = file.filename;
            im.uploadDate = file.updated;
            return im;
        }
    }
    return nil;
}
/*
-(void)fbLogged:(LoginType) type{
    NSLog(@"fbLogged");
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //  NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
    // entity.videoId = self.container.selected.videoId;
    
    
    Annotation *annotation;
    
    if (type == FacebookType) {
        NSString *token = [Util getProperties:FACEBOOK];
        
       // annotation = [self.api shareFacebookAnnotation:token annotation:entity];
    } else if (type == TwitterType) {
        NSString *key = [Util getProperties:TWITTER_KEY];
        NSString *secret = [Util getProperties:TWITTER_SECRET];
        
        annotation = [self.api shareTwitterAnnotation:key secret:secret annotation:entity];
    }
    
    
    
    if(annotation){
        entity.pk = annotation.pk;
        
        if (!entity.parenId) {
            
            if ([annotationDelegate respondsToSelector:@selector(addAnnotation:)]) {
                [annotationDelegate addAnnotation:annotation];
            }
            
        }
    }

}
*/

- (void) logged:(LoginType) type {
    
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

     NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
   // entity.videoId = self.container.selected.videoId;
    
    
    Annotation *annotation;
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (type == FacebookType) {
        NSString *token = [Util getProperties:FACEBOOK];
        annotation = entity;/// Added by Anand
        [self performSelector:@selector(openSharingController) withObject:nil afterDelay:0.1];
        //[self sendtoFacebook];
        //[self openSharingController];
        
        //annotation = [self.api shareFacebookAnnotation:token annotation:entity];
        /*
        if(annotation){
            entity.pk = annotation.pk;
            appDelegate.pk = annotation.pk;
            if (!entity.parenId) {
                
                if ([annotationDelegate respondsToSelector:@selector(addAnnotation:)]) {
                    [annotationDelegate addAnnotation:annotation];
                }
                
            }
        }
         */

    } else if (type == TwitterType) {
        NSString *key = [Util getProperties:TWITTER_KEY];
        NSString *secret = [Util getProperties:TWITTER_SECRET];
        [self openTwitterComposerView];
        //annotation = [self.api shareTwitterAnnotation:key secret:secret annotation:entity];
    }
    
   
        
}

- (void) sendtoTweeter:(NSString*)_comment{
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //  NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
    // entity.videoId = self.container.selected.videoId;
    
    
    Annotation *annotation;
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *key = [Util getProperties:TWITTER_KEY];
    NSString *secret = [Util getProperties:TWITTER_SECRET];
    annotation = [self.api shareTwitterAnnotation:key secret:secret annotation:entity comment:_comment];
    
}
/*
- (void) sendtoTweeter{
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //  NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
    // entity.videoId = self.container.selected.videoId;
    
    
    Annotation *annotation;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *key = [Util getProperties:TWITTER_KEY];
    NSString *secret = [Util getProperties:TWITTER_SECRET];
     annotation = [self.api shareTwitterAnnotation:key secret:secret annotation:entity];
    
    
}
 */

-(void)openTwitterComposerView{
    AppDelegate *appDelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
    if(appDelgate.account){
        tweetComposeViewController.account = appDelgate.account;
    }
    tweetComposeViewController.tweetComposeDelegate = self;
    [self presentViewController:tweetComposeViewController animated:YES completion:nil];
    
}

- (void)tweetComposeViewController:(TweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result {
    // Bhavya - 23rd July 2013 message changed
    NSString * message=@"Post was performed successfully";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
    [self dismissModalViewControllerAnimated:YES];
    
}



-(void)openSharingController{
    NSLog(@"openSharingController_Share:");
    
//    if(!FBSession.activeSession.isOpen){
//        [self.api openSessionWithAllowLoginUI:YES];
//    }
    
    
   // AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
   FaceBookViewController* fbviewController = [[FaceBookViewController alloc]
                        initWithNibName:@"FaceBookViewController"
                        bundle:nil];
   // fbviewController.fbuserDict = self.fbuserDict;
   // fbviewController.postUrlString = [self.tempDict objectForKey:@"URL"];
    CGRect rect = fbviewController.view.frame;
    rect.origin.y = 44;
    rect.size.height= 200;
    rect.size.width = 300;
    
    fbviewController.view.frame = rect;
    fbviewController.fbComposeDelegate = self;
    //[appdelgate.window addSubview:fbviewController.view];
    [ self presentModalViewController:fbviewController animated:YES];
    [fbviewController release];
    

}

- (void) sendtoFacebook:(NSString*)fbComment{
    entity.content = [comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //  NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
     //entity.videoId = self.container.selected.videoId;
    
    
    Annotation *annotation;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *key = [Util getProperties:FACEBOOK];
    if([comment.text length]==0){
        appDelegate.videoID =self.container.selected.videoId;
    }
   // annotation = [self.api shareFacebookAnnotation:key annotation:entity];
    annotation = [self.api shareFacebookAnnotation:key annotation:entity comment:fbComment];
    
    
}

-(void)fbComposeViewController:(FaceBookViewController *)controller didFinishWithResult:(FBComposeResult)result{
    // Bhavya - 23rd July 2013, , message changed on 26th July
    //NSString * message=@"Your message is now posted on Facebook.";
    NSString * message=@"Post was performed successfully";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
    [self dismissModalViewControllerAnimated:YES];

}



- (void)dealloc {
    [effect release];
    [photoArray release];
    [entity release];
    
     
    //if(annotationDelegate){
        annotationDelegate=nil;
    //}
    //self.annotationDelegate = nil;

    [super dealloc];
}



@end
