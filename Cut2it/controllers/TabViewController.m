//
//  TabViewController.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabViewController.h"
#import "SVProgressHUD.h"
#import "HomeViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

@synthesize tabcontroller;
@synthesize cameraType;
@synthesize tabIndex;

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:tabcontroller animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [SVProgressHUD dismiss];
    
    UITabBar *myTabBar = tabcontroller.tabBar;
    for (UITabBarItem *item in myTabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
        if (item.tag == 0) {
            [item setFinishedSelectedImage:[UIImage imageNamed:@"t_home_a"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_home_f"]];
            [item setTitle:@"Home"];
        } else if (item.tag == 1) {
            [item setFinishedSelectedImage:[UIImage imageNamed:@"t_youtube_a"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_youtube_f"]];
            [item setTitle:@"YouTube"];
        } else if (item.tag == 2) {
            [item setFinishedSelectedImage:[UIImage imageNamed:@"t_record_a"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_record_f"]];
            [item setTitle:@"Camera"];
        } else if (item.tag == 3) {
            [item setFinishedSelectedImage:[UIImage imageNamed:@"t_movie_a"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_movie_f"]];
            [item setTitle:@"Library"];
        } else if (item.tag == 4) {
            [item setFinishedSelectedImage:[UIImage imageNamed:@"t_settings_a"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_settings_f"]];
            [item setTitle:@"Settings"];
        }
    }
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadMedia:)
                                                 name:@"UploadMedia"
                                               object:nil];
    _titles = [[NSMutableArray alloc] initWithObjects: @"Home", @"YouTube", @"Camera", @"Library", @"Settings", nil];
    _images = [[NSMutableArray alloc] initWithObjects: @"t_home_f", @"t_youtube_f", @"t_record_f", @"t_movie_f", @"t_settings_f", nil];
    _selImages = [[NSMutableArray alloc] initWithObjects: @"t_home_a", @"t_youtube_a", @"t_record_a", @"t_movie_a", @"t_settings_a", nil];
    
    CGFloat screenWidth = tabcontroller.tabBar.frame.size.width;
    CGFloat tabWidth = screenWidth / 5;
    CGFloat tabHeight = tabcontroller.tabBar.frame.size.height + 5;
    
    _tabBack = [[UIView alloc] initWithFrame:CGRectMake(0, -5, screenWidth, tabHeight)];
    _tabBack.userInteractionEnabled = NO;
    _tabBack.backgroundColor = [UIColor clearColor];
    [tabcontroller.tabBar addSubview:_tabBack];
    
    _tabImages = [[NSMutableArray alloc] init];
    _tabTitles = [[NSMutableArray alloc] init];
    
    for (int n = 0; n < 5; n++) {
        UIImageView* tabImage = [[UIImageView alloc] initWithFrame:CGRectMake(n * tabWidth, 0, tabWidth, tabHeight)];
        tabImage.userInteractionEnabled = NO;
        tabImage.backgroundColor = [UIColor clearColor];
        if (n == 0) {
            tabImage.image = [UIImage imageNamed:[_selImages objectAtIndex:n]];
        } else {
            tabImage.image = [UIImage imageNamed:[_images objectAtIndex:n]];
        }
        [_tabImages addObject:tabImage];
        [_tabBack addSubview:tabImage];
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(n * tabWidth, tabHeight - 13, tabWidth, 13)];
        title.userInteractionEnabled = NO;
        title.text = [_titles objectAtIndex:n];
        title.font = [UIFont systemFontOfSize:10];
        title.textAlignment = NSTextAlignmentCenter;
        if (n == 0) {
            title.textColor = [tabcontroller.tabBar tintColor];
        } else {
            title.textColor = [UIColor whiteColor];
        }
        [_tabTitles addObject:title];
        [_tabBack addSubview:title];
    }
    _homeController.homeDelegate = self;
    _youtubeController.youtubeDelegate = self;
}


- (void)viewDidUnload {
    self.tabcontroller = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UploadMedia"
                                                  object:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	UINavigationController *nav = (UINavigationController *) viewController;
	[nav popToRootViewControllerAnimated:NO];
	
    if ([nav.topViewController isKindOfClass:NSClassFromString(@"TitleViewController")]) {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Video Camera", @"Video Library", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:tabBarController.tabBar];
        [popupQuery release];
        
        return NO;
    }
   	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    for (int n = 0; n < 5; n++) {
        UIImageView* tabImage = [_tabImages objectAtIndex:n];
        UILabel* title = [_tabTitles objectAtIndex:n];
        
        if (n == tabBarController.selectedIndex) {
            tabImage.image = [UIImage imageNamed:[_selImages objectAtIndex:n]];
            title.textColor = [tabcontroller.tabBar tintColor];
        } else {
            tabImage.image = [UIImage imageNamed:[_images objectAtIndex:n]];
            title.textColor = [UIColor whiteColor];
        }
    }
    
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    
	if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraType=RecordType;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
	} else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        cameraType = LibraryType;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
    } else if (buttonIndex == 2) {
		
	}
}
-(void) callVideoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        cameraType= LibraryType;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
    }

}
-(void) callCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraType = RecordType;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.delegate = self;
        [self presentModalViewController:picker animated: YES];
        [picker release];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Video Camera", @"Video Library", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:tabcontroller.tabBar];
    [popupQuery release];
}

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    
    UIImagePickerControllerSourceType type = picker.sourceType;
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self recordMedia:videoURL];
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *picture= [info objectForKey:UIImagePickerControllerOriginalImage];
            NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
            
            [library writeImageToSavedPhotosAlbum:[picture CGImage] metadata:metadata
                                  completionBlock:^(NSURL *assetURL, NSError *error){}
             ];
            
        } else if ([mediaType isEqualToString:@"public.movie"]){
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            
            [self recordMedia:videoURL];
            
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
                [library writeVideoAtPathToSavedPhotosAlbum:videoURL
                                            completionBlock:^(NSURL *assetURL, NSError *error){}
                 ];
            }
            
        }
    
        [library release];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) recordMedia:(NSURL *) url {
    NetworkStatus status = [self.api checkConnection];
    if(status == NotReachable) {
        [super error:@"No Internet Connection"];
    } else {
        self.container.url = url;
        TitleViewController *controller = [[TitleViewController alloc] init];
        controller.customDelegate = self;
        controller.type = cameraType;
        [[self.delegate navigationController] pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void) uploadMedia:(NSNotification*) notification {
    Media *media = notification.object;
    NSData *data = [[NSData alloc]initWithContentsOfURL:media.url options:NSDataReadingMappedIfSafe error:nil];
    [self.api uploadMedia:data videoId:media.pk delegate:self];
    [data release];
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithContentURL:media.url media:media];
    [self.navigationController pushViewController:player animated:YES];
    [player release];
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    // Bhavya
    //[self error:@"Video uploaded successfully"];
    NSLog(@"Video uploaded");
}

- (void)dealloc {
    [super dealloc];
}

#pragma - mark HomeViewDelegate
- (void)refreshTabBar {

    if (_tabBack) {
        [_tabBack removeFromSuperview];
        [tabcontroller.tabBar addSubview:_tabBack];
    }
}

@end
