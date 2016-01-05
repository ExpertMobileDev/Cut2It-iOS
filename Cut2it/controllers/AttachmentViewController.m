//
//  AttachmentViewController.m
//  cut2it
//
//  Created by Администратор on 06.12.12.
//
//

#import "AttachmentViewController.h"

@interface AttachmentViewController ()

@end

@implementation AttachmentViewController
@synthesize imageView;
@synthesize imageUrl;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *cancel = [self createBarButtonWithName:@"Back" image:@"rounded" width:68 target:self action:@selector(back:)];

        self.navigationItem.leftBarButtonItem = cancel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

      [[Cut2itApi shared] imageAttachment:self.imageUrl delegate:self];
       [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_common"]]];
     
}

 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    
        NSData *responseData = [request responseData];
        self.imageView.image = [UIImage imageWithData:responseData];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void) dealloc {

    [super dealloc];
}

@end
