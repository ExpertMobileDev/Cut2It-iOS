//
//  YouTubeViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "YouTubeView.h"
#import "PlayerViewController.h"
#import "CSearchView.h"
#import "DiscussionViewController.h"

@protocol YoutubeViewDelegate <NSObject>
- (void) refreshTabBar;
@end

@interface YouTubeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIImageView *imgBottomShadow;
}

@property (retain, nonatomic) CSearchView *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *list;
@property (nonatomic, assign)   id <YoutubeViewDelegate>   youtubeDelegate;

- (void) search:(CSearchView *) search;

@end
