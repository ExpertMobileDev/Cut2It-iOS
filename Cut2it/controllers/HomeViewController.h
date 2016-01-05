//
//  Cut2ItViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "YouTubeView.h"
#import "PlayerViewController.h"
#import "CustomScrollView.h"
#import "UIImageThumbnailView.h"
#import "FaceBookViewController.h"

@protocol HomeViewDelegate <NSObject>
- (void) refreshTabBar;
@end

@interface HomeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,CustomScrollViewDelegate>{
     FaceBookViewController *fbviewController;
    // Bhavya
    UIActivityIndicatorView *spinner;
    UILabel *labelView;

}

@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property (retain, nonatomic) IBOutlet  CustomScrollView* _scrollView;
@property (retain, nonatomic) NSMutableArray *list;
@property (retain, nonatomic) NSMutableArray *tempTrendingList;
@property (retain, nonatomic) NSMutableArray *tempStarredList;

@property (nonatomic, assign)   id <HomeViewDelegate>   homeDelegate;

@property (retain, nonatomic) IBOutlet  UIButton *bGlobe;
@property (retain, nonatomic) IBOutlet  UIButton *bStar;

@property (retain, nonatomic) IBOutlet  UIButton *bThumbnails;
@property (retain, nonatomic) IBOutlet  UIButton *bList;
@property (nonatomic) BOOL _isList;
@property (nonatomic) int _selectedIndex;
// To avoid multiple video list calls on continuous clicking of Globe and Star Buttons
@property (nonatomic) BOOL _isPopularListLoaded;
@property (nonatomic) BOOL _isStarredListLoaded;
@property (nonatomic) int _offset;
@property (nonatomic) int _limit;
@property (nonatomic, assign) int total;
@property (nonatomic) int _offsetStarredVideo;
@property (nonatomic) int _limitStarredVideo;
@property (nonatomic, assign) int totalStarredVideo;

-(void) changeView:(BOOL) isList;
-(void)list:(id) sender;
-(void)thumbnails:(id) sender;
-(void)star:(id) sender;
-(void)globe:(id) sender;
-(void)unselectAllButtons;
-(void) fillTable;
-(void)initSpinner;
-(void)setOffsetLimit:(int)limit :(int)newlimit;
-(void)total:(int) totalCount;
-(void)finishTrending:(id)data;

@end
