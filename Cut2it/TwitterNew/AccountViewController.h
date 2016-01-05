//
//  AccountViewController.h
//  cut2it
//
//  Created by Anand Kumar on 11/02/13.
//
//

#import <UIKit/UIKit.h>

#import <Accounts/Accounts.h>
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>



@interface AccountViewController : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate, UITableViewDataSource>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSIndexPath* checkedIndexPath;
    NSMutableArray *twitterParamarray;
    IBOutlet UITableView *tableView;
}
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic) ACAccount *account;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (nonatomic,retain)IBOutlet UITableView *tableView;
//@property (nonatomic, strong) TWAPIManager *apiManager;

@end



