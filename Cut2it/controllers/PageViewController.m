//
//  PageViewController.m
//  cut2it
//
//  Created by admin on 4/2/13.
//
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (id)initWithPageNumberAndImage:(int)page :(NSString *)name;
 {
    if (self = [super initWithNibName:@"PageViewController" bundle:nil])    {
        pageNumber = page;
        imageName = name;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageIntro.image = [UIImage imageNamed:imageName];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
