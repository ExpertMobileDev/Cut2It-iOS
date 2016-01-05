//
//  YouTubeView.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

#import "Cut2itApi.h"
#import "Media.h"

@interface YouTubeView : UITableViewCell <ASIHTTPRequestDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UILabel *duration;
@property (retain, nonatomic) IBOutlet UILabel *viewsCount;
@property (retain,nonatomic) IBOutlet UILabel *username;
- (void) fill:(Media *) view;
- (void) fill:(Media *) view dutation:(NSString *) duration;
- (void) fillMedia:(Media *) view dutation:(NSString *) duration;

@end
