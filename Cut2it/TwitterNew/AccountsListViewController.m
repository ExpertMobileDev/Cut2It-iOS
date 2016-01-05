//
//  AccountsListViewController.m
//  TwitterClient
//
//  Created by Peter Friese on 19.09.11.
//  Copyright (c) 2011, 2012 Peter Friese. All rights reserved.
//

#import "AccountsListViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "TweetComposeViewController.h"
#import "AppDelegate.h"

#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import "LoadingView.h"

@interface AccountsListViewController ()
- (void)fetchData;
@property (strong, nonatomic) NSCache *usernameCache;
@property (strong, nonatomic) NSCache *imageCache;
@property (nonatomic, strong) TWAPIManager *apiManager;
@end

@implementation AccountsListViewController


@synthesize accounts = _accounts;
@synthesize accountStore = _accountStore;

@synthesize imageCache = _imageCache;
@synthesize usernameCache = _usernameCache;
@synthesize account = _account;
@synthesize checkedIndexPath;
@synthesize api;
@synthesize loadingView;


#pragma mark ReverseOuth

#pragma mark Loading Screen
- (void) hideLoadingView {
    [self dismissModalViewControllerAnimated:YES];
    [loadingView.spinner stopAnimating];
    //[loadingView.view setHidden:YES];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

- (void) showLoadingView {
	NSLog(@"showLoadingView");
     [self presentModalViewController:loadingView animated:YES];
    
    //[loadingView.view setHidden:NO];
    [loadingView.spinner startAnimating];
    [self.view bringSubviewToFront:loadingView.view];
}


-(void)logged:(LoginType)type{
    if(type == TwitterType){
    [self hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark initialize

- (id)initWithStyle:(UITableViewStyle)style
{
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self = [super initWithStyle:style];
    self.title = @"Accounts";
    twitterParamarray = [[NSMutableArray alloc] init];
    self.api = [Cut2itApi shared];
     self.api.delegate = self;
    loadingView = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
    //[self.view addSubview:loadingView.view];
   // [loadingView.view setHidden:YES];
    
    
    if (self) {
        if (_refreshHeaderView == nil) {
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:
                                               CGRectMake(0.0f,
                                                          0.0f - self.tableView.bounds.size.height,
                                                          self.tableView.frame.size.width,
                                                          self.tableView.bounds.size.height)];
            view.delegate = self;
            [self.tableView addSubview:view];
            _refreshHeaderView = view;
            _refreshHeaderView.delegate = self;
        }
        _apiManager = [[TWAPIManager alloc] init];
        
        //AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        
            UIBarButtonItem *back = [self create1BarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
            self.navigationItem.leftBarButtonItem = back;
            [back release];
            
        
                
        UIBarButtonItem *save = [self create1BarButtonWithName:@"Save" image:@"rounded" width:68 target:self action:@selector(done:)];

        self.navigationItem.rightBarButtonItem = save;
        [save release];

        _imageCache = [[NSCache alloc] init];
        [_imageCache setName:@"TWImageCache"];
        _usernameCache = [[NSCache alloc] init];
        [_usernameCache setName:@"TWUsernameCache"];
        [self fetchData];
    }
    return self;
}

-(void)dealloc{
    [api release];
    [loadingView release];
    [super dealloc];
}

- (IBAction) back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)done:(id)sender{
    NSLog(@"done_Account");
    
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(!self.checkedIndexPath){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select account to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(appDelegate.account){        
        //[self showLoadingView];
        [_apiManager
         performReverseAuthForAccount:appDelegate.account
         withHandler:^(NSData *responseData, NSError *error) {
             if (responseData) {
                 NSString *responseStr = [[NSString alloc]
                                          initWithData:responseData
                                          encoding:NSUTF8StringEncoding];
                 
                 NSArray *parts = [responseStr
                                   componentsSeparatedByString:@"&"];
                 
                 for(int i=0;i<[parts count];i++){
    
                     NSArray *array = [[parts objectAtIndex:i] componentsSeparatedByString:@"="];
                     [twitterParamarray addObject:[array objectAtIndex:1]];
                     
                 }
                 NSLog(@"twitterParamarray:%@",twitterParamarray);
                 if(twitterParamarray && [twitterParamarray count]>=3){
                     
                     NSString *twitterAuthToken = [twitterParamarray objectAtIndex:0];
                     NSString *twitterTokenSecret = [twitterParamarray objectAtIndex:1];
                    
                     [self.api twitterAuthorizationCompletenew:twitterAuthToken consumer:twitterTokenSecret];                     
                 }
                 
                 NSString *lined = [parts componentsJoinedByString:@"\n"];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                    
                 });
                 [self hideLoadingView];
             }
             else {
                 NSLog(@"Error!\n%@", [error localizedDescription]);
                 //[self hideLoadingView];
             }
         }];    
    }
}

- (UIBarButtonItem *) create1BarButtonWithName:(NSString *) name
                                        image:(NSString *) image
										width:(CGFloat) width
									   target:(id) target
									   action:(SEL) action {
	
	UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 32)];
	
	[button setTitle:name forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    if ([image isEqualToString:@"back"]) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    }
    
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_%@_f", image]] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_%@_f", image]] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.layer.shadowOpacity = 1.0;
    button.titleLabel.layer.shadowRadius = 0.0;
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button release];
	
	return item;
}

- (void)didReceiveMemoryWarning
{
    [_imageCache removeAllObjects];
    [_usernameCache removeAllObjects];
    [super didReceiveMemoryWarning];
}

#pragma mark - Data handling

- (void)fetchData
{
    
    if ([TWAPIManager isLocalTwitterAccountAvailable])
    {
        [_refreshHeaderView refreshLastUpdatedDate];
        
        if (_accountStore == nil) {
            self.accountStore = [[ACAccountStore alloc] init];
            if (_accounts == nil) {
                ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                    if(granted) {
                        self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                    
                    
                    
                }];
            }
        }

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Twitter Accounts"
                              message:@"Please Configure Twitter account in Settings in your device."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

    }

    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
    /*
    if([self.accounts count]==0){
        NSURL *twitterURL = [NSURL URLWithString:@"prefs:root=TWITTER"];
        [[UIApplication sharedApplication] openURL:twitterURL];
    }*/
    
  
    
    [self performSelector:@selector(doneLoadingTableViewData)
               withObject:nil afterDelay:1.0]; 
    /// Need a delay here otherwise it gets called to early and never finishes.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    ACAccount *account = [self.accounts objectAtIndex:[indexPath row]];
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.accountDescription;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *username = [_usernameCache objectForKey:account.username];
    if (username) {
        cell.textLabel.text = username;
    }
    else {
        TWRequest *fetchAdvancedUserProperties = [[TWRequest alloc]
                                                  initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"]
                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil]
                                                  requestMethod:TWRequestMethodGET];
        [fetchAdvancedUserProperties performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                NSError *error;
                id userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                if (userInfo != nil) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [_usernameCache setObject:[userInfo valueForKey:@"name"] forKey:account.username];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                    });
                }
            }
        }];
    }

    UIImage *image = [_imageCache objectForKey:account.username];
    if (image) {
        cell.imageView.image = image;
    }
    else {
        TWRequest *fetchUserImageRequest = [[TWRequest alloc]
                                            initWithURL:[NSURL URLWithString:
                                                         [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/profile_image/%@",
                                                          account.username]]
                                            parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"bigger", @"size", nil]
                                            requestMethod:TWRequestMethodGET];
        [fetchUserImageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ([urlResponse statusCode] == 200) {
                UIImage *image = [UIImage imageWithData:responseData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_imageCache setObject:image forKey:account.username];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                });
            }
        }];
    }
    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // Uncheck the previous checked row
        if(self.checkedIndexPath)
        {
            UITableViewCell* uncheckCell = [tableView
                                            cellForRowAtIndexPath:self.checkedIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
       
    
    AppDelegate *appDelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelgate.account = [self.accounts objectAtIndex:[indexPath row]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appDelgate.account];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    Method to retrieve the appDelgate.account 
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data_ = [defaults objectForKey:@"account"];
//    appDelgate.account = [NSKeyedUnarchiver unarchiveObjectWithData:data_];
}

- (void)tweetComposeViewController:(TweetComposeViewController *)controller didFinishWithResult:(TweetComposeResult)result {
    [self dismissModalViewControllerAnimated:YES];
    [self fetchData];
}

#pragma mark - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    // We want fresh data (added new account since launch)
    _accountStore = nil;
    _accounts = nil;
  
    _reloading = YES;
    [self fetchData];
}

- (void)doneLoadingTableViewData
{
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

@end
