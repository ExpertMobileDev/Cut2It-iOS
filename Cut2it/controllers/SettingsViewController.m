//
//  SettingsViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"n_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f], UITextAttributeFont,
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor blackColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                                     nil]];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    
    [self setLogout];
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) setLogout
{
    UIView *bView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 100.0)];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.56] forState:UIControlStateDisabled];
    [aButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [aButton setBackgroundImage:[UIImage imageNamed:@"button_log-out_free"] forState:UIControlStateNormal];
    [aButton setBackgroundImage:[UIImage imageNamed:@"button_log-out_active"] forState:UIControlStateHighlighted];
    
    [aButton setFrame:CGRectMake(10.0, 40.0, 280.0, 50.0)];
    [bView addSubview:aButton];
    [aButton release];
    [self._tableView setTableFooterView:bView];
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self._tableView reloadData];
  
}
#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _tableView=tableView;
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)] autorelease];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 320,15)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    headerLabel.backgroundColor= [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    
    NSString * title =@"";
    switch (section) {
        case 0:
            title= @"Account";
            break;
        case 1:
            title = @"Misc";
            break;
        default:
            break;
    }
    headerLabel.text = title;
    
    [hView addSubview:headerLabel];
    [headerLabel release];
    return hView;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *) table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"] autorelease];
        cell.textLabel.textColor= [UIColor colorWithWhite:0.6 alpha:1];
        if(indexPath.row == 0 && indexPath.section == 1)
        {
            // label.highlightedTextColor = [UIColor whiteColor];
        }
        else
        {
            cell.textLabel.highlightedTextColor= [UIColor colorWithWhite:0.6 alpha:1];
        }
        
        cell.textLabel.font =[UIFont fontWithName:@"Helvetica" size:16];
        cell.accessoryType = TRUE;
        cell.clipsToBounds=TRUE;
    }
    
    
    
    [self fillCellTextImage:cell:indexPath];
    [self fillCellBackground:cell:indexPath];
    [self fillAccessoryType:cell:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        AccountViewController *controller = [[AccountViewController alloc] init];
        controller.isEditAccount = TRUE;
        controller.navigationItem.title = @"Edit Profile";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
        ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
        controller.navigationItem.title = @"Service";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];   
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        AboutViewController *controller = [[AboutViewController alloc] init];
        controller.navigationItem.title = @"About";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else
    {
        ComingSoonViewController *controller = [[ComingSoonViewController alloc] init];
        controller.navigationItem.title = cell.textLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Account";
            break;
        case 1:
            return @"Misc";
            break;
        default:
            break;
    }
    return @"";
}



#pragma mark - Fill Cells
-(void) fillAccessoryType:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    
    if(indexPath.section ==1 && indexPath.row == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        
        if(indexPath.row == 0 && indexPath.section == 1)
        {
            label.highlightedTextColor = [UIColor whiteColor];
        }
        
        cell.userInteractionEnabled = FALSE;
        cell.accessoryView = label;
    }
    else{
        UIImage *image = [UIImage   imageNamed:@"arrow_free"] ;
        UIImage *imageSelected = [UIImage   imageNamed:@"arrow_active"] ;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
        
    }
    
    
}

-(void) fillCellTextImage:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    NSString * title = @"";
    UIImage * image = [UIImage imageNamed:@"set_icon_friends_free"];
    UIImage * selectedImage = [UIImage imageNamed:@"set_icon_friends_active"];
    
    switch (indexPath.section) {
       /* case 0:
            switch (indexPath.row) {
                case 0:
                    title =@"Friends";
                    break;
            }
            break;*/
            
        case 0:
            switch (indexPath.row) {
                case 0:
                    title =@"Edit Profile";
                    image= [UIImage imageNamed:@"icon_edit-profile_free"];
                    selectedImage = [UIImage imageNamed:@"icon_edit-profile_active"];
                    break;
                case 1:
                    title =@"Configure Services";
                    image= [UIImage imageNamed:@"icon_configuring-settings_free"];
                    selectedImage = [UIImage imageNamed:@"icon_configuring-settings_active"];
                    break;
             /*   case 2:
                    title =@"Push Settings";
                    image= [UIImage imageNamed:@"icon_push-settings_free"];
                    selectedImage = [UIImage imageNamed:@"icon_push-settings_active"];
                    break;
                case 3:
                    title =@"Privacy Settings";
                    image= [UIImage imageNamed:@"icon_privacy-settings_free"];
                    selectedImage = [UIImage imageNamed:@"icon_privacy-settings_active"];
                    
                    break;*/
                default:
                    break;
            }
            break;
            
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    title =@"Version";
                    image= [UIImage imageNamed:@"icon_version_free"];
                    selectedImage = [UIImage imageNamed:@"icon_version_active"];
                    break;
              /* case 1:
                    title =@"Follow Us on Twitter";
                    image= [UIImage imageNamed:@"icon_twitter_free"];
                    selectedImage = [UIImage imageNamed:@"icon_twitter_active"];
                    break;*/
                case 1:
                    title =@"About";
                    image= [UIImage imageNamed:@"icon_about_free"];
                    selectedImage = [UIImage imageNamed:@"icon_about_active"];
                    
                    break;
                default:
                    break;
            }
            break;
            
            
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.imageView.image = image;
    cell.imageView.highlightedImage = selectedImage;
   
}
-(void) fillCellBackground:(UITableViewCell*) cell:(NSIndexPath*) indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    UIImage *rowBackground;
    UIImage *selectionBackground;
    rowBackground = [UIImage imageNamed:@"cell_middle_free"];
    selectionBackground = [UIImage imageNamed:@"cell_middle_active"];
    
    if((indexPath.row == 0 && indexPath.section == 0) || (indexPath.row == 0 && indexPath.section == 1 ))
    {
        rowBackground = [UIImage imageNamed:@"cell_top_free"];
        selectionBackground = [UIImage imageNamed:@"cell_top_active"];
    }
  /*  if(indexPath.row == 0 &&  indexPath.section == 0 )
    {
        rowBackground = [UIImage imageNamed:@"cell_one_free"];
        selectionBackground = [UIImage imageNamed:@"cell_one_active"];
    }*/
    if((indexPath.section == 1 && indexPath.row == 1) ||(indexPath.section == 0 && indexPath.row ==1))
    {
        rowBackground = [UIImage imageNamed:@"cell_bottom_free"];
        selectionBackground = [UIImage imageNamed:@"cell_bottom_active"];
    }
    
    cell.backgroundView =[[[UIImageView alloc] init] autorelease];
    
    cell.selectedBackgroundView =   [[[UIImageView alloc] init] autorelease];
    
    
    
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;
    ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)logout:(id)sender {
    [self.api logout];
    [self.api closeSession];
    [[self.delegate navigationController] popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    //  [helpChange release];
    [super dealloc];
}
@end
