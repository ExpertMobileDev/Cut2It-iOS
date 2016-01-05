//
//  LoadingView.m
//  cut2it
//
//  Created by Anand Kumar on 19/02/13.
//
//

#import "LoadingView.h"

@interface LoadingView ()

@end

@implementation LoadingView
@synthesize spinner, loadingLabel,loadingImgView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [spinner release];
    [loadingLabel release];
    [super dealloc];
}


@end
