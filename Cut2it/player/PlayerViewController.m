//
//  PlayerViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "ConfigureServiceViewController.h"
#import "CustomClass.h"
#import "AppDelegate.h"
#import "ShareViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize player;
@synthesize watchView;
@synthesize editView;
@synthesize annotations;
@synthesize isMore;
@synthesize selectedAnnotation;
@synthesize temparray;
@synthesize selTabIndex;


- (id) initWithMedia:(Media *) m {
    
    self.isMore = FALSE;
    NSURL *url = [[NSURL alloc] init];
    
    // Bhavya 12th Aug 2013- after implement wowza server, the response changes. Now there is video from youtube server and video from wowza server
    if([m.storageType isEqualToString:@"YOUTUBE"])
    {
        url = [[Cut2itApi shared] youtubeEncodedUrl:m.videoId];
    }
    else
    {
        url = [NSURL URLWithString:m.youtubeUrl];
    }
    
//  url = [NSURL URLWithString:[@"http://vds022.javanode.com:1935/vod/mp4:402881283ea9795d013ee181fd6501d8.mp4/playlist.m3u8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    self.video = [[FrameExtractor alloc] initWithVideo:@"rtsp://vds022.javanode.com:1935/vod/mp4:402881283ea9795d013ee181fd6501d8.mp4"];
    
    if (!url) {
        return nil;
    }
    return [self initWithContentURL:url media:m];
}

- (id) initWithContentURL:(NSURL *) url media:(Media *) m {
     
    self = [super init];
    if (self) {
        self.container.selected = m;
//        if (self.player != nil) {            
//            [self.player.view removeFromSuperview];
//            self.player = nil;
//            [self.player release];            
//        }
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        self.player.controlStyle = MPMovieControlStyleNone;
        self.player.fullscreen = YES;
        [self.player prepareToPlay];
        self.player.shouldAutoplay = NO;
        [self.player play];
        [self.player release];
        
        thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
        [player.view addSubview:thumbnail];
        [thumbnail release];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(215, 135, 50, 50);
        indicator.hidesWhenStopped = YES;
        indicator.color = [UIColor grayColor];
        indicator.layer.cornerRadius = 5;
        [player.view addSubview:indicator];
        [indicator startAnimating];
        [indicator release];
        
        self.watchView = [[WatchView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) title:self.container.selected.title];
        self.watchView.tag = 100;
        self.watchView.player = self.player;
        self.watchView.delegate = self;
        [player.view addSubview:self.watchView];
        [self.watchView release];
        
        self.editView = [[EditView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
        self.editView.tag = 200;
        self.editView.player = self.player;
        self.editView.delegate = self;
        //editView.backgroundColor = [UIColor greenColor];
        [player.view addSubview:self.editView];
        [self.editView release];
         
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(annotationsDeleteChanged:)
                                                     name:@"LoadRootAnnotationsAfterDelete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(savePosition:)
                                                     name:@"UploadVideoNotification"
                                                   object:nil];             
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addAnnotationFun:)                                                     name:@"addannotationNotification"
                                                   object:nil];
        
        //RefreshAnnotation
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refresh:)
                                                     name:@"RefreshAnnotation"
                                                   object:nil];
         */
       
       
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGSize size = screenBounds.size;
    if (size.height < size.width) {
        CGFloat temp = size.height;
        size.height = size.width;
        size.width = temp;
    }
    
    if (size.height == 568) {
        self.player.view.frame = CGRectMake(44, 0, 480, 320);
        
        if (!letterbox) {
            letterbox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 320)];
            letterbox.backgroundColor = [UIColor blackColor];
            [self.view addSubview:letterbox];
            [letterbox release];
        }
        
        if (!pillarbox) {
            pillarbox = [[UIView alloc] initWithFrame:CGRectMake(524, 0, 44, 320)];
            pillarbox.backgroundColor = [UIColor blackColor];
            [self.view addSubview:pillarbox];
            [pillarbox release];
        }
    } else {
        self.player.view.frame = CGRectMake(0, 0, 480, 320);
    }

    if (current != -1) {
        self.player.currentPlaybackTime = current;
        current = -1;
    }
    
    [self.view insertSubview:player.view atIndex:0];
    watchView.hidden = NO;
    editView.hidden = NO;
    //[self.editView clearShape];
    //[self.editView changeShape:nil];
    
    [self.watchView playSegment:-1 end:-1];
//    [super blankRotate];        
    [self setOrientation:UIInterfaceOrientationLandscapeLeft];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    watchView.hidden = YES;
    editView.hidden = YES;
//    [super blankRotate];
    [self setOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    temparray = [[NSMutableArray alloc] init];
    @try {
//          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnnotation123:) name:@"addAnnotation123" object:nil];
        
        // Bhavya - 08th Aug 2013. New implementation to download video thumbnail as Server sends now the thumbnail url in response.
        // On click of video thumbnail
        [[Cut2itApi shared] imageThumbnail:self.container.selected.thumbnailUrl delegate:self];
//      [[Cut2itApi shared] imageYouTube:self.container.selected.videoId name:@"default.jpg" delegate:self];
        self.container.playerView = self.player.view;
        // Do any additional setup after loading the view.
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"LoadRootAnnotationsAfterDelete"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UploadVideoNotification"
                                                  object:nil];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}

- (void) finish:(id) data {
    
    self.annotations = data;
    //self.watchView.list = data;    
    
    if([temparray count]>0){
        [temparray removeAllObjects];
    }
    
    if([self.annotations count]>0)
    {
        if([[self.annotations objectAtIndex:0] isKindOfClass:[Annotation class]])
        {
            for (Annotation *annot in self.annotations) {
                
                NSLog(@"annotation_content:%@",annot.content);
                NSLog(@"annotation_Title:%@",annot.title);
                if(annot.content && [annot.content length]!=0){
                    [self.temparray addObject:annot];
                    
                }
            }
        }
    }
   
        
    if([temparray count]>0){
        NSLog(@"temparray:%@",temparray);
        self.watchView.list = temparray;
        
    }    
    
    if (self.container.annotationId) {
        [watchView replayAnnotation:self.container.annotationId];
        self.container.annotationId = nil;
    }
    if(self.isMore == TRUE)
    {
               
        [indicator removeFromSuperview];
        
        DiscussionViewController *controller = [[DiscussionViewController alloc] init];
        controller.selectedRootAnnotation = self.selectedAnnotation;
        //controller.rootAnnotations = self.annotations;
        controller.rootAnnotations = self.temparray;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        self.isMore = FALSE;
        
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    NSData *responseData = [request responseData];
    thumbnail.image = [UIImage imageWithData:responseData];
}

- (void) savePosition:(NSNotification *) notification {
    if (current == -1) {
        current = self.player.currentPlaybackTime;
    }
}

- (void) moviePlayerLoadStateChanged:(NSNotification *) notification {
    // Bhavya - added try catch
    @try
    {   
    
     NSLog(@"moviePlayerLoadStateChanged");
    if (player.loadState != MPMovieLoadStateUnknown) {
        NSLog(@"moviePlayerLoadStateChanged123");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
         
        
        [indicator removeFromSuperview];
        [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             thumbnail.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [thumbnail removeFromSuperview];
                             thumbnail = nil;
                             [editView playerState:self.player.loadState];
                             [watchView playerState:self.player.loadState];
                             
                             if(self.container)
                             {
                                 if (self.container.selected.videoId) {
                                     //Bhavya - 8th may 2013
                                     //[self.api listAnnotation:self.container.selected.videoId];
                                     [self.api listAnnotation:self.container.selected.pk];
                                 }
                                 
                                 else {
                                     [self finish:[NSMutableArray array]];
                                 }
                             }  
                              
                         }];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally...");
    }
}

- (void) shareVideo{
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.videoId = self.container.selected.pk;
    annotation.mediaId = self.container.selected.videoId;
    annotation.begin = 0;
    annotation.end = self.player.duration;
    annotation.annotationType = @"TEXT";
    
    MarkedArea area;
    area.time = 0;
    annotation.markedArea = area;
    
    
    ShareViewController *controller = [[ShareViewController alloc] init];
    controller.entity = annotation;
    controller.annotationDelegate = self;
    
    //Bhavya - tab index passed to ShareViewController
    controller.selTabIndex = self.selTabIndex;
    
    //controller.addAnnotationDelegate = self;
    [annotation release];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (MediaRating *) loadLike {
    return [self.api loadMediaLike:self.container.selected.pk];
}

- (void) like {
    if(self.selTabIndex.intValue==2)
    {
        // Bhavya - 26th June 2013, Added the check if(self.selTabIndex.intValue==2) because of new
        // implementatin of new create media api (to resolve the Youtube search video issue)
        Media *media = self.container.selected;
        Media *created = [self.api createMediaNewWithAnnotation:media :nil status:LIKE];
    }
    else{
         [self.api mediaLike:self.container.selected.pk status:LIKE];
    }
//    [self.api mediaLike:self.container.selected.pk status:LIKE];
}

- (void) unlike {
    // Bhavya - 26th June 2013, Added the check if(self.selTabIndex.intValue==2) because of new
    // implementatin of new create media api (to resolve the Youtube search video issue)
    if(self.selTabIndex.intValue==2)
    {
        Media *media = self.container.selected;
        Media *created = [self.api createMediaNewWithAnnotation:media :nil status:UNLIKE];
    }
    else{
        [self.api mediaLike:self.container.selected.pk status:UNLIKE];
    }
//    [self.api mediaLike:self.container.selected.pk status:UNLIKE];
}

- (void) close {
    // bhavya added try catch
    @try {
        self.container.selected = nil;
        self.container.playerView = nil;
        [self.player pause];
        [editView.sliderView close];
        
        
        [[self.delegate navigationController] popToViewController:self animated:NO];
        [[self.delegate navigationController] popViewControllerAnimated:YES];
        //[[self.delegate navigationController] setNavigationBarHidden:YES];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
    }
    
   
}

- (void) share:(float) start end:(float) end area:(MarkedArea) area {
    [editView showHideView];
    [watchView showHideView];
    
    Annotation *annotation = [[Annotation alloc] init];
    annotation.videoId = self.container.selected.pk;
    annotation.mediaId = self.container.selected.videoId;
    annotation.begin = start;
    annotation.end = end;
    annotation.annotationType = @"TEXT";
    if (area.type != Clear) {
        annotation.markedArea = area;
    }
    
    ShareViewController *controller = [[ShareViewController alloc] init];
    controller.entity = annotation;
    controller.annotationDelegate = self;
    controller.selTabIndex = self.selTabIndex;
    //controller.addAnnotationDelegate = self;
    
    [annotation release];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

/*
- (void)shareViewController:(ShareViewController *)controller addAnnotation:(Annotation *) annotation{
    for (Annotation *a in self.annotations) {
        if ([a.pk isEqualToNumber:annotation.pk]) {
            [self.annotations removeObject:a];
            break;
        }
    }
    
    int index = 0;
    BOOL isAddToEnd  = TRUE;
    for (Annotation *a in self.annotations) {
        if (a.begin > annotation.begin) {
            [self.annotations insertObject:annotation atIndex:index];
            isAddToEnd = FALSE;
            break;
        }
        index ++;
    }
    if(isAddToEnd == TRUE)
    {
        [self.annotations addObject:annotation];
    }


}
 */
-(void)addAnnotationFun:(NSNotification*)notification{
    NSLog(@"addAnnotationFun");
    Annotation *annotation = [notification object];
    if(annotation){
        for (Annotation *a in self.annotations) {
            if([a isKindOfClass:[Annotation class]])
            {
                if (a.pk.intValue == annotation.pk.intValue) {
                    [self.annotations removeObject:a];
                    break;
                }
            }            
        }
        
        int index = 0;
        BOOL isAddToEnd  = TRUE;
        for (Annotation *a in self.annotations) {
            if (a.begin > annotation.begin) {
                [self.annotations insertObject:annotation atIndex:index];
                isAddToEnd = FALSE;
                break;
            }
            index ++;
        }
        if(isAddToEnd == TRUE)
        {
            [self.annotations addObject:annotation];
        }

    
    }
}

- (void) addAnnotation:(Annotation *) annotation {
    NSLog(@"addAnnotation_Delegate");
        /*
    for (Annotation *a in self.annotations) {
        if ([a.pk isEqualToNumber:annotation.pk]) {
            [self.annotations removeObject:a];
            break;
        }
    }
    
    int index = 0;
    BOOL isAddToEnd  = TRUE;
    for (Annotation *a in self.annotations) {    
        if (a.begin > annotation.begin) {
            [self.annotations insertObject:annotation atIndex:index];
            isAddToEnd = FALSE;
            break;
        }
        index ++;
    }
    if(isAddToEnd == TRUE)
    {
     [self.annotations addObject:annotation];
    }
     */
}
 
 
#pragma mark -
#pragma mark CPlayerDelegate

- (void) done {
    [self.player play];
}

-(void) more:(Annotation *) annotation {
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(215, 135, 50, 50);
    indicator.hidesWhenStopped = YES;
    indicator.color = [UIColor grayColor];
    indicator.layer.cornerRadius = 5;
    [player.view addSubview:indicator];
    [indicator startAnimating];
    [indicator release];
    
    self.isMore = TRUE;
    self.selectedAnnotation = annotation;
    //Bhavya - 8th may 2013 (client said for flash server)
    //[self.api listAnnotation:self.container.selected.videoId];
    [self.api listAnnotation:self.container.selected.pk];
    
}


- (void) current:(Annotation *) annotation {
    MarkedArea area = annotation.markedArea;
    if (area.type != Clear && area.time != -1) {
        [editView.sliderView current:area.time];
    } else {
        [editView.sliderView current:annotation.begin];
    }
}

- (void) annotationsDeleteChanged:(NSNotification*) notification {
    Annotation * annotation = notification.object;
    UIButton *button;
    
    for(Annotation *entity in self.annotations) {
        if ([entity isEqual:annotation]) {
            button = entity.button;
            [self.annotations removeObject:entity];
            [button removeFromSuperview];
            break;
        }
    }
    
    for(Annotation *entity in self.annotations) {
        if (entity.button == button) {
            entity.button = nil;
            entity.sub = NO;
        }
    }
}

- (void) dealloc {
   
    [player release];
    [watchView release];
    [editView release];
    [annotations release];
    [selectedAnnotation release];
    [temparray release];
    [super dealloc];
}

// Bhavya - to hide status bar in iOS 7. Also set in plist View controller-based status bar appearance - NO
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
