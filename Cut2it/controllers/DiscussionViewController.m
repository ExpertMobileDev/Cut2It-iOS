//
//  AnnotationsView.m
//  cut2it
//
//  Created by Mac on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscussionViewController.h"


#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FacebookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import "FacebookSDK.h"

#import "AppDelegate.h"
#import "FaceBookViewController.h"
#import "TweetComposeViewController.h"

@interface DiscussionViewController ()

@end

@implementation DiscussionViewController

@synthesize image;
@synthesize description;
@synthesize duration;
@synthesize selectedRootAnnotation;
@synthesize rootCell;
@synthesize rootAnnotations;
@synthesize countCell;
@synthesize insertIndexPaths;
@synthesize selectedCellRow;
@synthesize koef;
@synthesize temparrayNew;


@synthesize _table;
@synthesize annotations;
@synthesize childViewHeight;
@synthesize childBtnHeight;
@synthesize childContentHeight;
@synthesize rootContentHeight;
@synthesize rootBtnHeight;
@synthesize rootViewHeight;

@synthesize youTubeCell;

@synthesize  yImage;
@synthesize  yBackImage;
@synthesize  yTitle;
@synthesize  yDescription;
@synthesize  yStart;
@synthesize yEnd;
@synthesize entity;

@synthesize menu;
@synthesize sharedAnnotation;
@synthesize sharedParentAnnotation;
@synthesize sharedRootAnnotation;
@synthesize isUpdatingChildAnnotations;
@synthesize isUpdatingRootAnnotations;
@synthesize isNextStepUpdatingChildAnnotations;
@synthesize isPost;
@synthesize temparray;

@synthesize isTappedSameRow;
@synthesize rowClicked;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        temparray = [[NSMutableArray alloc] init];
        temparrayNew= [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(annotationsStateChanged:)
                                                     name:@"ReloadAnnotations"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootAnnotationsDeleteChanged:)
                                                     name:@"LoadRootAnnotationsAfterDelete"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playVideoNotification:)
                                                     name:@"PlayVideoNotification"
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Comments";
    UIBarButtonItem *save = [self createBarButtonWithName:@"Done" image:@"rounded" width:68 target:self action:@selector(done:)];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common_"]];
    
    self.navigationItem.rightBarButtonItem = save;
    [self.navigationItem setHidesBackButton:TRUE];
    
    childViewHeight = 50; //100;
    childContentHeight = 15;
    childBtnHeight =30;
    
   // childBtnHeight =10;
    
    
    rootViewHeight =100; //130 
    rootContentHeight =40; 
    rootBtnHeight =29;
    
    countCell=0;
    koef= 0;
    selectedCellRow = -1;
    self.isUpdatingChildAnnotations = FALSE;
    self.isUpdatingRootAnnotations = FALSE;
    self.isNextStepUpdatingChildAnnotations = FALSE;
    self.isPost = FALSE;
 
    
    [self initializeRootAnnotations];
    [self expandTable];
    [self initShareMenu];
}
-(void) expandTable
{
    int row= [self getSelectedRow];
    Annotation * annotation = [self.rootAnnotations objectAtIndex:row];
    [self setMainVideoData:annotation];
    
    if(self.selectedCellRow==-1)
    {
        [self insertAdditionalRowsIntable:row];
    }
    if(row>0){
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    }
    [_table reloadData];
   
}

-(int) getSelectedRow
{
    int i=0;
    for(Annotation * a in self.rootAnnotations)
    {
        //if([a.pk intValue]== [self.selectedRootAnnotation.pk intValue])
        
        NSLog(@"%@ and %@", a.pk,self.selectedRootAnnotation.pk);
        if([a.pk isEqualToString:self.selectedRootAnnotation.pk])
        {
            return i;
        }
        i++;
    }
    return i;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) done:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - RooAnnotation

-(void) setMainVideoData:(Annotation *)curAnnotation
{ 
    Media *media = self.container.selected;
    NSString *start = [Util timeFormat:curAnnotation.begin];
    NSString *end = [Util timeFormat:curAnnotation.end];
    
    yTitle.font= [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    yDescription.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    yStart.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    yEnd.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    
    yTitle.textColor = [UIColor colorWithWhite:1.0 alpha:1];
    yDescription.textColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:229.0/255 alpha:1];
    yStart.textColor = [UIColor colorWithWhite:1.0 alpha:1];
    yEnd.textColor = [UIColor colorWithWhite:1.0 alpha:1];

    UIView *player = self.container.playerView;
    player.frame = CGRectMake(0, 0, yImage.frame.size.width, yImage.frame.size.height);
    [yImage addSubview:player];
    
    
    [self fillMedia:media :[NSString stringWithFormat:@"Start: %@", start] :[NSString stringWithFormat:@"End: %@",end]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAnnotationSegment" object:curAnnotation];
}


- (void) fillMedia:(Media *) view:(NSString *) start:(NSString *) end
{
    self.yTitle.text = view.title;
    //self.yTitle.text = @"To check";
    self.yDescription.text = view.description;
    self.yImage.layer.borderWidth = 1;
    self.yImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.yStart.text = start;
    self.yEnd.text = end;
    
    CGRect frame = self.duration.frame;
    frame.size.width = 185;
    self.duration.frame = frame;
}

-(void) tapReceivedBackground:(UITapGestureRecognizer *)tap
{
    [self hideShareMenu];
}

#pragma mark - Attachments
-(void)showHideCommentAttachments:(id)sender
{
   
    UIButton *senderButton = (UIButton *)sender;
    int row = senderButton.tag;
    
    Annotation * annotation = [self.annotations objectAtIndex:row];
    annotation.isShowAttachments = annotation.isShowAttachments == FALSE ? TRUE:FALSE;
    [_table reloadData];
}
-(void)  showHideRootAttachments:(id)sender
{
   UIButton *senderButton = (UIButton *)sender;
    int row = senderButton.tag;

    Annotation * annotation = [self.rootAnnotations objectAtIndex:row];
    annotation.isShowAttachments = annotation.isShowAttachments == FALSE ? TRUE:FALSE;
    [_table reloadData];  
}

#pragma mark - Comments
-(void) tapReceivedExpand:(UITapGestureRecognizer *)tap
{    
    [self hideShareMenu];
    BOOL firstInsert = FALSE;
    
    RootAnnotationCellView *cell = (RootAnnotationCellView *)tap.view.superview.superview;
    int row = cell.tag;
    
    Annotation * annotation = [self.rootAnnotations objectAtIndex:row];
    [self setMainVideoData:annotation];
    
    if(selectedCellRow==-1)
    {
        firstInsert = TRUE;
        [self insertAdditionalRowsIntable:row];
    }
    else if(countCell > 0 && insertIndexPaths.count >0)
    {
        [self deleteAdditionalRows];
        self.annotations = nil;
    }    
    if(self.selectedCellRow != row)
    {
        firstInsert = FALSE;
        [self insertAdditionalRowsIntable:row];
        isTappedSameRow = FALSE;
    }
    else if(firstInsert == FALSE)
    {
       rowClicked = self.selectedCellRow;
       self.selectedCellRow = -1;
        isTappedSameRow = TRUE;
        [_table reloadData];
        /* Bhavya - 17th July 2013, commented below line of notification. To resolve Client's issue: clicking on the segment's comment because it did not replay the segment in the top player but played only one second of it.
           The problem was that, playAnnotation method of WatchViewController is called again and make the player pause.
         In [self setMainVideoData:annotation]; (see few lines above), playAnnotation method is already called to play the video.
         */
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAnnotationSegment" object:nil];
    } 
}

-(void) deleteAdditionalRows
{
    if(insertIndexPaths.count > 0)
    {
        countCell = 0;
        [_table deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        
        insertIndexPaths  = nil;
        [insertIndexPaths release];
        self.selectedRootAnnotation = nil;
        koef = 0;
        [_table reloadData];
    }
    
}
-(void)insertAdditionalRowsIntable:(int) row
{
   // self.selectedCellRow = row;
    koef = row; 
    self.isUpdatingChildAnnotations = TRUE;
    self.selectedRootAnnotation =[self.rootAnnotations objectAtIndex:row];
    [self.api listAnnotationByRoot:self.selectedRootAnnotation.pk];   
}

-(void) changeCellStyle:(BOOL)isSelected:(RootAnnotationCellView*)cell
{
    if(isSelected == TRUE)
    {
      //  UIImage * bgImage=[UIImage imageNamed:@"background_comment_active_"];
     //   cell.backImage.image = bgImage;
        UIColor * color = [UIColor colorWithRed:0/255.0 green:100.0/255.0 blue:174.0/255.0 alpha:1.0];
        cell.backImage.backgroundColor =[UIColor clearColor];
        cell.backImage.backgroundColor =color;
        
        //cell.content.textColor = [UIColor colorWithRed:159.0/255 green:230.0/255 blue:255.0/255 alpha:1.0];
        UIImage * imageExpandFree=[UIImage imageNamed:@"btn_hide_free_"];
        UIImage * imageExpandActive=[UIImage imageNamed:@"btn_hide_active_"];
        UIImage * imageViewArrow=[UIImage imageNamed:@"icon_hide-arrow_"];
        UIImage *  imageBreaker=[UIImage imageNamed:@"breaker_annotation_active_"];
        UIImage * imageAttachActive=[UIImage imageNamed:@"btn_attachments-annotation-expanded_active_"];
       
        [cell.btnAttachments setBackgroundImage:imageAttachActive forState:UIControlStateHighlighted];
        [cell.btnExpand setBackgroundImage:imageExpandFree forState:UIControlStateNormal];
        [cell.btnExpand setBackgroundImage:imageExpandActive forState:UIControlStateHighlighted];
        cell.imageBreaker.image = imageBreaker;
        cell.imageViewArrow.image =imageViewArrow;
        
        UIColor * colorScroll = [UIColor colorWithRed:14.0/255.0 green:44.0/255.0 blue:66.0/255.0 alpha:1.0];
        [cell._scrollView setBackgroundColor:colorScroll];
    }   
}
-(void)  reinitChildCells
{
    if(self.selectedCellRow != -1)//&& insertIndexPaths.count>0)
    {
        [self deleteAdditionalRows];
        [self insertAdditionalRowsIntable:self.selectedCellRow];
    }
}


-(void) initializeRootAnnotations
{
   
    for(Annotation * a in self.rootAnnotations)
    {
            /*
            if([a.content length]==0){
                [self.rootAnnotations removeObject:a];
            }
             */       
        
        a.isShowAttachments= FALSE;
        a.attachmnets = [[NSMutableArray alloc] init];
        if(a.imageAttachments.count>0)
        {
            [a.attachmnets addObjectsFromArray:a.imageAttachments];
        }
        
        if(a.videoAttachments.count>0)
        {
            [a.attachmnets addObjectsFromArray:a.videoAttachments];
        }
        
        float viewH = rootViewHeight;
        float k=20;
        float contentH=[self getHeight:a];
        if(contentH < self.rootContentHeight)
        {
            k=10;
            if(contentH == 0)
            {
                k=0;
            }
            contentH=rootContentHeight;
        }
        contentH +=k;
        viewH +=(contentH - self.rootContentHeight+k);
        a.viewHeight =viewH;
        a.contentHeight = contentH;
    } 
}

-(void) initializeChildAnnotations
{
    
    for(Annotation * a in self.annotations)
    {
        a.isShowAttachments = FALSE;
        a.attachmnets = [[NSMutableArray alloc] init];
        
        /*
        NSLog(@"a.title:%@",a.title);
        if([a.title length]==0|| [a.title isEqualToString:@""]||[a.title isEqualToString:@" "]|| a.title==nil){
            [self.annotations removeObject:a];
        }
         */
        

        if(a.imageAttachments.count>0)
        {
            [a.attachmnets addObjectsFromArray:a.imageAttachments];
        }
        
        if(a.videoAttachments.count>0)
        {
            [a.attachmnets addObjectsFromArray:a.videoAttachments];
        }
        a.parentAnnotation =[self getParentAnnotation:a];

        float viewH = childViewHeight;
        float k=20;
        float contentH =[self getHeight:a];
        if(contentH < self.childContentHeight)
        {
            if(contentH == 0)
            {
                k=12;
            }
            contentH=childContentHeight;
        }
        contentH +=k;
        viewH +=(contentH - childContentHeight+k);
        a.viewHeight =viewH;
        a.contentHeight = contentH;  
    }
    
}

-(Annotation *) getParentAnnotation:(Annotation*) childAnnotation {
    if (childAnnotation.parenId) {
        for(Annotation * a in self.rootAnnotations)
        {
            //Bhavya - commented if([a.pk isEqualToNumber:childAnnotation.parenId])
            if(a.pk.intValue == childAnnotation.parenId.intValue)
            {
                return a;
            }
        }
        //Bhavya - commented if([a.pk isEqualToNumber:childAnnotation.parenId])
        for(Annotation * a in self.annotations)
        {
            if(a.pk.intValue == childAnnotation.parenId.intValue)
            {
                return a;
            }
        }
    }
    return nil;
}


#pragma mark Table Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _table=tableView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return   self.rootAnnotations.count+countCell;
    
   
    
}

- (UITableViewCell *)tableView:(UITableView *) table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RootAnnotationCellView *cell;
    NSUInteger row = [indexPath row];
    
    if(selectedCellRow != -1)
    {
        for(NSIndexPath *ip in insertIndexPaths)
        {
            if(ip.row == row)
            {
                AnnotationCellView *childCell;
                
                childCell = (AnnotationCellView *)[table dequeueReusableCellWithIdentifier:@"AnnotationCellView"];
                if (childCell == nil) {
                    NSArray *chNib = [[NSBundle mainBundle] loadNibNamed:@"AnnotationCellView" owner:self options:nil];
                    childCell = (AnnotationCellView *)[chNib objectAtIndex:0];
                    childCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    childCell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                Annotation *annotation=[self.annotations objectAtIndex:row-koef-1];
                [childCell fill:self.selectedRootAnnotation :annotation.parentAnnotation :annotation :self.api.user.pk];
                
                //NSString *fullname = [NSString stringWithFormat:@"%@ %@",self.api.user.firstName,self.api.user.lastName];
               
                
                [childCell cellRezise:annotation.contentHeight :annotation.viewHeight :childBtnHeight];
                
                
                [self deleteCorners:childCell];
                
                if(indexPath.row  == insertIndexPaths.count + koef)
                {
                    [self makeCorners:childCell];
                }
                childCell.imageShadow.hidden = TRUE;
                if(ip.row == koef + 1)
                {
                    childCell.imageShadow.hidden = FALSE;
                }
                
                childCell.btnShare.tag=ip.row-1-selectedCellRow;
                [childCell.btnShare addTarget:self action:@selector(shareComment:) forControlEvents:UIControlEventTouchUpInside];
                childCell.navigationController = self.navigationController;
                
                childCell.btnAttachments.tag=ip.row-1-selectedCellRow;
                [childCell.btnAttachments addTarget:self action:@selector(showHideCommentAttachments:) forControlEvents:UIControlEventTouchUpInside];
                
                return childCell;
            }
        }
    }
    
    cell = (RootAnnotationCellView *)[table dequeueReusableCellWithIdentifier:@"RootAnnotationCellView"];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RootAnnotationCellView" owner:self options:nil];
		cell = (RootAnnotationCellView *)[nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backImage.layer.cornerRadius = 10;
        cell.backImage.layer.masksToBounds = YES;
	}
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceivedExpand:)];
    cell.btnExpand.userInteractionEnabled = YES;
    [cell.btnExpand addGestureRecognizer:tap];
    [tap release];
    
    
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceivedBackground:)];
    cell.backgroundView.userInteractionEnabled = YES;
    [cell.backgroundView addGestureRecognizer:tapB];
    [tapB release];
    
    //Bhavya - Added Tap Gesture to play video when the root annotation view is clicked.
    UITapGestureRecognizer *tapAnnotation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceivedExpand:)];
    cell.backImage.userInteractionEnabled = YES;
    [cell.backImage addGestureRecognizer:tapAnnotation];
    [tapAnnotation release];
 
    
    cell.navigationController = self.navigationController;
    
    if(row > selectedCellRow + (countCell-1) && selectedCellRow != -1)
    {
        row = row - countCell;
    }
    cell.tag = row;
    Annotation * rootAnn =[self.rootAnnotations objectAtIndex:row];
    NSString *start = [Util timeFormat:rootAnn.begin];
    NSString *end = [Util timeFormat:rootAnn.end];
    [cell fill:rootAnn :self.api.user.pk :[NSString stringWithFormat :@"%@ - %@", start, end]];
 
    [cell cellRezise:rootAnn.contentHeight :rootAnn.viewHeight :rootBtnHeight];    
    
    if(selectedCellRow != -1 && selectedCellRow == row)
    {
        [self changeCellStyle:TRUE :cell];
    }
    
    // Bhavya - 17th July 2013. Change in request: click more than once on segment, didnot change the background image to blue
    if(selectedCellRow==-1 && isTappedSameRow==TRUE && rowClicked==row)
    {
        isTappedSameRow = FALSE;
        [self changeCellStyle:TRUE :cell];
    }
    
    cell.btnShare.tag=row;
    [cell.btnShare addTarget:self action:@selector(shareRootAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnAttachments.tag=row;
    [cell.btnAttachments addTarget:self action:@selector(showHideRootAttachments:) forControlEvents:UIControlEventTouchUpInside];
    
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if(selectedCellRow != -1)
    {
        for(NSIndexPath *ip in insertIndexPaths)
        {
            if(ip.row == row)
            {
                Annotation * annotation =[self.annotations objectAtIndex: row-koef-1];
                int h=0;
                if(annotation.isShowAttachments == TRUE)
                {
                        h=230;
                    if(annotation.attachmnets.count<=3)
                    {
                        h=90;
                    }
                    if(annotation.attachmnets.count>3 && annotation.attachmnets.count <=6)
                    {
                        h=165;
                    }
                    
                }
                if(indexPath.row  == insertIndexPaths.count + koef)
                {
                    return annotation.viewHeight + 10 +h;
                }
               
                return annotation.viewHeight + h + 10; // annotation.viewHeight + h + 5;
                
            }
        }
    }
  

    if(row > selectedCellRow + (countCell-1) && selectedCellRow != -1)
    {
        row = row - countCell;
    }
   
    Annotation * rootAnn =[self.rootAnnotations objectAtIndex: row];
    if(rootAnn.isShowAttachments == TRUE)
    {
        int h=230;
        if(rootAnn.attachmnets.count<=3)
        {
            h=90;
        }
        if(rootAnn.attachmnets.count>3 && rootAnn.attachmnets.count <=6)
        {
            h=165;
        }
       return rootAnn.viewHeight + 10 + h;
    }
    return   rootAnn.viewHeight + 10;
    
}
#pragma mark - Additional functions
-(void) makeCorners:(AnnotationCellView*) childCell
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:childCell.backImage.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = childCell.backImage.bounds;
    maskLayer.path = maskPath.CGPath;
    childCell.backImage.layer.mask = maskLayer;
 
}

-(void) deleteCorners:(AnnotationCellView*) childCell
{
    childCell.backImage.layer.mask  = nil;
}


-(float)getHeight:(Annotation*)annotation
{
   NSString *theText = annotation.content;
    
    //Bhavya start - To adjust the height of the annotation content. Flash Api is returning html format. So height was calculated including html text. Now, I am calculating by removing html part.    
    theText = [theText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    theText = [theText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    theText = [theText stringByReplacingOccurrencesOfString:@"//" withString:@""];
    theText = [theText stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    theText = [theText stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    NSRange r;
    while ((r = [theText rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        theText = [theText stringByReplacingCharactersInRange:r withString:@""];
    // Bhavya end
    
   CGFloat width = 239;
   CGSize size = [theText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0] constrainedToSize:CGSizeMake(width,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
   
    return size.height;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) annotationsStateChanged:(NSNotification*) notification {
    // Bhavya 5th June 2013 - Added self.isUpdatingChildAnnotations = FALSE; to resolve the issue reported by client about duplicate comments displayed on adding/deleting a reply while that particular video is playing.
    self.isUpdatingChildAnnotations = FALSE;
    
    self.isUpdatingRootAnnotations = TRUE;
    
    //Bhavya - 8th may 2013
    //[self.api listAnnotation:self.container.selected.videoId];
    [self.api listAnnotation:self.container.selected.pk];
    self.isNextStepUpdatingChildAnnotations = TRUE;     
}



-(void) modifyTableRootAnnotations
{
    [self initializeRootAnnotations];
    if([self isExistSelectedAnnotation]== FALSE)
    {
        self.selectedRootAnnotation=nil;
        self.selectedCellRow = -1;
        if(insertIndexPaths.count>0)
        {
            countCell =0;
            koef =0;
            self.insertIndexPaths = nil;
            [insertIndexPaths release];
            self.annotations = nil;
            [annotations release];
        }
    }
    [_table reloadData];
    self.isUpdatingRootAnnotations = FALSE;
}

-(void) modifyTableChildAnnotations
{
    
    [self initializeChildAnnotations];
     self.selectedCellRow = koef;
    NSLog(@"annotation count is %d", self.annotations.count);
//  Bhavya - Server side have decreased one count as compare to old server. Ex - if rootannotation "x" have two children then flash server will return "total"=2 but cut2it server will return "total"=3 (means rootannotation + child annotations ie, 1+2=3) in response.
//    if(self.annotations.count > 0)
    if(self.annotations.count >= 0)
    {
        //Bhavya - commented countCell = self.annotations.count-1;// TODO after Timur
        countCell = self.annotations.count;
        
        NSMutableArray * arr= [[NSMutableArray alloc]init];
        int i=koef;
        while (i < countCell+koef) {
            int k=i+1;
            NSIndexPath * ip = [NSIndexPath indexPathForRow:k inSection:0];
            [arr addObject:ip];
            i++;
        }
        insertIndexPaths =[[NSArray alloc] initWithArray:arr];
        [arr release];
       
        if(insertIndexPaths.count > 0)
        {
            [_table insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.selectedCellRow inSection:0];
        [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
       
        [_table reloadData];
        self.isUpdatingChildAnnotations = FALSE;
    }
}

#pragma mark - Finish Requests

- (void) finish:(id) data {
    
    NSLog(@"FINISH");

    
    if(self.isUpdatingChildAnnotations == TRUE)
    {
        self.annotations = data;
        ///////
        if([temparrayNew count]>0){
            [temparrayNew removeAllObjects];
        }
        
        for (Annotation *annot in self.annotations) {
            NSLog(@"annotation_content:%@",annot.content);
            NSLog(@"annotation_Title:%@",annot.title);
            if(annot.content && [annot.content length]!=0){
                [self.temparrayNew addObject:annot];                
            }
        }
        
        if(temparrayNew && [temparrayNew count]>0){
            self.annotations = self.temparrayNew;
        }        
        
//        for (Annotation *a in self.annotations) {
//            NSLog(@"a.title:%@",a.content);
//        }
        [self modifyTableChildAnnotations];
    }
    else if(self.isUpdatingRootAnnotations == TRUE)
    {
        self.rootAnnotations = data;
        ////////
        if([temparray count]>0){
            [temparray removeAllObjects];
        }
        
        for (Annotation *annot in self.rootAnnotations) {
            NSLog(@"annotation_content:%@",annot.content);
            NSLog(@"annotation_Title:%@",annot.title);
            if(annot.content && [annot.content length]!=0){
                [self.temparray addObject:annot];
                
                
            }
        }
        
        if(temparray && [temparray count]>0){
            self.rootAnnotations = self.temparray;
        }
///////
        
        [self modifyTableRootAnnotations];
        
        if(self.isNextStepUpdatingChildAnnotations == TRUE)
        {
            [self reinitChildCells];
            self.isNextStepUpdatingChildAnnotations = FALSE;
        }
    }
}

-(void)rootAnnotationsDeleteChanged:(NSNotification*) notification {
    // Bhavya 5th June 2013 - Added self.isUpdatingChildAnnotations = FALSE; to resolve the issue reported by client about duplicate comments displayed on adding/deleting a reply while that particular video is playing.
    self.isUpdatingChildAnnotations = FALSE;
    
    self.isUpdatingRootAnnotations = TRUE;
    
    //Bhavya - 8th may 2013
    //[self.api listAnnotation:self.container.selected.videoId];
    [self.api listAnnotation:self.container.selected.pk];
}

-(void)playVideoNotification:(NSNotification*) notification {
 
   if(self.selectedCellRow != -1)
    {
     Annotation * annotation = [self.rootAnnotations objectAtIndex:self.selectedCellRow];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAnnotationSegment" object:annotation];
    }
    else
    {
      Annotation * annotation = notification.object;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAnnotationSegment" object:annotation];
    }
}


- (void)dealloc {
    [selectedRootAnnotation release];
    [annotations release];
    [rootAnnotations release];
    [super dealloc];
}
-(BOOL) isExistSelectedAnnotation
{
    for(Annotation * a in self.rootAnnotations)
    {
        if([a.pk intValue]== [self.selectedRootAnnotation.pk intValue])
        {
            return TRUE;
        }
        
    }
    return FALSE;
}

-(Annotation*) getAnnotation:(int)pk
{
    for(Annotation * a in self.annotations)
    {
        if([a.pk intValue]== pk)
        {
            return a;
        }
    }
    return nil;
}
#pragma mark - Share
-(void) initShareMenu
{    
    menu = [[UIView alloc] initWithFrame:CGRectMake(40, 45, 80, 45)];
    menu.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vm_menu_small"]];
    [self hideShareMenu];
    [_table addSubview:menu];
    [menu release];
    
    UIButton *video = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, 78,22)];
    video.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    video.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [video setTitle:@" Facebook" forState:UIControlStateNormal];
    [video setBackgroundImage:[UIImage imageNamed:@"vm_menu_top"] forState:UIControlStateHighlighted];
    [video addTarget:self action:@selector(shareFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:video];
    [video release];
    
    UIButton *segment = [[UIButton alloc] initWithFrame:CGRectMake(1, 23, 78, 22)];
    segment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    segment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [segment setTitle:@" Twitter" forState:UIControlStateNormal];
    [segment setBackgroundImage:[UIImage imageNamed:@"vm_menu_bottom"] forState:UIControlStateHighlighted];
    [segment addTarget:self action:@selector(shareTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:segment];
    [segment release];
}
-(void) showShareMenu:(CGPoint)position
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         menu.alpha = menu.alpha == 0 ? 1:0;
                     }
                     completion:^(BOOL finished){
                     }];
    
}
-(void) hideShareMenu
{
   self.menu.alpha =0;
}

/*
-(void) shareFacebook:(id)sender{
   
   
    NSString *token = [Util getProperties:FACEBOOK];
    if (!token) {  
        ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
        controller.navigationItem.title = @"Service";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    } else {
        [self shareWithType:FacebookType];
    }
    [self hideShareMenu];
}
 */
/*
 if (!FBSession.activeSession.isOpen ){
 ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
 controller.navigationItem.title = @"Service";
 [self.navigationController pushViewController:controller animated:YES];
 [controller release];
 
 } else {
 self.isPost = TRUE;
 [customDelegate logged:FacebookType];
 }
 }

 */

-(void) shareFacebook:(id)sender{
   
   
    NSString *token = [Util getProperties:FACEBOOK];
    if (!token) {
        ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
        controller.navigationItem.title = @"Service";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    } else {
        [self shareWithType:FacebookType];
    }
    [self hideShareMenu];
}



-(void) shareTwitter:(id)sender{
   
    NSString *key = [Util getProperties:TWITTER_KEY];
    NSString *secret = [Util getProperties:TWITTER_SECRET];
    if (!key && !secret) {
        
        ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
        controller.navigationItem.title = @"Service";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    } else {
        [self shareWithType:TwitterType];
    }
    [self hideShareMenu];
}
-(void)  shareRootAnnotation:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int row = senderButton.tag;
    Annotation * annotation = [self.rootAnnotations objectAtIndex:row];
    sharedAnnotation=annotation;
    sharedParentAnnotation=nil;
    sharedRootAnnotation=nil;
    
    if(menu.alpha == 1 && menu.tag != row)
    {
     [self hideShareMenu]; 
    }
    CGPoint localPoint = [senderButton bounds].origin;
    CGPoint basePoint = [senderButton convertPoint:localPoint toView:_table];
    menu.frame = CGRectMake(basePoint.x-50,basePoint.y +20,menu.frame.size.width,menu.frame.size.height);
    menu.tag=row;
    [self showShareMenu:basePoint];
}

-(void)  shareComment:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    int row = senderButton.tag ;
    Annotation * annotation = [self.annotations objectAtIndex:row];
    NSNumber * parentId=annotation.parenId;
    Annotation * parentAnnotation;
    if(parentId !=0)
    {
        parentAnnotation =[self  getAnnotation:[parentId intValue]];
    }
    sharedAnnotation=annotation;
    sharedParentAnnotation=self.selectedRootAnnotation;
    sharedRootAnnotation=parentAnnotation;
    
    if(menu.alpha == 1 && menu.tag != row)
    {
        [self hideShareMenu];
        
    }
    CGPoint localPoint = [senderButton bounds].origin;
    CGPoint basePoint = [senderButton convertPoint:localPoint toView:_table];
    menu.frame = CGRectMake(basePoint.x-50,basePoint.y +20,menu.frame.size.width,menu.frame.size.height);
    int t= row + 1+ self.selectedCellRow;
    menu.tag=t;
    [self showShareMenu:basePoint];
    
}
- (void) shareWithType:(LoginType) type
{

    entity = [[Annotation alloc] init];
    entity.videoId = self.container.selected.pk;
    entity.mediaId = self.container.selected.videoId;
    entity.begin = sharedAnnotation.begin;
    entity.end = sharedAnnotation.end;
    entity.annotationType = @"TEXT";
    entity.pk = sharedAnnotation.pk;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.pk = entity.pk;
    
    NSString  * content;
    content=@"";
    if(sharedRootAnnotation!=nil)
    {
        content =[NSString stringWithFormat:@"%@\r\n", sharedRootAnnotation.content];
    }
    if(sharedParentAnnotation!=nil)
    {
        content =[content stringByAppendingString:[NSString stringWithFormat:@"%@ \r\n", sharedParentAnnotation.content]];
    }
    content =[content stringByAppendingString:sharedAnnotation.content];
    entity.content=content;
    
    
    if (type == FacebookType) {
        self.isPost = TRUE;
        NSString *token = [Util getProperties:FACEBOOK];
       [self openSharingController];
       // [self.api shareFacebookAnnotation:token annotation:entity];
       
    } else if (type == TwitterType) {
        self.isPost = TRUE;
        NSString *key = [Util getProperties:TWITTER_KEY];
        NSString *secret = [Util getProperties:TWITTER_SECRET];
        [self openTwitterComposerView];
        //[self.api shareTwitterAnnotation:key secret:secret annotation:entity];
    }
    
}

- (void) sendtoTweeter:(NSString*)_comment{
    Annotation *annotation;
    NSString *key = [Util getProperties:TWITTER_KEY];
    NSString *secret = [Util getProperties:TWITTER_SECRET];
    annotation = [self.api shareTwitterAnnotation:key secret:secret annotation:entity comment:_comment];
}

/*
- (void) sendtoTweeter{
    

    Annotation *annotation;
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
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)openSharingController{
   NSLog(@"openSharingController_Share:");
   
   //    if(!FBSession.activeSession.isOpen){
   //        [self.api openSessionWithAllowLoginUI:YES];
   //    }   
   
   //AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
   FaceBookViewController* fbviewController = [[FaceBookViewController alloc]
                                               initWithNibName:@"FaceBookViewController"
                                               bundle:nil];
     fbviewController.fbComposeDelegate = self;
   // fbviewController.fbuserDict = self.fbuserDict;
   // fbviewController.postUrlString = [self.tempDict objectForKey:@"URL"];
   CGRect rect = fbviewController.view.frame;
   rect.origin.y = 44;
   rect.size.height= 200;
   rect.size.width = 300;
   
   fbviewController.view.frame = rect;
   //[appdelgate.window addSubview:fbviewController.view];
   [ self presentModalViewController:fbviewController animated:YES];
   [fbviewController release];
}

- (void) sendtoFacebook:(NSString*)fbComment
{    
    //  NSLog(@" __swelected _PK_, SELECTED  VIDEO  ID %@ %@",self.container.selected.pk,self.container.selected.videoId);
    //entity.videoId = self.container.selected.videoId;    
   
    Annotation *annotation;
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *key = [Util getProperties:FACEBOOK];
    
    // annotation = [self.api shareFacebookAnnotation:key annotation:entity];
    annotation= [self.api shareFacebookAnnotation:key annotation:entity comment:fbComment];      
}

-(void)fbComposeViewController:(FaceBookViewController *)controller didFinishWithResult:(FBComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) success:(BOOL) success
{
    if(success == TRUE &&  self.isPost == TRUE)
    {
        
        NSString * message=@"Post was performed successfully";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        
        self.isPost = FALSE;
    }
    if(success == FALSE)
    {
    }
}

@end
