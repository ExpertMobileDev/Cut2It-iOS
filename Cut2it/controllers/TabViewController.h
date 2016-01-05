//
//  TabViewController.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "PlayerViewController.h"
#import "TitleViewController.h"
#import "HomeViewController.h"
#import "YouTubeViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface TabViewController : BaseViewController<UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASIHTTPRequestDelegate,TitleViewControllerDelegate, HomeViewDelegate, YoutubeViewDelegate>

@property (retain, nonatomic) IBOutlet UITabBarController *tabcontroller;
@property (retain, nonatomic) IBOutlet HomeViewController *homeController;
@property (retain, nonatomic) IBOutlet YouTubeViewController *youtubeController;
@property (nonatomic) int cameraType;
@property (nonatomic,strong) NSNumber *tabIndex;

@property (nonatomic,strong) UIView *tabBack;
@property (nonatomic,strong) NSMutableArray *tabImages;
@property (nonatomic,strong) NSMutableArray *tabTitles;

@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *selImages;

-(void) callCamera;
-(void) callVideoLibrary;
-(void) showTabBar;
@end

