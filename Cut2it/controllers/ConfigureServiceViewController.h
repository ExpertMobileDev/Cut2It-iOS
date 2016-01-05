//
//  ConfigureServiceViewController.h
//  cut2it
//
//  Created by Mac on 10/19/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import <FacebookSDK/FacebookSDK.h>
//BB0202: To support iOS8 and new FacebookSDK
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import "FacebookSDK.h"

#import "FaceBookViewController.h"
    
@interface ConfigureServiceViewController:BaseViewController <UITableViewDelegate,UITableViewDataSource,FBLoginViewDelegate>{
     FaceBookViewController *fbviewController;
}

@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property(nonatomic,retain)NSDictionary<FBGraphUser> *fbuserDict;

-(void) fillCellTextImage:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
-(void) fillCellStatus:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
-(void) fillAccessoryType:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
-(void) fillCellBackground:(UITableViewCell*) cell:(NSIndexPath*) indexPath;
@property(nonatomic,retain)NSDictionary *tempDict;

-(void) connectDisconnect:(id)sender;
- (void) logged:(LoginType) type;
-(void)openTwitterAccountController;


@end
