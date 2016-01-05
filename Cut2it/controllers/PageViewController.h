//
//  PageViewController.h
//  cut2it
//
//  Created by admin on 4/2/13.
//
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController
{
    IBOutlet UIImageView *imageIntro;
    NSInteger pageNumber;
    NSString *imageName;
}
@property (nonatomic, retain) UIImageView *imageIntro;
- (id)initWithPageNumberAndImage:(int)page :(UIImageView *)image;

@end