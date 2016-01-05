//
//  AnnotationCellViewCell.m
//  cut2it
//
//  Created by Mac on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnnotationCellView.h"

#define IMAGE_WIDTH 90
#define IMAGE_HEIGHT 60
#define PADDING 10
#define IMAGES_IN_ROW 3

@implementation AnnotationCellView
@synthesize userName;
@synthesize image;
@synthesize content;
@synthesize btnDelete;
@synthesize btnReply;
@synthesize navigationController;
@synthesize _rootAnnotation;
@synthesize _annotation;
@synthesize backImage;
@synthesize imageShadow;
@synthesize btnShare;
@synthesize _parentAnnotation;
@synthesize btnAttachments;
@synthesize _scrollView;
@synthesize scrollViewHeight;
@synthesize scrollViewWidth;
@synthesize imageBreaker;
@synthesize imageSeparator;
@synthesize theMovie;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) fill:(Annotation *) rootAnnotation :(Annotation *) parentAnnotation :(Annotation *) annotation:(NSString*)userPk
{
    
    self._annotation=annotation;
    self._rootAnnotation= rootAnnotation;
    //self.userName.text =[NSString stringWithFormat:@"%@ %@",self._annotation.username,@":"];
    if(!self._annotation.lastName){
        self._annotation.lastName=@"";
    }
        
    self.userName.text =[NSString stringWithFormat:@"%@ %@ %@",self._annotation.firstName,self._annotation.lastName,@":"];
    
    
    self.content.userInteractionEnabled = FALSE;
    self.content.text =self._annotation.content;   
    
    
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
    
    UIColor * childColor = [UIColor colorWithRed:27.0/255.0 green:65.0/255.0 blue:104.0/255.0 alpha:1.0];
    self.backImage.backgroundColor =childColor;
    
    //  self.contentView.backgroundColor = color;
    // self.backImage.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background_reply_active_"]];
    
    UIImage * imageReplay=[UIImage imageNamed:@"icon_reply_"];
    [self.btnReply setBackgroundImage:imageReplay forState:UIControlStateNormal];
    //  self.backImage.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background_comment_free_"]];
    
    
    
    UIImage * imageClose=[UIImage imageNamed:@"icon_close-x_"];
    [self.btnDelete setBackgroundImage:imageClose forState:UIControlStateNormal];
    
    UIImage * imageShare=[UIImage imageNamed:@"vm_share_f"];
    [self.btnShare setBackgroundImage:imageShare forState:UIControlStateNormal];
    
    self.btnDelete.hidden=[userPk isEqualToString:annotation.userId]?FALSE:TRUE;
    
    self.btnReply.enabled = TRUE;
    self.btnDelete.enabled = TRUE;
    
//  Bhavya start - 21st May 2013 (Client said to remove image method present in Cut2it.h)
//    if (annotation.avatarLookUp) {
//        [[Cut2itApi shared] image:annotation.avatarLookUp delegate:self];
//    } else {
//        self.image.image  = [UIImage imageNamed:@"s_avatar_default"];
//    }
    
//    if (annotation.avatarLookUp)
//    {    
//        self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:annotation.avatarLookUp]]];
//        if(self.image.image==nil)
//        {
//            self.image.image  = [UIImage imageNamed:@"s_avatar_default"];
//        }
//    } else {
//        self.image.image  = [UIImage imageNamed:@"s_avatar_default"];    
//    }
//    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:annotation.avatarLookUp]];
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
//        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: annotation.avatarLookUp]];
//        if ( data == nil )
//            return;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.image.image = [UIImage imageWithData: data];
//            dispatch_release(myQueue);
//        });
//    });
    
// Bhavya - end
    
    self.userName.frame = CGRectMake(50,self.userName.frame.origin.y,self.userName.frame.size.width,self.userName.frame.size.height);
    self.content.frame = CGRectMake(42,self.content.frame.origin.y,self.content.frame.size.width,self.content.frame.size.height);
    
    
  //  self.content.layer.borderColor = [UIColor yellowColor].CGColor;
  //  self.content.layer.borderWidth=1;
    self.content.backgroundColor = [UIColor clearColor];
    self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    self.content.textColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:229.0/255 alpha:1];
    
    
    //ATTACHMENTS
    UIImage * imageAttach=[UIImage imageNamed:@"btn_attachments_free_"];
    UIImage * imageAttachActive=[UIImage imageNamed:@"btn_attachments_active_"];
    [self.btnAttachments setBackgroundImage:imageAttach forState:UIControlStateNormal];
    [self.btnAttachments setBackgroundImage:imageAttachActive forState:UIControlStateHighlighted];
    //self.btnAttachments.hidden =  self._annotation.attachmnets.count >0 ? FALSE:TRUE;
    //self.imageSeparator.hidden = self._annotation.isShowAttachments == TRUE ? FALSE:TRUE;
    self.btnAttachments.hidden =YES;
    self.imageSeparator.hidden =YES;
    
    if(self._scrollView)
    {
        for (UIView *subview in [_scrollView subviews]) {
            [subview removeFromSuperview];
        }
        [_scrollView removeFromSuperview];
    }
    if(self._annotation.isShowAttachments == TRUE)
    {
        
        self._scrollView = [[CustomScrollView alloc] init];
        self.scrollViewHeight=230;
        self.scrollViewWidth=310;
        if(self._annotation.attachmnets.count<=3)
        {
            self.scrollViewHeight=90;
        }
        if(self._annotation.attachmnets.count>3 && self._annotation.attachmnets.count <=6)
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
        [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
        [self.contentView  addSubview:self._scrollView];
        [self loadImages];
    }
    
    UIColor * colorScroll = [UIColor colorWithRed:14.0/255.0 green:44.0/255.0 blue:66.0/255.0 alpha:1.0];
    [self._scrollView setBackgroundColor:colorScroll];
    
    UIImage * imgBreaker=[UIImage imageNamed:@"breaker_reply_active_"];
    self.imageBreaker.image = imgBreaker;
    self.imageBreaker.hidden = YES;
    
    self.imageSeparator.backgroundColor = childColor;
    //self.btnAttachments.userInteractionEnabled = FALSE;
}
-(void) cellRezise:(float)contentHeight :(float)viewHeight :(float)btnHeight
{ 
    CGRect viewFrame = CGRectMake(self.backImage.frame.origin.x,self.backImage.frame.origin.y, self.backImage.frame.size.width,viewHeight);
    self.backImage.frame = viewFrame;
    
    self.btnDelete.frame = CGRectMake(self.btnDelete.frame.origin.x,0, self.btnDelete.frame.size.width, self.btnDelete.frame.size.height);
//  Bhavya - 03rd Sept, Display reply and share button at right top of annotation.    
/*    self.btnReply.frame = CGRectMake(self.btnDelete.frame.origin.x,self.backImage.frame.size.height - btnHeight, self.btnReply.frame.size.width,
                                     self.btnReply.frame.size.height);
*/
    self.btnReply.frame = CGRectMake(self.btnDelete.frame.origin.x, (self.btnDelete.frame.origin.y+30), self.btnReply.frame.size.width,
                                     self.btnReply.frame.size.height);
    
/*    btnShare.frame = CGRectMake(self.btnDelete.frame.origin.x,(self.btnReply.frame.origin.y-30), self.btnShare.frame.size.width,
                                self.btnShare.frame.size.height);
*/    
    btnShare.frame = CGRectMake(self.btnDelete.frame.origin.x,(self.btnReply.frame.origin.y+30), self.btnShare.frame.size.width,
                                self.btnShare.frame.size.height);

    self.content.frame = CGRectMake(self.content.frame.origin.x,self.content.frame.origin.y, self.content.frame.size.width, contentHeight);
    
    self.btnAttachments.frame = CGRectMake(self.btnAttachments.frame.origin.x,self.backImage.frame.size.height - btnHeight, self.btnAttachments.frame.size.width,
                                           self.btnAttachments.frame.size.height);     
    
    self.imageBreaker.frame = CGRectMake(self.imageBreaker.frame.origin.x,self.backImage.frame.size.height - btnHeight-2 , self.imageBreaker.frame.size.width, self.imageBreaker.frame.size.height);
    
    self.imageSeparator.frame = CGRectMake(self.imageSeparator.frame.origin.x, self.imageBreaker.frame.origin.y + 32,self.imageSeparator.frame.size.width,self.imageSeparator.frame.size.height);
    self._scrollView.frame = CGRectMake(self.contentView.frame.origin.x+5,self.imageBreaker.frame.origin.y+42, self.scrollViewWidth,self.scrollViewHeight);
}
- (void)requestFinished:(ASIHTTPRequest *) request {
    
    
    if (request.tag == DeleteType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAnnotations"
                                                            object: nil];
    }
    else if(request.tag == LookupType)
    {
        NSData *responseData = [request responseData];
        self.image.image = [UIImage imageWithData:responseData];
    }
}

-(IBAction) remove:(id)sender
{
    [[Cut2itApi shared] deleteAnnotation:self._annotation.pk delegate:self];
}



-(IBAction)reply:(id)sender {
    NSLog(@"theMovie.moviePlayer.currentPlaybackTime_123:%f",theMovie.moviePlayer.currentPlaybackTime);
    Container *container = [Container shared];
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.videoId = container.selected.pk;
    annotation.mediaId = container.selected.videoId;
    annotation.begin = self._rootAnnotation.begin;
    annotation.end = self._rootAnnotation.end;
    annotation.annotationType = @"TEXT";
    annotation.parenId =self._annotation.pk;
    annotation.rootId = self._rootAnnotation.pk;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseWhenReply" object: self._rootAnnotation];
    
    ShareViewController  *controller = [[ShareViewController alloc] init];
    controller.entity=annotation;
    [annotation release];
    
    [navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)loadImages {
    
    if(_annotation.isShowAttachments == TRUE)
    {
        int count =[self._annotation.attachmnets count];
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
            imageFrame = CGRectMake(column * (IMAGE_WIDTH + PADDING) + 8, row * (IMAGE_HEIGHT + PADDING)+15, IMAGE_WIDTH, IMAGE_HEIGHT);
        
            UIImageThumbnailView * thImage = [[UIImageThumbnailView alloc] init];
            thImage.frame = imageFrame;
            thImage.tag = i;
            
            thImage.backgroundColor = [UIColor darkGrayColor];
            
            Attachment *attachment = [self._annotation.attachmnets objectAtIndex:i];
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
    Attachment *attachment = [self._annotation.attachmnets objectAtIndex:i];
 
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
    Attachment *attachment = [self._annotation.attachmnets objectAtIndex:i];
    AttachmentViewController *controller = [[AttachmentViewController alloc] init];
    controller.navigationItem.title = @"Attachment";
    controller.imageUrl = attachment.imageUrl;
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
    
}


- (void)dealloc {
    [navigationController release];
    [_parentAnnotation release];
    [_rootAnnotation release];
    [_annotation release];
    [_scrollView release];
    [theMovie release];
    
    [super dealloc];
}
@end
