//
//  ComingSoonViewController.m
//  cut2it
//
//  Created by Mac on 10/12/12.
//
//

#import "ComingSoonViewController.h"

@interface ComingSoonViewController ()

@end

@implementation ComingSoonViewController

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *cancel = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = cancel;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"comingsoon"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
