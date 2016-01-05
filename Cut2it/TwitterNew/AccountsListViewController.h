//
//  AccountsListViewController.h
//  TwitterClient
//
//  Created by Peter Friese on 19.09.11.
//  Copyright (c) 2011, 2012 Peter Friese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "Cut2itApi.h"
#import "LoadingView.h"
//#import "OAuth+Additions.h"
//#import "TWAPIManager.h"
//#import "TWSignedRequest.h"
@class LoadingView;

@interface AccountsListViewController : UITableViewController <APIDelegate,EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
      NSIndexPath* checkedIndexPath;
    NSMutableArray *twitterParamarray;
    LoadingView *loadingView;
}

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (nonatomic, retain) LoadingView *loadingView;
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic) ACAccount *account;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (nonatomic, retain) Cut2itApi *api;
//@property (nonatomic, strong) TWAPIManager *apiManager;


- (void) showLoadingView;
- (void) hideLoadingView;

@end
