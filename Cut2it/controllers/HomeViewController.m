 //
//  Cut2ItViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ConfigureServiceViewController.h"


#define IMAGE_WIDTH 90
#define IMAGE_HEIGHT 60
#define PADDING 10
#define IMAGES_IN_ROW 3


@interface HomeViewController ()
@end

@implementation HomeViewController

@synthesize list;
@synthesize _tableView;
@synthesize _scrollView;
@synthesize _isList;
@synthesize _selectedIndex;

@synthesize bGlobe;
@synthesize bStar;
@synthesize bThumbnails;
@synthesize bList;

@synthesize _isPopularListLoaded;
@synthesize _isStarredListLoaded;

@synthesize _offset;
@synthesize _limit;
@synthesize _offsetStarredVideo;
@synthesize _limitStarredVideo;
@synthesize tempTrendingList;
@synthesize tempStarredList;
@synthesize total;
@synthesize totalStarredVideo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    NSLog(@"viewDidLoad_Home");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_topbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title=@"";  
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    
    float x=-5;
    
    /* Bhavya Start - Removed the tiles (gridview of videos). The default will be the list only now. */
    
    bGlobe  = [self createBarButtonWithName:@"" width:80 backgroundSelected:@"background_topbar_pressed" image:@"navbar_btn_feed-long_free" imageSelected:@"navbar_btn_feed-long_active" xPosition:x target:self action:@selector(globe:)];
    [container addSubview:bGlobe];
    [bGlobe release];
    
    x+=80;
    bStar  = [self createBarButtonWithName:@""  width:80 backgroundSelected:@"background_topbar_pressed" image:@"navbar_btn_favorites-long_free" imageSelected:@"navbar_btn_favorites-long_active" xPosition: x target:self action:@selector(star:)];
    [container addSubview:bStar];
    [bStar release];
    
//    UIImageView *breaker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"breaker"]];
//    breaker.center = CGPointMake(205, 22);
//    [container addSubview:breaker];
//    [breaker release];
//    Search bar
//    x+=80;
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(x, 0, 160, 44)];
//    [container addSubview:searchBar];
//    [searchBar release];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
    
    // set the nav bar's right button item
    self.navigationItem.leftBarButtonItem = item;
    [container release];
    
    [self initSpinner];
        
    NSLog(@"count is %i", total);
    
    // Bhavya - Made _isList to TRUE to keep just the list view of videos
    _isList = TRUE;
    _selectedIndex = 0;
    _offset=0;
    _limit=30;
    _offsetStarredVideo=0;
    _limitStarredVideo=30;
    [bGlobe setSelected:TRUE];
    _tableView.hidden = FALSE;
    _scrollView.hidden = TRUE;
    _isPopularListLoaded=FALSE;
    _isStarredListLoaded=FALSE;
    
    self.api.delegate = self;
    self._tableView.delegate = self;
    
    tempTrendingList = [[NSMutableArray alloc] init];
    tempStarredList = [[NSMutableArray alloc] init];
      
    [self fillTable];
        
    _scrollView.customDelegate = self;
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    
    // Show message about non-availability of videos
    labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 100)];
    labelView.backgroundColor = [UIColor clearColor];    
    labelView.textColor = [UIColor whiteColor];
    [labelView setNumberOfLines:0];
    labelView.textAlignment = UITextAlignmentCenter;
    labelView.tag = 1;

}

- (void) viewWillAppear:(BOOL)animated {
    if (_homeDelegate) {
        [_homeDelegate refreshTabBar];
    }
    self.api.delegate = self;
    [super viewWillAppear:animated];
}

// called firsttime
-(void) fillTable
{    
    switch (_selectedIndex) {
        case 0:
            if([spinner isAnimating]==FALSE)
            {
                [spinner startAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
            total = [self.api totalPopularVideosWithDelegate:self :0 :0];
            if(total==0)
            {
                labelView.text = @"No Videos are available now. Trending videos will appear here.";
                [self.view addSubview:labelView];
            }
            if (list != nil && [list count] > 0){
                [list removeAllObjects];
            }
                       
            if(_isPopularListLoaded==FALSE)
            {
                _isPopularListLoaded=TRUE;
                if(total==0)
                {                   
                    if([spinner isAnimating]==TRUE)
                    {
                        [spinner stopAnimating];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }                    
                }
                else
                {
                    NSArray *viewsToRemove = [self.view subviews];
                    for (UIView *v in viewsToRemove) {
                        if(v.tag==1)
                        {
                            [v removeFromSuperview];
                        }            
                    }
                    if(total<30 && total >0)
                    {
                        _limit = total;
                        [self.api popularListWithDelegate:self :_offset :_limit];
                        [self setOffsetLimit:_offset+30 :_limit]; // For lazy loading/paging
                    }
                    else
                    {
                        [self.api popularListWithDelegate:self :_offset :_limit];
                        [self setOffsetLimit:_offset+30 :_limit]; // For lazy loading/paging
                    }
                }
            
            }
            else{
                if([spinner isAnimating]==TRUE)
                {
                    [spinner stopAnimating];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            }
            break;
        case 1:
            if([spinner isAnimating]==FALSE)
            {
                [spinner startAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
            totalStarredVideo = [self.api totalStarredWithDelegate:self :0 :0];
            if(totalStarredVideo==0)
            {
                // Show message about non-availability of videos
                labelView.text = @"No Videos are available now. Your favorite videos will appear here.";
                [self.view addSubview:labelView];
            }
            if (list != nil && [list count] > 0){
                [list removeAllObjects];
            }
           
            if(_isStarredListLoaded==FALSE)
            {
                _isStarredListLoaded=TRUE;
                if(totalStarredVideo==0)
                {                    
                    if([spinner isAnimating]==TRUE)
                    {
                        [spinner stopAnimating];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }                   
                }                
                else
                {
                    NSArray *viewsToRemove = [self.view subviews];
                    for (UIView *v in viewsToRemove) {
                        if(v.tag==1)
                        {
                            [v removeFromSuperview];
                        }
                    }
                    if(totalStarredVideo<30 && totalStarredVideo>0)
                    {
                        _limitStarredVideo = totalStarredVideo;
                        [self.api starredListWithDelegate:self :_offsetStarredVideo :_limitStarredVideo];
                        [self setOffsetLimitStarredVideo:_offset+30 :_limitStarredVideo]; // For lazy loading/paging
                    }
                    else
                    {
                        [self.api starredListWithDelegate:self :_offsetStarredVideo :_limitStarredVideo];
                        [self setOffsetLimitStarredVideo:_offset+30 :_limitStarredVideo]; // For lazy loading/paging
                    }
                }
                
            }
            else{
                if([spinner isAnimating]==TRUE)
                {
                    [spinner stopAnimating];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            }
            break;            
        default:
            break;
    }    
    
    if(_isList == TRUE)
    {
        [_tableView reloadData];
    }
    else {
        [self loadImages];
    }
}


- (UIButton *) createBarButtonWithName:(NSString *) name
                                 width:(CGFloat) width
                    backgroundSelected:(NSString *) backgroundSelected
                                 image:(NSString *) image
                         imageSelected:(NSString *) imageSelected
                             xPosition:(CGFloat)x
                                target:(id) target
                                action:(SEL) action {
	
	UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, 44)];
	
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", backgroundSelected]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", backgroundSelected]] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", image]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageSelected]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageSelected]] forState:UIControlStateSelected];
    
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    [button setTitle:name forState:UIControlStateSelected];
	button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    if ([image isEqualToString:@"back"]) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    }
//    else if([image isEqualToString:@"navbar_btn_feed-long_free"])
//    {
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(35, -50, 5, 10)];
//    }
//    else if([image isEqualToString:@"navbar_btn_favorites-long_free"])
//    {
//         [button setTitleEdgeInsets:UIEdgeInsetsMake(35, -50, 5, 10)];
//    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.layer.shadowOpacity = 1.0;
    button.titleLabel.layer.shadowRadius = 0.0;
	button.titleLabel.textColor=[UIColor whiteColor];
    
	return button;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    NSLog(@"didSelectRowAtIndexPath");
    NSUInteger row = [indexPath row];
    Media *video = [self.list objectAtIndex:row];
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:video];
    player.selTabIndex = [[NSNumber alloc]initWithInt:1];
    [[self.delegate navigationController] pushViewController:player animated:YES];
    [player release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Thumbnails
-(void)loadImages {
    int count = [self.list count];
    int rows = count/IMAGES_IN_ROW;
    if (count % IMAGES_IN_ROW != 0) {
        rows++;
    }
    
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    [_scrollView setContentSize:CGSizeMake(320, rows * (IMAGE_HEIGHT + PADDING) + 20)];
    
    for (int i=0; i<count; i++) {
        int row = i/IMAGES_IN_ROW;
        int column = i%IMAGES_IN_ROW;
        CGRect imageFrame;
        
        imageFrame = CGRectMake(column * (IMAGE_WIDTH + PADDING) + 15, row * (IMAGE_HEIGHT + PADDING)+15, IMAGE_WIDTH, IMAGE_HEIGHT);
        
        UIImageThumbnailView * image = [[UIImageThumbnailView alloc] init];
        image.frame = imageFrame;
        image.tag = i;
        image.backgroundColor = [UIColor darkGrayColor];
        
        Media *media =[self.list objectAtIndex:i];
        
        [image fill:media];
        image.layer.borderColor = [[UIColor whiteColor] CGColor];
        image.layer.borderWidth = 1;
        [_scrollView addSubview:image];
        [image release];
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
        player.selTabIndex = [[NSNumber alloc]initWithInt:1];
        [[self.delegate navigationController] pushViewController:player animated:YES];
        [player release];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)unselectAllButtons
{
    [bGlobe setSelected:FALSE];
    [bStar setSelected:FALSE];
    
}

-(void)globe:(id) sender
{
    //if(_selectedIndex==1)
    //{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if(v.tag==1)
        {
            [v removeFromSuperview];
        }
    }
        [self unselectAllButtons];
        UIButton *button = (id)sender;
        [button setSelected:YES];
        _selectedIndex =0;
        //_limit=0;
        [self performSelector:@selector(fillTable) withObject:nil afterDelay:0.01];
    //}
}

-(void)star:(id) sender
{
    //if(_selectedIndex==0)
    //{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if(v.tag==1)
        {
            [v removeFromSuperview];
        }
    }
        [self unselectAllButtons];
        UIButton *button = (id)sender;
        [button setSelected:YES];
        _selectedIndex=1;
        [self performSelector:@selector(fillTable) withObject:nil afterDelay:0.01];
    //}
}

//-(void)thumbnails:(id) sender
//{
//    _isList = FALSE;
//    [bList setSelected:FALSE];
//    UIButton *button = (id)sender;
//    [button setSelected:YES];
//    [self changeView:_isList];
//    
//}
//-(void)list:(id) sender
//{
//    _isList = TRUE;
//    [bThumbnails setSelected:FALSE];
//    UIButton *button = (id)sender;
//    [button setSelected:YES];
//    [self changeView:_isList];
//}
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
        [self finishTrending:data];
        [data release];               
    }
    else
    {
        [self finishTrending:data];
    }    
}

-(void)finishTrending:(id)data
{
    @try {
        if([spinner isAnimating]==TRUE)
        {
            [spinner stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        // After one async call finish, then only same second call will happen.
        if(_selectedIndex==0)
        {
            _isPopularListLoaded = FALSE;
            if([self.bGlobe isSelected])
            {
                self.list = [[NSMutableArray alloc]init];
                NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:(NSMutableArray *)data];
                [self.tempTrendingList addObjectsFromArray:temp];
                [self.list addObjectsFromArray:self.tempTrendingList];
                if(_isList == TRUE)
                {
                    if([self.bGlobe isSelected])
                    {
                        [_tableView reloadData];
                    }
                    
                    if(total>_offset)
                    {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        NSString *username = [Util getProperties:USERNAME];
                        NSString *password = [Util getProperties:PASSWORD];
                        NSString *token = [Util getProperties:FACEBOOK];
                        NSString *key = [Util getProperties:TWITTER_KEY];
                        NSString *secret = [Util getProperties:TWITTER_SECRET];
                        
                        // Call the api only if the user is login via uname, twitter or facebook
                        if (password || token || (key && secret))
                        {
                            [self.api popularListWithDelegate:self :_offset :_limit];
                            [self setOffsetLimit:_offset+30 :_limit];
                        }                        
                    }
                    else{
                        _limit=30;
                        _offset=0;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        if (self.tempTrendingList != nil && [self.tempTrendingList count] > 0){
                            while (self.tempTrendingList != nil && self.tempTrendingList.count != 0) {
                                [self.tempTrendingList removeObjectAtIndex:0];
                            }
                            //[self.tempTrendingList removeAllObjects];
                        }
                        
                    }
                }
                else {
                    [self loadImages];
                }            
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)finish:(id)data
{
    @try {
        if([spinner isAnimating]==TRUE)
        {
            [spinner stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        if(_selectedIndex==1)
        {
            self.list = [[NSMutableArray alloc]init];
            _isStarredListLoaded = FALSE;
            if([self.bStar isSelected])
            {
                NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:(NSMutableArray *)data];
                [self.tempStarredList addObjectsFromArray:temp];
                [self.list addObjectsFromArray:tempStarredList];
                if(_isList == TRUE)
                {
                    if([bStar isSelected])
                    {
                        [_tableView reloadData];
                    }
                    if(totalStarredVideo>_offsetStarredVideo)
                    {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        NSString *username = [Util getProperties:USERNAME];
                        NSString *password = [Util getProperties:PASSWORD];
                        NSString *token = [Util getProperties:FACEBOOK];
                        NSString *key = [Util getProperties:TWITTER_KEY];
                        NSString *secret = [Util getProperties:TWITTER_SECRET];
                        
                        if (password || token || (key && secret))
                        {
                            [self.api starredListWithDelegate:self :_offsetStarredVideo :_limitStarredVideo];
                            [self setOffsetLimitStarredVideo:_offsetStarredVideo+30 :_limitStarredVideo];
                        }                        
                    }
                    else{
                        _limitStarredVideo=30;
                        _offsetStarredVideo=0;
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        if (self.tempStarredList != nil && [self.tempStarredList count] > 0){
                            while (self.tempStarredList != nil && self.tempStarredList.count != 0) {
                                [self.tempStarredList removeObjectAtIndex:0];
                            }
                            //[tempStarredList removeAllObjects];
                        }
                    }
                }
                else {
                    [self loadImages];
                }
            }        
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)setOffsetLimit:(int)newOffset :(int)newlimit
{
    _offset=newOffset;
    _limit=newlimit;
}

-(void)setOffsetLimitStarredVideo:(int)newOffset :(int)newlimit
{
    _offsetStarredVideo=newOffset;
    _limitStarredVideo=newlimit;
}

- (void)dealloc {
    [list release];
    [super dealloc];
}
@end
