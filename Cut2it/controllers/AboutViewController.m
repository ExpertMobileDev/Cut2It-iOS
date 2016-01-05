//
//  AboutViewController.m
//  cut2it
//
//  Created by Администратор on 12.11.12.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize aboutView;

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"rounded" width:68 target:self action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = back;

    NSString *aboutTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *html = [NSString stringWithFormat:aboutTemplate,@""];
    [self.aboutView loadHTMLString:html baseURL:nil];    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([[request.URL absoluteString] rangeOfString:@"http://"].location != NSNotFound)
    {
        
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}



@end
