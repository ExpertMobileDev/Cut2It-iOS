//
//  IntroViewController.h
//  cut2it
//
//  Created by Eugene on 11/9/12.
//
//

#import "BaseViewController.h"


@interface IntroViewController : BaseViewController <UIScrollViewDelegate>
{
    IBOutlet UIImageView *imgView;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet NSMutableArray *viewControllers;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)close:(id)sender;

@end
