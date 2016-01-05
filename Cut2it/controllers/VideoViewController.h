//
//  VideoViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomScrollView.h"
#import "UIImageThumbnailView.h"
#import "YouTubeView.h"
#import "PlayerViewController.h"

@interface VideoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,CustomScrollViewDelegate>
{
    UIActivityIndicatorView *spinner;
}



@property (retain, nonatomic) IBOutlet  CustomScrollView* _scrollView;
@property (retain, nonatomic) NSMutableArray *list;
@property (retain, nonatomic) NSMutableArray *tempList;
@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property (retain, nonatomic) IBOutlet  UIButton *bThumbnails;
@property (retain, nonatomic) IBOutlet  UIButton *bList;
@property (nonatomic) BOOL _isList;
@property (nonatomic) int _offset;
@property (nonatomic) int _limit;
@property (nonatomic) int _limitTemp;
@property (nonatomic) int total;

-(void) changeView:(BOOL) isList;
-(void)list:(id) sender;
-(void)thumbnails:(id) sender;
-(void) fillTable;
-(void) initScrollView;
-(void)scrollTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)scrollTouchesEnd:(NSSet *)touches withEvent:(UIEvent *)event;
- (UIButton *) createBarButtonWithName:(NSString *) name
                    backgroundSelected:(NSString *) backgroundSelected
                                 image:(NSString *) image
                         imageSelected:(NSString *) imageSelected
                             xPosition:(CGFloat)x
                                target:(id) target
                                action:(SEL) action;

-(void)initSpinner;

@end
