//
//  ConfigureServiceViewController.m
//  cut2it
//
//  Created by Mac on 10/19/12.
//
//

#import "ConfigureServiceViewController.h"
#import "AppDelegate.h"
#import "AccountsListViewController.h"
#import "AppDelegate.h"
#import "TWViewController.h"
//#import "Server.h"
//#import "Constant.h"

@interface ConfigureServiceViewController ()

@end

@implementation ConfigureServiceViewController
@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       //UIBarButtonItem *cancel = [self createBarButtonWithName:@"back" image:@"rounded" width:68 target:self action:@selector(back:)];
        UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
        
       self.navigationItem.leftBarButtonItem = back;
        [back release];
//        UIBarButtonItem *cancel = [self createBarButtonWithName:@"Cancel" image:@"rounded" width:68 target:self action:@selector(backCheck)];
//        self.navigationItem.leftBarButtonItem = cancel;

        
    }
    return self;
}

-(void)backCheck{
    NSLog(@"backCheck");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(customNotification:)
//     name:@"coustomNotif"
//     object:nil];
    
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                     nil]];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _tableView=tableView;
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 320,25)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    headerLabel.backgroundColor= [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    
    NSString * title =@"Configure";
    headerLabel.text = title;
    
    [hView addSubview:headerLabel];
    [headerLabel release];
    return hView;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *) table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"] autorelease];
        cell.textLabel.textColor= [UIColor colorWithWhite:0.6 alpha:1];
        if(indexPath.row == 0 && indexPath.section == 1)
        {
            // label.highlightedTextColor = [UIColor whiteColor];
        }
        else
        {
            cell.textLabel.highlightedTextColor= [UIColor colorWithWhite:0.6 alpha:1];
        }
        
        cell.textLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.detailTextLabel.font =[UIFont fontWithName:@"Helvetica" size:10];
        cell.accessoryType = TRUE;
        cell.clipsToBounds=TRUE;
    }
    
    
    
    [self fillCellTextImage:cell :indexPath];
    [self fillCellStatus:cell :indexPath];
    [self fillAccessoryType:cell :indexPath];
    [self fillCellBackground:cell :indexPath];
    
    return cell;
}


#pragma mark - Fill Cells

-(void) fillCellTextImage:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    NSString * title = @"";
    UIImage * image = [UIImage imageNamed:@"fb_logo"];

    
    switch (indexPath.row) {
        case 0:
            title =@"Facebook";
            break;
            
        case 1:
            title =@"Twitter";
            image= [UIImage imageNamed:@"twitter_logo"];
            break;
            
    }
    cell.textLabel.text = title;
    cell.imageView.image = image;
}

-(void) fillCellStatus:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    NSString * status = @"";
    NSString *tokenFB = [Util getProperties:FACEBOOK];
    NSString *userFB  = [Util getProperties:FACEBOOK_USERNAME];
    
    NSString *usernameTW = [Util getProperties:TWITTER_USERNAME];
       
    switch (indexPath.row) {
        case 0:
            status =(tokenFB && FBSession.activeSession.isOpen)?userFB : @"Connect your account";
            /*
          if(!FBSession.activeSession.isOpen){
             status=@"Connect your account";
          }
          else if (FBSession.activeSession.isOpen)
              {
             status = userFB;
              }
             */
            
            break;
            
        case 1:
            if(!usernameTW){
                status = @"Connect your account";
                
            }
            else{
               status = usernameTW;
            }
            
            break;
            
    }
    cell.detailTextLabel.text = status;
    
}
-(void) fillAccessoryType:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    
    UIImage *connectImage = [UIImage   imageNamed:@"btn_connect_free"] ;
    UIImage *connectImageSelected = [UIImage   imageNamed:@"btn_connect_active"];
    
    UIImage *disconnectImage = [UIImage   imageNamed:@"btn_disconnect_free"] ;
    UIImage *disconnectImageSelected = [UIImage   imageNamed:@"btn_disconnect_active"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //CGRect frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
    CGRect frame = CGRectMake(0.0, 0.0,90, 30);
    button.frame = frame;
    [button setBackgroundImage:[cell.detailTextLabel.text isEqualToString:@"Connect your account"]?connectImage:disconnectImage forState:UIControlStateNormal];
    [button setBackgroundImage:[cell.detailTextLabel.text isEqualToString:@"Connect your account"]?connectImageSelected:disconnectImageSelected forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor clearColor];
    button.tag=indexPath.row;
    [button addTarget:self action:@selector(connectDisconnect:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
}

-(void) fillCellBackground:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    UIImage *rowBackground;
    UIImage *selectionBackground;
    
    if(indexPath.row == 0)
    {
        rowBackground = [UIImage imageNamed:@"table_cell-top_free"];
        selectionBackground = [UIImage imageNamed:@"table_cell-top_active"];
    }
    if(indexPath.row == 1)
    {
        rowBackground = [UIImage imageNamed:@"table_cell-bottom_free"];
        selectionBackground = [UIImage imageNamed:@"table_cell-bottom_active"];
    }
    
    cell.backgroundView =[[[UIImageView alloc] init] autorelease];
    
    cell.selectedBackgroundView =   [[[UIImageView alloc] init] autorelease];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
}

#pragma mark - Connect / Disconnect


-(void) connectDisconnect:(id)sender
{
    
    NSString *tokenFB  = [Util getProperties:FACEBOOK];
    
    NSString *keyTW = [Util getProperties:TWITTER_KEY];
    NSString *secretTW = [Util getProperties:TWITTER_SECRET];
    NSString *twitternameUser = [Util getProperties:TWITTER_USERNAME];
    NSString *twitterUser = [Util getProperties:TWITTER_USER];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIButton *button =(UIButton *)sender;
    if(button.tag == 0)
    {        
        if(tokenFB && FBSession.activeSession.isOpen)
        {
            [Util removeProperties:FACEBOOK_USERNAME];
            [Util removeProperties:FACEBOOK];
        }
        else
        {
            //[self.api facebookLogin];
//            [FBSession openActiveSessionWithAllowLoginUI:YES];
            [self.api openSessionWithAllowLoginUI:YES];
        }
        [_tableView reloadData];
    }
       
    if(button.tag == 1)
    {
        if(!twitternameUser){
            [self openTwitterAccountController];
        }
        else{
           
            appDelegate.account = nil;            
            [Util removeProperties:TWITTER_USERNAME];
            ////////////////////////////////////////// Bhavya Twitter following and friends
            [Util removeProperties:TWITTER_KEY];
            [Util removeProperties:TWITTER_SECRET];
            [Util removeProperties:TWITTER_USER];
            //////////////////////////////////////////
            [_tableView reloadData];
        }
          
        
    }
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        
        if(button.tag == 0 && tokenFB)
        {
            if([[cookie domain] rangeOfString:@"facebook"].location != NSNotFound) {
                [storage deleteCookie:cookie];
            }
        }
         
        
        if(button.tag == 1 && keyTW && secretTW)
        {
            if([[cookie domain] rangeOfString:@"twitter"].location != NSNotFound) {
                [storage deleteCookie:cookie];
            }
        }
    }
    
    
    
    /*
   // AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!self.api.hasCloseSession) {
        [self.api closeSession];
        [self.api openSessionWithAllowLoginUI:YES];
        self.api.hasCloseSession = YES;
    }else{
        // [self addLoadingScreen];
        //[self openSharingController];
        //[self removeLoadingScreen];
    }
*/
    
}
-(void)openTwitterAccountController{
    NSLog(@"openTwitterAccountController");
    
    AccountsListViewController *accountsListViewController = [[AccountsListViewController alloc] init];
    //[ self presentModalViewController:accountsListViewController animated:YES];
    [self.navigationController pushViewController:accountsListViewController animated:YES];
    [accountsListViewController release];
     /*
    TWViewController *twViewCont =[[TWViewController alloc]
     initWithNibName:@"TWViewController" bundle:nil];
    [self.navigationController pushViewController:twViewCont animated:YES];
    [twViewCont release];
      */


}

-(void)openSharingController{
    NSLog(@"openSharingController:");
       
       // AppDelegate *appdelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
              
        fbviewController = [[FaceBookViewController alloc]
                          initWithNibName:@"FaceBookViewController"
                          bundle:nil];
        fbviewController.fbuserDict = self.fbuserDict;
        fbviewController.postUrlString = [self.tempDict objectForKey:@"URL"];
        CGRect rect = fbviewController.view.frame;
        rect.origin.y = 44;
        rect.size.height= 200;
        rect.size.width = 300;
   
        fbviewController.view.frame = rect;
    //[appdelgate.window addSubview:fbviewController.view];
    [ self presentModalViewController:fbviewController animated:YES];
    [fbviewController release];    
    
    //    [self presentViewController:viewController animated:YES completion:nil];
    //    [viewController release];
}



/*
 https:/graph.facebook.com/107567112600135/picture?type=large
 
 * Configure the logged in versus logged out UI
 */

- (void)sessionStateChanged:(NSNotification*)notification {
    NSLog(@"sessionStateChanged");
    if (FBSession.activeSession.isOpen) {
        
        NSLog(@"sessionStateChanged:isOpen:%@",FBSession.activeSession.appID);
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.fbuserDict = user;
                 NSLog(@"user.name:%@",user.name);
                 NSLog(@"user.id:%@",user.id);
                 NSLog(@"user.Location:%@",user.location);
                 // NSLog(@"user:image:%@",user.);
                 
                 NSString *fbuid= user.id;
                 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https:/graph.facebook.com/%@/picture?type=large", fbuid]];
                 NSData *data = [NSData dataWithContentsOfURL:url];
                 UIImage *image = [UIImage imageWithData:data];
                 NSLog(@"image:%@",image);
                 [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:@"kFacebookAccountTypeKey"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 //[self addLoadingScreen];
                 //[self openSharingController];
                 //[self removeLoadingScreen];
                 // self.userNameLabel.text = user.name;
                 // self.userProfileImage.profileID = user.id;
                
             }
         }];
         
       //[self openSharingController];
        
        
    } else {
        NSLog(@"sessionStateChanged:NOOOO");
    }
    
}

-(void)getSuccesNotification:(NSNotification *)notify{
    
    
    NSDictionary *responseDic = [notify object];
    NSLog(@"getSuccesNotification:%@",responseDic);
    self.tempDict = [responseDic objectForKey:@"Question"];
    NSLog(@"tempDict:%@",_tempDict);
    //    NSDictionary *postDictinary = [self.QuestionOptions objectAtIndex:0];
    //    NSLog(@"postDictinary:%@",postDictinary);
    //
    //    FaceBookViewController *viewController = [[FaceBookViewController alloc]
    //                                              initWithNibName:@"FaceBookViewController"
    //                                              bundle:nil];
    //    viewController.postDict = postDictinary;
    //    viewController.postUrlString = [tempDict objectForKey:@"URL"];
    //    [self presentViewController:viewController animated:YES completion:nil];
    [self postshareAction];
    /*   NSLog(@"scanDataArr:%@",scanDataDict1);
     for (int i = 0; i<[scanDataDict1 count]; i++) {
     self.scanProductDict = [scanDataDict1 objectForKey:@"0"];
     NSLog(@"dataDict:%@",self.scanProductDict);
     //[self.scanProductDict];
     }
     */
    
}



- (void) logged:(LoginType) type
{
    NSLog(@"logged");
    [_tableView reloadData];
   }






@end
