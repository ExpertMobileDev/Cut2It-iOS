//
//  SettingsViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountViewController.h"
#import "ComingSoonViewController.h"
#import "ConfigureServiceViewController.h"
#import "AboutViewController.h"

@interface SettingsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *_tableView;



//- (IBAction)helpSwith:(UISwitch *)sender;
- (IBAction)logout:(id)sender;
-(void) setLogout;

-(void) fillAccessoryType:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
-(void) fillCellTextImage:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
-(void) fillCellBackground:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
@end