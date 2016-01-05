//
//  ShareMenuViewController.h
//  cut2it
//
//  Created by Eugene on 8/24/12.
//
//

#import "BaseViewController.h"
#import "ContactViewController.h"
#import "CTileView.h"
#import "ConfigureServiceViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "TweetComposeViewController.h"
#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accounts/Accounts.h>

@protocol ShareOptionViewControllerDelegate
    - (void) logged:(LoginType) type;
@end

@interface ShareOptionViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>{
 
}
@property (nonatomic) BOOL isPost;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic) ACAccount *account;



@property (retain, nonatomic) id <ShareOptionViewControllerDelegate> customDelegate;
- (void) success:(BOOL) success;
- (void) sendEmail;
@end
