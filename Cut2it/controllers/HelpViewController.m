//
//  HelpViewController.m
//  cut2it
//
//  Created by Eugene on 9/13/12.
//
//

#import "HelpViewController.h"

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
     return UIDeviceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)swith:(UISwitch *)sender {
    BOOL help = !sender.on;
    [Util setBoolProperties:HELP value:help];
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
