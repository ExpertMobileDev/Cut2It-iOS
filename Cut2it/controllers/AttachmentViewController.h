//
//  AttachmentViewController.h
//  cut2it
//
//  Created by Администратор on 06.12.12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ASIHTTPRequestDelegate.h"


@interface AttachmentViewController :BaseViewController <ASIHTTPRequestDelegate>
@property (retain, nonatomic) IBOutlet NSString *imageUrl;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@end
