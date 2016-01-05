//
//  VideoViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoViewController.h"


#define IMAGE_WIDTH 90
#define IMAGE_HEIGHT 60
#define PADDING 10
#define IMAGES_IN_ROW 3

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize list;
@synthesize tempList;
@synthesize _tableView;
@synthesize _scrollView;
@synthesize bList;
@synthesize bThumbnails;
@synthesize _isList;
@synthesize _offset;
@synthesize _limit;
@synthesize total;
@synthesize _limitTemp;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewDidLoad {
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_topbar"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.title=@"";
//    /* [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
//     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//     [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
//     [UIColor whiteColor], UITextAttributeTextColor,
//     [UIColor blackColor], UITextAttributeTextShadowColor,
//     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
//     nil]];*/
//    [super viewDidLoad];
//
//    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
//
//    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
//
//    bThumbnails  = [self createBarButtonWithName:@"" backgroundSelected:@"background_topbar_pressed" image:@"btn_thumbnails_free" imageSelected:@"btn_thumbnails_active" xPosition:-5 target:self action:@selector(thumbnails:)];
//    [container addSubview:bThumbnails];
//    [bThumbnails release];
//
//
//    bList  = [self createBarButtonWithName:@"" backgroundSelected:@"background_topbar_pressed" image:@"btn_list_free" imageSelected:@"btn_list_active" xPosition:155 target:self action:@selector(list:)];
//    [container addSubview:bList];
//    [bList release];
//
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
//
//    // set the nav bar's right button item
//    self.navigationItem.leftBarButtonItem = item;
//    [container release];
//
//    _isList = TRUE;
//    [self fillTable];
//    [bList setSelected:TRUE];
//    [self changeView:TRUE];
//    [self initScrollView];
//
//    // Do any additional setup after loading the view from its nib.
//}

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_topbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title=@"";
    [super viewDidLoad];
    /* [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
     [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
     [UIColor whiteColor], UITextAttributeTextColor,
     [UIColor blackColor], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
     nil]];*/    
    
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    self.navigationItem.title = @"Library";
    
    _isList = TRUE;
    _limit=30;
    _offset=0;
     _limitTemp=0;
    self.api.delegate = self;
    [self initSpinner];
    
    tempList = [[NSMutableArray alloc] init];  
    
    [bList setSelected:TRUE];
    //[self changeView:TRUE];
    [self initScrollView];        
}


-(void) viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{ 
    total = [self.api totalvideoListByUserWithDelegate:self :0 :0];
    [self fillTable];
    [super viewDidAppear:animated];
}

- (void)viewDidUnloadntrcn
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) fillTable
{
    if([spinner isAnimating]==FALSE)
    {
        [spinner startAnimating];
    }
    // If new video added, total changes
    int totalTemp = [self.api totalvideoListByUserWithDelegate:self :0 :0];
    
    if(totalTemp!=total)
    {
        total = totalTemp;
    }
    if (list != nil && [list count] > 0){
        [list removeAllObjects];
    }   
    
    // Cancel the old request
    if(total>0)
    {
        NSArray *viewsToRemove = [self.view subviews];
        for (UIView *v in viewsToRemove) {
            if(v.tag==1)
            {
                [v removeFromSuperview];
            }            
        }
        if(_limitTemp==0)
        {
            if(total<30 && total>0)
            {
                _limit=total;
                [self.api videoListByUserWithDelegate:self :_offset :_limit];
                [self setOffsetLimit:_offset+30 :_limit]; // For lazy loading/paging
            }
            else
            {                
                [self.api videoListByUserWithDelegate:self :_offset :_limit];
                [self setOffsetLimit:_offset+30 :_limit]; // For lazy loading/paging
            }
        }
    }
    else{
        
        if([spinner isAnimating]==TRUE)
        {
            [spinner stopAnimating];
        }
        // Show message about non-availability of videos
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 100)];
        labelView.backgroundColor = [UIColor clearColor];
        labelView.text = @"No Videos are available now. Your uploaded videos will appear here.";
        labelView.textColor = [UIColor whiteColor];
        [labelView setNumberOfLines:0];
        labelView.textAlignment = UITextAlignmentCenter;
        labelView.tag = 1;
        [self.view addSubview:labelView];
        [labelView release];
    }
    
    if(_isList == TRUE)
    {
        [_tableView reloadData];
    }
    else {
        [self loadImages];
    }    
}

-(void) changeView:(BOOL) isList
{
    if(isList == TRUE)
    {
        _tableView.hidden = FALSE;
        _scrollView.hidden = TRUE;
        [self performSelector:@selector(fillTable) withObject:nil afterDelay:0.1];
        
    }
    else {
        _tableView.hidden = TRUE;
        _scrollView.hidden = FALSE;
        [self performSelector:@selector(loadImages) withObject:nil afterDelay:0.1];
        
    }
}

-(void)thumbnails:(id) sender
{
    
    _isList = FALSE;
    [bList setSelected:FALSE];
    UIButton *button = (id)sender;
    [button setSelected:YES];
    [self changeView:_isList];
    
}
-(void)list:(id) sender
{
    _isList = TRUE;
    [bThumbnails setSelected:FALSE];
    UIButton *button = (id)sender;
    [button setSelected:YES];
    [self changeView:_isList];
}


#pragma mark - UIViewScroll

-(void) initScrollView
{
    _scrollView.customDelegate = self;
    
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    
    int count = [self.list count];
    int rows = count/IMAGES_IN_ROW;
    if (count % IMAGES_IN_ROW != 0) {
        rows++;
    }
    
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    [_scrollView setContentSize:CGSizeMake(320, (rows * (IMAGE_HEIGHT + PADDING)) + 20)];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _tableView=tableView;
    return 1;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
     return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *) table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YouTubeView *cell = (YouTubeView *)[table dequeueReusableCellWithIdentifier:@"YouTubeCell"];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YouTubeCellView" owner:self options:nil];
		cell = (YouTubeView *)[nib objectAtIndex:0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    
    NSUInteger row = [indexPath row];
    [cell fill:[self.list objectAtIndex:row]];
	
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    Media *video = [self.list objectAtIndex:row];
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:video];
    // set selTabIndex as 4th Tab as it is for user uploaded video ie Library tab
    player.selTabIndex = [[NSNumber alloc]initWithInt:4];
    [[self.delegate navigationController] pushViewController:player animated:YES];
    [player release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Thumbnails
-(void)loadImages{
    
    NSMutableArray * files = [self.list mutableCopy];
    int count = 0;
    for (int i=0; i<[files count]; i++) {
        int row = count/IMAGES_IN_ROW;
        int column = count%IMAGES_IN_ROW;
        CGRect imageFrame;
        
        
        imageFrame = CGRectMake(column * (IMAGE_WIDTH + PADDING) + 15, row * (IMAGE_HEIGHT + PADDING)+15, IMAGE_WIDTH, IMAGE_HEIGHT);
        
        UIImageThumbnailView * image = [[UIImageThumbnailView alloc] init];
        image.frame = imageFrame;
        image.tag = count;
        image.backgroundColor = [UIColor darkGrayColor];
        
        
        Media *media =[self.list objectAtIndex:i];
        
        [image fill:media];
        image.layer.borderColor = [[UIColor whiteColor] CGColor];
        image.layer.borderWidth = 1;
        [_scrollView addSubview:image];
        [image release];
        count ++;
    }
}


-(void)scrollTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}
-(void)scrollTouchesEnd:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint fromPosition = [[[touches allObjects] objectAtIndex:0] locationInView:_scrollView];
    
    int row,column;
    
    row = (int)(fromPosition.y / (IMAGE_HEIGHT + PADDING));
    column = (int)(fromPosition.x / (IMAGE_WIDTH + PADDING));
    int index = row * 3 + column;
    
    if (index < [self.list count]) {
        Media *video = [self.list objectAtIndex:index];
        
        PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:video];
        player.selTabIndex = [[NSNumber alloc]initWithInt:4];
        [[self.delegate navigationController] pushViewController:player animated:YES];
        [player release];
    }
}
#pragma mark - Navigator Bar
- (UIButton *) createBarButtonWithName:(NSString *) name
                    backgroundSelected:(NSString *) backgroundSelected
                                 image:(NSString *) image
                         imageSelected:(NSString *) imageSelected
                             xPosition:(CGFloat)x
                                target:(id) target
                                action:(SEL) action {
	
	UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(x, 0, 160, 44)];
	
    [button setTitle:name forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    if ([image isEqualToString:@"back"]) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    }
    
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", backgroundSelected]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", backgroundSelected]] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", image]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageSelected]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageSelected]] forState:UIControlStateSelected];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.layer.shadowOpacity = 1.0;
    button.titleLabel.layer.shadowRadius = 0.0;
	
    
	return button;
}

-(void)initSpinner
{
    spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    spinner.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
    spinner.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin);
    [spinner setBackgroundColor:[UIColor clearColor]];
    //spinner.center = self.view.center;
    [self.view addSubview:spinner];
}

-(void)setOffsetLimit:(int)newOffset :(int)newlimit
{
    _offset=newOffset;
    _limit=newlimit;
    
}


#pragma API delegate methods
- (void) requestFinished:(ASIHTTPRequest *) request {        
    id data;
    if (request.single) {
        
        {
            data = [self.api data:request bean:request.responseClass];
        }
    } else {
        
        {
            data = [self.api dataList:request bean:request.responseClass];
            
        }
    }
      
    if (data) {
        [self finish:data];
        [data release];
    }
    else{
        if([spinner isAnimating]==TRUE)
        {
            [spinner stopAnimating];
        }
    }
}

-(void)finish:(id)data
{
    //self.list=(NSMutableArray *)data;
    
    if([spinner isAnimating]==TRUE)
    {
        [spinner stopAnimating];
    }
    if(_isList == TRUE)
    {
        self.list = [[NSMutableArray alloc]init];
        NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:(NSMutableArray *)data];
        [self.tempList addObjectsFromArray:temp];
        [self.list addObjectsFromArray:tempList];
        //self.list = self.tempList;
        [_tableView reloadData];
        
        if(total>_offset)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString *username = [Util getProperties:USERNAME];
            NSString *password = [Util getProperties:PASSWORD];
            NSString *token = [Util getProperties:FACEBOOK];
            NSString *key = [Util getProperties:TWITTER_KEY];
            NSString *secret = [Util getProperties:TWITTER_SECRET];
            
            // Call the api only if the user is login via uname, twitter or facebook
            if (password || token || (key && secret))
            {
                [self.api videoListByUserWithDelegate:self :_offset :_limit];
                [self setOffsetLimit:_offset+30 :_limit];
            }            
            _limitTemp=1;
        }
        else{
            while (self.tempList != nil && self.tempList.count != 0) {
                [self.tempList removeObjectAtIndex:0];
            }
            _limitTemp=0;
            _limit=30;
            _offset=0;
        }        
    }
    else {
        [self loadImages];
    }    
}

- (void)dealloc {
    [list release];
    [super dealloc];
}

@end
