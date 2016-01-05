//
//  YouTubeViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeViewController.h"

@interface YouTubeViewController ()

@end

@implementation YouTubeViewController

@synthesize searchBar;
@synthesize tableView;
@synthesize list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    [searchBar release];
    [list release];
    [super dealloc];
}

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                     nil]];
    
    if(IPHONE_5)
    {
        CGRect size = CGRectMake(0, 427, 320, 50);
        [imgBottomShadow setFrame:size];
        
       
    }
    
    self.searchBar = [[CSearchView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
    [self.searchBar addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.searchBar];
    [self.searchBar release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_youtubeDelegate) {
        [_youtubeDelegate refreshTabBar];
    }

}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    
    
    NSString *search = [Util getProperties:SEARCH];
    if (search && !self.list) {
        [self.searchBar setValue:search];
        self.list = [self.api searchYouTube:search];
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table Data Source

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
    
    
    NSInteger row = [indexPath row];
    [cell fill:[self.list objectAtIndex:row]];
	
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    Media *video = [self.list objectAtIndex:row];
    
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithMedia:video];
    //Bhavya -  2 is selected tab index passed
    player.selTabIndex = [NSNumber numberWithInt:2];
    [[self.delegate navigationController] pushViewController:player animated:YES];
    [player release];
    
    /*  NSArray * annotations = [self.api listAnnotation:video.videoId];
     
     Annotation * selectedAnnotation= [annotations objectAtIndex:0];
     DiscussionViewController *controller = [[DiscussionViewController alloc] init];
     controller.selectedRootAnnotation = selectedAnnotation;
     controller.rootAnnotations= annotations;
     // controller.annotationsDelegate = (id)self;
     
     NSMutableArray *alist = [self.api listAnnotationByRoot:selectedAnnotation.pk];
     controller.annotations = alist;
     [alist release];
     [annotations release];
     [self.navigationController pushViewController:controller animated:YES];
     [controller release];*/
}

#pragma mark -
#pragma mark UISearchDelegate Delegate Methods


- (void) search:(CSearchView *) search {
    [searchBar resignFirstResponder]; //Bhavya - to hide keyboard on click of search key
    if (![search.text isEqualToString:@""]) {
        [Util setProperties:SEARCH value:search.text];
        
        self.list = [self.api searchYouTube:search.text];
        
        if (self.list) {
            [self.list release];
            [self.tableView reloadData];
            
            if (self.list.count)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }        
    }
}


@end
