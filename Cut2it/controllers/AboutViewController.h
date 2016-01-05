//
//  AboutViewController.h
//  cut2it
//
//  Created by Администратор on 12.11.12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AboutViewController : BaseViewController<UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *aboutView;

@end
