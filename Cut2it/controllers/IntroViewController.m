//
//  IntroViewController.m
//  cut2it
//
//  Created by Eugene on 11/9/12.
//
//

#import "IntroViewController.h"
#import "PageViewController.h"

@interface IntroViewController()
{
    NSMutableArray *myObject;
    int i;
    NSUInteger numberPages;
    BOOL pageControlUsed;
}
@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    int height;
    if(IPHONE_5)
    {
        height = 568;
    }
    else{
        height = 480;
    }
    
    if(IPHONE_5)
    {
        //CGRect sizebtnClose = CGRectMake(0, 44, 40, 40);
        //[imgDrag setFrame:sizebtnClose];
        
        //350+88=394
        CGRect sizeImgDrag = CGRectMake(230, 414, 40, 27);
        [imgView setFrame:sizeImgDrag];       
    
    }
    
   
    myObject = [[NSMutableArray alloc] init];
    [myObject addObject:@"screen1@2x.png"];
    [myObject addObject:@"screen2@2x.png"];
    [myObject addObject:@"screen3@2x.png"];
    [myObject addObject:@"screen4@2x.png"];
    [myObject addObject:@"screen5@2x.png"];
    [myObject addObject:@"screen6@2x.png"];
    
    numberPages = myObject.count;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < numberPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numberPages, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= numberPages) return;
    
    PageViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[PageViewController alloc] initWithPageNumberAndImage:page :[myObject objectAtIndex:page]];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    if (nil == controller.view.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}
- (IBAction)changePage:(id)sender {
    int page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//
////    i=0;
////    myObject = [[NSMutableArray alloc] init];
////    [myObject addObject:@"screen1@2x.png"];
////    [myObject addObject:@"screen2@2x.png"];
////    [myObject addObject:@"screen3@2x.png"];
////    [myObject addObject:@"screen4@2x.png"];
////    [myObject addObject:@"screen5@2x.png"];
////    [myObject addObject:@"screen6@2x.png"];
////
////    imgView.image = [UIImage imageNamed:@"screen1@2x.png"];
//
////
////    // Left Swipe Gesture
////    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
////                                           initWithTarget:self
////                                           action:@selector(swipeLeftHandle:)];
////    swipeLeft.numberOfTouchesRequired = 1;
////    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
////    [[self view] addGestureRecognizer:swipeLeft];
////    [swipeLeft release];
////
////
////    // Right Swipe Gesture
////    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
////                                            initWithTarget:self
////                                            action:@selector(swipeRightHandle:)];
////    swipeRight.numberOfTouchesRequired=1;
////    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
////    [[self view] addGestureRecognizer:swipeRight];
////    [swipeRight release];
//
//
//    _scrollView.contentSize = CGSizeMake(1920, 480);
//
//    UIImageView *screen1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen1"]];
//    screen1.center = CGPointMake(160, 240);
//    [_scrollView insertSubview:screen1 atIndex:0];
//    [screen1 release];
//
//    UIImageView *screen2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen2"]];
//    screen2.center = CGPointMake(480, 240);
//    [_scrollView addSubview:screen2];
//    [screen2 release];
//
//    UIImageView *screen3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen3"]];
//    screen3.center = CGPointMake(800, 240);
//    [_scrollView addSubview:screen3];
//    [screen3 release];
//
//    UIImageView *screen4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen4"]];
//    screen4.center = CGPointMake(1120, 240);
//    [_scrollView addSubview:screen4];
//    [screen4 release];
//
//    UIImageView *screen5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen5"]];
//    screen5.center = CGPointMake(1440, 240);
//    [_scrollView addSubview:screen5];
//    [screen5 release];
//
//    UIImageView *screen6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen6"]];
//    screen6.center = CGPointMake(1760, 240);
//    [_scrollView addSubview:screen6];
//    [screen6 release];
//
//}

//-(void) swipeRightHandle:(UISwipeGestureRecognizer *) sender {
//    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//
//        if(i > 0)
//        {
//            i = i - 1;
//            //i = myObject.count - 1;
//            NSString *arrValue = [myObject objectAtIndex:i];
//            //imgView.image = [UIImage imageNamed:arrValue];
//
//            NSLog (@"%@" , [NSString stringWithFormat:@"Hello %@",arrValue]);
//
//            float viewHt = 460;
//            /*
//            if (IPHONE_5) {
//                viewHt = 548;
//            }
//             */
//            UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-320, 0, 320, viewHt)];
//            secondImageView.image = [UIImage imageNamed:arrValue];
//            [self.view addSubview:secondImageView];
//
//            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationTransitionNone animations:^{
//                [imgView setFrame:CGRectMake(320, 0, 320, viewHt)];
//                [secondImageView setFrame:CGRectMake(0, 0, 320, viewHt)];
//            }
//                             completion:^(BOOL finished){
//                                 imgView = secondImageView;
//                             }];
//
//        }
//
//    }
//}
//
//-(void) swipeLeftHandle:(UISwipeGestureRecognizer *) sender {
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//
//        if(i < myObject.count-1 && i >= 0)
//        {
//            NSLog(@"i is %i and count is %i", i, myObject.count);
//            i = i + 1;
//            // i = 0;
//
//            NSString *arrValue = [myObject objectAtIndex:i];
//            //imgView.image = [UIImage imageNamed:arrValue];
//
//            NSLog (@"%@" , [NSString stringWithFormat:@"Hello %@",arrValue]);
//            float viewHt = 460;
//            /*
//             if (IPHONE_5) {
//             viewHt = 548;
//             }
//             */
//            UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, viewHt)];
//            secondImageView.image = [UIImage imageNamed:arrValue];
//            [self.view addSubview:secondImageView];
//
//            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationTransitionNone animations:^{
//                [imgView setFrame:CGRectMake(-320, 0, 320, viewHt)];
//                [secondImageView setFrame:CGRectMake(0, 0, 320, viewHt)];
//            }
//                             completion:^(BOOL finished){
//                                 imgView = secondImageView;
//                             }];
//        }
//
//
//    }
//}
//


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
