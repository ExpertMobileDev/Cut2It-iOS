//
//  TweetComposeViewController.m
//  TwitterClient
//
//  Created by Peter Friese on 15.11.11.
//  Copyright (c) 2011, 2012 Peter Friese. All rights reserved.
//

#import "TweetComposeViewController.h"
#import <Twitter/Twitter.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation TweetComposeViewController

@synthesize account = _account;
@synthesize tweetComposeDelegate = _tweetComposeDelegate;

@synthesize closeButton;
@synthesize sendButton;
@synthesize textView;
@synthesize titleView;
//@synthesize tweetcoustomDelegate;

#pragma mark TextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {    
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView {    
    return YES;
}

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    self.titleView.title = [NSString stringWithFormat:@"@%@", self.account.username];    
    //[textView setKeyboardType:UIKeyboardTypeTwitter];
    [textView becomeFirstResponder];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.videoTitle && ![appDelegate.videoTitle isEqualToString:@" "]){
        textView.text = [NSString stringWithFormat:@"%@",appDelegate.videoTitle];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    navbar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"n_background@2x.png"]];
    
    textView.layer.borderWidth = 1.5f;
    textView.layer.borderColor = [[UIColor blackColor] CGColor];
   // n_background@2x.png
    //
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCloseButton:nil];
    [self setSendButton:nil];
    [self setTextView:nil];
    [self setTitleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)sendTweet:(id)sender 
{
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.tweetComposeDelegate sendtoTweeter:self.textView.text];
    //[self.tweetComposeDelegate sendtoTweeter];
    [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultSent];
}

- (IBAction)cancel:(id)sender
{
    [self.tweetComposeDelegate tweetComposeViewController:self didFinishWithResult:TweetComposeResultCancelled];
}

@end
