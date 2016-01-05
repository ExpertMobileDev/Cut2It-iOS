//
//  RootAnnotationView.m
//  cut2it
//
//  Created by Mac on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootAnnotationCellView.h"
#import "AppDelegate.h"

#define IMAGE_WIDTH 90
#define IMAGE_HEIGHT 60
#define PADDING 10
#define IMAGES_IN_ROW 3


@interface RootAnnotationCellView ()

@end

@implementation RootAnnotationCellView
@synthesize userName;
@synthesize image;
@synthesize content;
@synthesize btnDelete;
@synthesize btnReply;
@synthesize navigationController;
@synthesize _rootAnnotation;
@synthesize backImage;
@synthesize btnExpand;
@synthesize _duration;
@synthesize btnShare;
@synthesize imageViewArrow;
@synthesize btnAttachments;
@synthesize _scrollView;
@synthesize scrollViewWidth;
@synthesize scrollViewHeight;
@synthesize imageBreaker;
@synthesize theMovie;




- (void) fill:(Annotation *) rootAnnotation:(NSString*) userPk:(NSString*) duration
{
    
    self._rootAnnotation=rootAnnotation;
    //self.userName.text =[NSString stringWithFormat:@"%@ %@",rootAnnotation.username,@":"];
    if(!rootAnnotation.lastName){
        rootAnnotation.lastName=@"";
    }   
    
    self.userName.text =[NSString stringWithFormat:@"%@ %@ %@",rootAnnotation.firstName,rootAnnotation.lastName,@":"];
    self.content.text = self._rootAnnotation.content;
    self.content.userInteractionEnabled = FALSE;
    self._duration.text =duration;    
   
    //to show string text from html text
    self.content.text = [self.content.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.content.text = [self.content.text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
       
    self.content.text = [self.content.text stringByReplacingOccurrencesOfString:@"//" withString:@""];
    self.content.text = [self.content.text stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    self.content.text = [self.content.text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    NSRange r;
    while ((r = [self.content.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        self.content.text = [self.content.text stringByReplacingCharactersInRange:r withString:@""];

    
    self.userName.font= [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    self.content.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    
    self.image.layer.borderWidth = 1;
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // self.backgroundColor =[UIColor clearColor];
    //UIImage * bgImage=[UIImage imageNamed:@"background_comment_free_"];
    //self.backImage.image = bgImage;
    
    
    UIColor * color = [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0];
    self.backImage.backgroundColor =[UIColor clearColor];
    self.backImage.backgroundColor =color;
    
    
    UIImage * imageGreyExpandFree=[UIImage imageNamed:@"btn_show-replies_free_"];
    [self.btnExpand setBackgroundImage:imageGreyExpandFree forState:UIControlStateNormal];
    
    //Bhavya - hide bottom bar if child annotations = 0
    self.btnExpand.hidden = self._rootAnnotation.childrenCount >0 ? FALSE : TRUE;
    
    UIImage * imageArrow=[UIImage imageNamed:@"icon_show-arrow_"];
    self.imageViewArrow.image = imageArrow;
    self.imageViewArrow.hidden = self._rootAnnotation.childrenCount >0 ? FALSE : TRUE;
    
    UIImage * imageReplay=[UIImage imageNamed:@"icon_reply_"];
    [self.btnReply setBackgroundImage:imageReplay forState:UIControlStateNormal];
    
    UIImage * imageClose=[UIImage imageNamed:@"icon_close-x_"];
    [self.btnDelete setBackgroundImage:imageClose forState:UIControlStateNormal];
    
    if([userPk isKindOfClass:[NSString class]] && [userPk isKindOfClass:[NSString class]])
    {
        self.btnDelete.hidden=[userPk isEqualToString:rootAnnotation.userId]?FALSE:TRUE;
    }        
    
    UIImage * imageShare=[UIImage imageNamed:@"vm_share_f"];
    [self.btnShare setBackgroundImage:imageShare forState:UIControlStateNormal];
    
//    Bhavya start - 21st May 2013 (Client said to remove image method)    
//    if (rootAnnotation.avatarLookUp) {
//        [[Cut2itApi shared] image:rootAnnotation.avatarLookUp delegate:self];
//    } else {
//        self.image.image  = [UIImage imageNamed:@"s_avatar_default"];
//    }
    
//    if (rootAnnotation.avatarLookUp) {
//        self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rootAnnotation.avatarLookUp]]];
//        if(self.image.image==nil)
//        {
//            self.image.image  = [UIImage imageNamed:@"s_avatar_default"];
//        }
//    } else {
//        self.image.image  = [UIImage imageNamed:@"s_avatar_default"];
//    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: rootAnnotation.avatarLookUp]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
             self.image.image = [UIImage imageWithData: data];
        });
        [data release];
    });
    
//    dispatch_queue_t myQueue = dispatch_queue_create(NULL,  DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_async(myQueue, ^{
//        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: rootAnnotation.avatarLookUp]];
//        if ( data == nil )
//            return;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.image.image = [UIImage imageWithData: data];
//            dispatch_release(myQueue);
//        });
//    });
    
//    Bhavya end
    
    
    self.userName.frame = CGRectMake(54,self.userName.frame.origin.y,self.userName.frame.size.width,self.userName.frame.size.height);
    self._duration.frame = CGRectMake(54,self._duration.frame.origin.y,self._duration.frame.size.width,self._duration.frame.size.height);
    self.imageViewArrow.frame = CGRectMake(self.imageViewArrow.frame.origin.x, self.btnExpand.frame.origin.y+11, self.imageViewArrow.frame.size.width, self.imageViewArrow.frame.size.height);
    
    self.content.frame = CGRectMake(46,self.content.frame.origin.y,self.content.frame.size.width,self.content.frame.size.height);
    self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    self.content.textColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    //ATTACHMENTS
    UIImage * imageAttach=[UIImage imageNamed:@"btn_attachments_free_"];
    UIImage * imageAttachActive =[UIImage imageNamed:@"btn_attachments-annotation-collapsed_active_"];
    
    [self.btnAttachments setBackgroundImage:imageAttach forState:UIControlStateNormal];
    [self.btnAttachments setBackgroundImage:imageAttachActive forState:UIControlStateHighlighted];
    
    //self.btnAttachments.hidden =  self._rootAnnotation.attachmnets.count >0 ? FALSE:TRUE;
    
    self.btnAttachments.hidden = YES;
    if(self._scrollView)
    {
        for (UIView *subview in [_scrollView subviews]) {
            [subview removeFromSuperview];
        }
        [_scrollView removeFromSuperview];
    }
    
    if(self._rootAnnotation.isShowAttachments == TRUE)
    {
        self._scrollView = [[CustomScrollView alloc] init];
        self.scrollViewHeight=230;
        self.scrollViewWidth=310;
        if(self._rootAnnotation.attachmnets.count<=3)
        {
            self.scrollViewHeight=90;
        }
        if(self._rootAnnotation.attachmnets.count>3 && self._rootAnnotation.attachmnets.count <=6)
        {
            self.scrollViewHeight=165;
        }
        if(self._rootAnnotation.attachmnets.count>9)
        {
            self._scrollView.userInteractionEnabled = TRUE;
            self._scrollView.showsVerticalScrollIndicator = TRUE;
            self._scrollView.showsHorizontalScrollIndicator = FALSE;
        }
        

        _scrollView.customDelegate = self;
        [self._scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
        [self.contentView  addSubview:self._scrollView];
        
        [self loadImages];
        
    }
    UIImage * imgBreaker=[UIImage imageNamed:@"breaker_annotation_inactive_"];
    self.imageBreaker.image = imgBreaker;
    self.imageBreaker.hidden = YES;
    
}
-(void) cellRezise:(float)contentHeight :(float)viewHeight :(float)btnHeight
{    
    CGRect viewFrame = CGRectMake(self.backImage.frame.origin.x,self.backImage.frame.origin.y, self.backImage.frame.size.width,viewHeight);
    self.backImage.frame = viewFrame;    
    
    btnDelete.frame = CGRectMake(self.btnDelete.frame.origin.x,0, self.btnDelete.frame.size.width,
                                 self.btnDelete.frame.size.height);   
    
//  Bhavya - 03rd Sept, Display reply and share button at right top of annotation.
/*  btnReply.frame = CGRectMake(self.btnDelete.frame.origin.x,(self.backImage.frame.size.height - btnHeight*2), self.btnReply.frame.size.width,
                                self.btnReply.frame.size.height);
*/    
     btnReply.frame = CGRectMake(self.btnDelete.frame.origin.x, (self.btnDelete.frame.origin.y+30), self.btnReply.frame.size.width,
                                self.btnReply.frame.size.height);
    
/*   btnShare.frame = CGRectMake(self.btnDelete.frame.origin.x,(self.btnReply.frame.origin.y-30), self.btnShare.frame.size.width,
                                self.btnShare.frame.size.height);

*/
     btnShare.frame = CGRectMake(self.btnDelete.frame.origin.x, self.btnReply.frame.origin.y+30, self.btnShare.frame.size.width,
                                self.btnShare.frame.size.height);
    
    btnExpand.frame = CGRectMake(self.btnExpand.frame.origin.x,self.backImage.frame.size.height - btnHeight, self.btnExpand.frame.size.width,
                                 self.btnExpand.frame.size.height);
    
    btnAttachments.frame = CGRectMake(self.btnAttachments.frame.origin.x,(self.backImage.frame.size.height - btnHeight*2), self.btnAttachments.frame.size.width,
                                      self.btnAttachments.frame.size.height);
    
    self.imageViewArrow.frame = CGRectMake(self.imageViewArrow.frame.origin.x, self.btnExpand.frame.origin.y+11, self.imageViewArrow.frame.size.width, self.imageViewArrow.frame.size.height);
    self.imageBreaker.frame = CGRectMake(self.imageBreaker.frame.origin.x,(self.backImage.frame.size.height - btnHeight*2) -2, self.imageBreaker.frame.size.width, self.imageBreaker.frame.size.height);
    
    self.content.frame = CGRectMake(self.content.frame.origin.x,self.content.frame.origin.y, self.content.frame.size.width,contentHeight);
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self._scrollView.frame = CGRectMake(self.contentView.frame.origin.x+5,self.imageBreaker.frame.origin.y+62, self.scrollViewWidth,self.scrollViewHeight);
    //self.content.backgroundColor = [UIColor clearColor];
    // self.content.layer.borderColor = [UIColor yellowColor].CGColor;
    // self.content.layer.borderWidth=1;
}


- (void)requestFinished:(ASIHTTPRequest *) request {
    
    if(request.tag == DeleteType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadRootAnnotationsAfterDelete"                                                         object: self._rootAnnotation];
    }
    else if(request.tag == LookupType)
    {
        NSData *responseData = [request responseData];
        self.image.image = [UIImage imageWithData:responseData];
    }
}

-(IBAction)reply:(id)sender {
    NSLog(@"theMovie.moviePlayer.currentPlaybackTime:%f",theMovie.moviePlayer.currentPlaybackTime);
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Container *container = [Container shared];
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.videoId = container.selected.pk;
    annotation.mediaId = container.selected.videoId;
    
    annotation.begin=theMovie.moviePlayer.currentPlaybackTime;
    annotation.begin = self._rootAnnotation.begin;
    annotation.end = self._rootAnnotation.end;
    annotation.annotationType =@"TEXT";
    annotation.parenId = self._rootAnnotation.pk;
    annotation.rootId = self._rootAnnotation.pk;
    appDelegate.replyClicked = !appDelegate.replyClicked;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseWhenReply"                                                         object: self._rootAnnotation];
    
    ShareViewController  *controller = [[ShareViewController alloc] init];
    controller.entity = annotation;
    [annotation release];
    
    [navigationController pushViewController:controller animated:YES];
    [controller release];     
}

-(IBAction)remove:(id)sender
{
    [[Cut2itApi shared] deleteAnnotation:self._rootAnnotation.pk delegate:self];
}

-(void)loadImages {
    
    if(_rootAnnotation.isShowAttachments == TRUE)
    {
        int count =[self._rootAnnotation.attachmnets count];
        int rows = count/IMAGES_IN_ROW;
        if (count % IMAGES_IN_ROW != 0) {
            rows++;
        }
        
        for (UIView *subview in [_scrollView subviews]) {
            [subview removeFromSuperview];
        }
        
        [_scrollView setContentSize:CGSizeMake(self.scrollViewWidth, rows * (IMAGE_HEIGHT + PADDING) + 20)];
        
        for (int i=0; i<count; i++) {
            int row = i/IMAGES_IN_ROW;
            int column = i%IMAGES_IN_ROW;
            CGRect imageFrame;
            imageFrame = CGRectMake(column * (IMAGE_WIDTH + PADDING) + 6, row * (IMAGE_HEIGHT + PADDING)+15, IMAGE_WIDTH, IMAGE_HEIGHT);
            
            UIImageThumbnailView * thImage = [[UIImageThumbnailView alloc] init];
            thImage.frame = imageFrame;
            thImage.tag = i;
            thImage.backgroundColor = [UIColor darkGrayColor];
            
            Attachment *attachment = [self._rootAnnotation.attachmnets objectAtIndex:i];
            
            if(attachment)
            {
                [thImage fillAttachment:attachment];
                thImage.layer.borderColor = [[UIColor whiteColor] CGColor];
                thImage.layer.borderWidth = 1;
                [self._scrollView addSubview:thImage];
                
                thImage.userInteractionEnabled = YES;
                
                if(attachment.videoId)
                {
                    UIButton *imagePlay = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_WIDTH/3, 15, 29, 29)];
                    imagePlay.tag = i;
                    imagePlay.userInteractionEnabled = YES;
                    [imagePlay addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [imagePlay setBackgroundImage:[UIImage imageNamed:@"e_play"] forState:UIControlStateNormal];
                    [thImage bringSubviewToFront:imagePlay];
                    [thImage addSubview:imagePlay];
                    
                    [imagePlay release];
                }
                else{
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
                    [thImage addGestureRecognizer:tap];
                    [tap release];
                 
                    
 
                }
            }
            [thImage release];
        }
    }
    
}

-(void)scrollTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}
-(void)scrollTouchesEnd:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint fromPosition = [[[touches allObjects] objectAtIndex:0] locationInView:_scrollView];
    int row,column;
    row = (int)(fromPosition.y / (IMAGE_HEIGHT + PADDING));
    column = (int)(fromPosition.x / (IMAGE_WIDTH + PADDING));
}


-(void) playVideo:(id)sender
{
    UIButton * thImage = (UIButton*)sender;
    int i = thImage.tag;
    Attachment *attachment = [self._rootAnnotation.attachmnets objectAtIndex:i];
    
    if(attachment.videoId)
    {
        // Bhavya 12th Aug 2013 - after implement wowza server, the response changes. Now there is video from youtube server and video from wowza server
        NSURL *videoURL = [[NSURL alloc]init];
        if([attachment.storageType isEqualToString:@"YOUTUBE"])
        {
            videoURL = [[Cut2itApi shared] youtubeEncodedUrl:attachment.videoId];
        }
        else
        {
            videoURL = [NSURL URLWithString:attachment.youtubeUrl];
        }
        //NSURL *videoURL = [[Cut2itApi shared] youtubeEncodedUrl:attachment.videoId];
        
        theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:theMovie.moviePlayer];
        
        [self.navigationController presentMoviePlayerViewControllerAnimated:theMovie];
        [theMovie.moviePlayer play];
        
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayVideoNotification" object:self._rootAnnotation];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie.moviePlayer];
}

-(void) showImage:(UITapGestureRecognizer *)tap
{
    UIImageThumbnailView * thImage = (UIImageThumbnailView*) tap.view;
    int i = thImage.tag;
    Attachment *attachment = [self._rootAnnotation.attachmnets objectAtIndex:i];
    
    AttachmentViewController *controller = [[AttachmentViewController alloc] init];
    controller.navigationItem.title = @"Attachment";
    controller.imageUrl = attachment.imageUrl;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)dealloc {
    [navigationController release];
    [_rootAnnotation release];
    [theMovie release];
    [_scrollView release];
    [super dealloc];
}


@end
