//
//  ShareMenuViewController.m
//  cut2it
//
//  Created by Eugene on 8/24/12.
//
//

#import "ShareOptionViewController.h"
#import "AppDelegate.h"
#import "TweetComposeViewController.h"

//BB0202: using newer
#import <FacebookSDK/FacebookSDK.h>
//#import "FacebookSDK.h"

@interface ShareOptionViewController ()
{
    BOOL IsSuccessForAnnotation;
    BOOL IsSuccessForLoadTemplate;
    NSString* annotationContent;
    NSString* clippedVideoURL;
    SimpleIdentifier* emailTemplate;
}

@end

@implementation ShareOptionViewController
@synthesize isPost;

@synthesize accountStore = _accountStore;
@synthesize accounts = _accounts;
@synthesize account = _account;
@synthesize customDelegate;

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    self.navigationItem.title = @"Share";
    
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
    [back release];
    
    self.isPost = FALSE;
    [self setDefaultAccount];
    
    IsSuccessForAnnotation = FALSE;
    IsSuccessForLoadTemplate = FALSE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setDefaultAccount{
    
    if (_accountStore == nil) {
        self.accountStore = [[ACAccountStore alloc] init];
        if (_accounts == nil) {
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];                       
                        for (int i=0; i<[_accounts count]; i++) {
                            ACAccount *account1 = [_accounts objectAtIndex:i];
                             NSLog(@"account1 user is %@ and twitter username is %@ and twitter user is %@",account1.username, [Util getProperties:TWITTER_USERNAME], [Util getProperties:TWITTER_USER]);
                            if([account1.username isEqualToString:[Util getProperties:TWITTER_USER]]){
                                appDelegate.account = account1;
                                [[NSUserDefaults standardUserDefaults] setObject: appDelegate.account forKey:@"account"] ;
                            }
                        }
                        
                    });
                }
            }];
        }
    }     
}

-(void)dealloc{
    _accountStore = nil;
    _accounts = nil;

    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table Data Source

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  
    // Facebook Friends - return 6;
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *) table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_backgroundpattern_f"]];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"so_arrow_f"]];
        arrow.frame = CGRectMake(293, 17, 10, 15);
        [background addSubview:arrow];
        [arrow release];
        
        cell.backgroundView = background;
        [background release];
        
        
        UIView *select = [[CTileView alloc] initWithFrame:CGRectMake(0, 0, 320, 42) image:[UIImage imageNamed:@"c_backgroundpattern_a"]];
        
        arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"so_arrow_a"]];
        arrow.frame = CGRectMake(293, 17, 10, 15);
        [select addSubview:arrow];
        [arrow release];         
        
        cell.selectedBackgroundView = select;
        [select release];
    }
    
    NSInteger row = indexPath.row;

    switch (row) {             
        case 0:
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_facebook_a"];
            cell.imageView.image= [UIImage imageNamed:@"so_facebook_f"];
            cell.textLabel.text = @"Facebook";
            cell.tag = 0;
            break;
        case 1:
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_twitter_a"];
            cell.imageView.image = [UIImage imageNamed:@"so_twitter_f"];
            cell.textLabel.text = @"Twitter";
            cell.tag = 1;
            break;
        case 2:
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_sms_a"];
            cell.imageView.image = [UIImage imageNamed:@"so_sms_f"];
            cell.textLabel.text = @"SMS";
            cell.tag = 2;
            break;
        case 3:
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_email_a"];
            cell.imageView.image = [UIImage imageNamed:@"so_email_f"];
            cell.textLabel.text = @"E-mail";
            cell.tag = 3;
            break;            
  /* Uncomment following for twitter following and followers list. Also to invite Facebook friends
        case 4:
            // Twitter following and followers - added case 4
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_followers_a"];
            cell.imageView.image = [UIImage imageNamed:@"so_followers_f"];
            cell.textLabel.text = @"Followers";
            cell.tag = 4;
            break;
        case 5:
            // Facebook friends - added case 5 
            cell.imageView.highlightedImage = [UIImage imageNamed:@"so_friends_a"];
            cell.imageView.image = [UIImage imageNamed:@"so_friends_f"];
            cell.textLabel.text = @"Friends";
            cell.tag = 5;
            break;
  */
        default:
            break;
    }
 
    return cell;
}
//http://stackoverflow.com/questions/11325266/open-twitter-setting-from-acaccountstore-ios-5-1-twitter
- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSInteger row = cell.tag;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (row) {
        case 0:
        {
            NSString *token = [Util getProperties:FACEBOOK];
            appDelegate.fromMail = NO;
       //Saumiya
       //if (!token) {
            
           if (token && FBSession.activeSession.isOpen){
               self.isPost = TRUE;
               [customDelegate logged:FacebookType];

            } else {
                ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
                controller.navigationItem.title = @"Service";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
        }
            break;
        case 1:
        {
            appDelegate.fromMail = NO;
            NSString *key = [Util getProperties:TWITTER_KEY];
            NSString *secret = [Util getProperties:TWITTER_SECRET];          
            
            if (!key && !secret) {
                
                ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
                controller.navigationItem.title = @"Service";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];

            } else {
                self.isPost = TRUE;
                [customDelegate logged:TwitterType];
            }
        
        }
            break;
        case 2: {            
//              New code by Bhavya
            appDelegate.fromMail = NO;
            [self sendSMS];
        }
            break;
        case 3: {
//            New code by Bhavya
            appDelegate.fromMail = YES;
            [self sendEmail];
          
        }  break;
        case 4:
        {
            // Twitter Followings and followers - added case 4
            NSString *key = [Util getProperties:TWITTER_KEY];
            NSString *secret = [Util getProperties:TWITTER_SECRET];
            
            ACAccount *accountSelected = [self getTwitterAccount];
            if(accountSelected==nil)
            {
                AppDelegate *appDelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                //    Method to retrieve the appDelgate.account
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *dataTwitterAcc = [defaults objectForKey:@"account"];
                appDelgate.account = [NSKeyedUnarchiver unarchiveObjectWithData:dataTwitterAcc];
                accountSelected = appDelgate.account;
                NSLog(@"appdelegate account is %@", appDelegate.account);
            }
            
            if (!key && !secret) {
                
                ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
                controller.navigationItem.title = @"Service";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                
            } else
            {
                [self getTwitterFriendsIdsForAccount:accountSelected];
                [self getTwitterFriendsNamesForAccount:accountSelected];
                [self getTwitterFollowersIdsForAccount:accountSelected];
                [self getTwitterFollowersNamesForAccount:accountSelected];
            } 
        } break;
        case 5:
        {
            // Facebook friends - added case 5
            NSString *token = [Util getProperties:FACEBOOK];
            if (!token ){
                ConfigureServiceViewController *controller = [[ConfigureServiceViewController alloc] init];
                controller.navigationItem.title = @"Service";
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                
            }
            else{
                [self sendRequestViaFacebook];
            }
        } break;
            
        default:
            break;
    }    
}

//Bhavya - 17th July 2013 - method to send sms. Refer ContactViewController.m class.
-(void) sendSMS
{
    Annotation *annotation = [[Annotation alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAnnotation"
                                                        object: annotation];
    NSString *url;
    if (annotation.pk) {
        url = [NSString stringWithFormat:@"cut2it://player/%@/%@", self.container.selected.pk, annotation.pk];
    } else {
        url = [NSString stringWithFormat:@"cut2it://player/%@", self.container.selected.pk];
    }
    
    SimpleIdentifier *template = [self.api loadTemplate:annotation.pk mediaId:self.container.selected.pk type:@"SMS"];
    if ([MFMessageComposeViewController canSendText] && template) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
        controller.messageComposeDelegate = self;
        //controller.recipients = infos;
        
        NSString *body = template.identifier;
        body = [body stringByReplacingOccurrencesOfString:@"$comment" withString:annotation.content];
        body = [body stringByReplacingOccurrencesOfString:@"$link" withString:url];
        
        controller.body = body;
        
        [self presentModalViewController:controller animated:YES];
        [controller release];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [annotation release];
}

//Bhavya - 11th June 2013 - method to send email. Refer ContactViewController.m class.
- (void) sendEmail
{
    Annotation *annotation = [[Annotation alloc] init];
    IsSuccessForAnnotation = TRUE;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAnnotation"
														object: annotation];
    NSString *url;

//    if (annotation.pk) {
//        url = [NSString stringWithFormat:@"cut2it.com/media.do?mediaId=%@&annotationId=%@", self.container.selected.pk, annotation.pk];
//    } else {
//        url = [NSString stringWithFormat:@"cut2it.com/media.do?mediaId=%@", self.container.selected.pk];
//    }
//    clippedVideoURL = [NSString stringWithFormat:@"<a href=\"%@\"><img src=\"%@\"></img></a>", url, self.container.selected.thumbnailUrl];
    
    if (annotation.pk) {
        url = [NSString stringWithFormat:@"cut2it://player/%@/%@", self.container.selected.pk, annotation.pk];
    } else {
        url = [NSString stringWithFormat:@"cut2it://player/%@", self.container.selected.pk];
    }

    IsSuccessForLoadTemplate = TRUE;
    emailTemplate = [self.api loadTemplate:annotation.pk mediaId:self.container.selected.pk type:@"EMAIL"];
    annotationContent = annotation.content;
    [self performSelector:@selector(showMailCompose:)
               withObject:url afterDelay:1];
}

- (void)showMailCompose:clippedURL {

    BOOL canSendMail = [MFMailComposeViewController canSendMail];
    if (canSendMail && emailTemplate.identifier != nil)
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"A cut2it video clip"];
        controller.mailComposeDelegate = self;
        
        NSString *body = emailTemplate.identifier;
        
        
        body = [body stringByReplacingOccurrencesOfString:@"$comment" withString:annotationContent];
        body = [body stringByReplacingOccurrencesOfString:@"$mobile_link" withString:clippedURL];
        body = [body stringByReplacingOccurrencesOfString:@"$user_info" withString:@""];
        
        [controller setMessageBody:body isHTML:YES];
        [self presentViewController:controller animated:YES completion:nil];
        [controller release];
    }
    else{
        NSString* error = @"Unable to send mail";
        if (emailTemplate.identifier == nil) {
            error = @"Unable to get mail templete";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

    
}

- (void) sendTestMail {
    BOOL canSendMail = [MFMailComposeViewController canSendMail];
    if (canSendMail) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"A cut2it video clip"];
        controller.mailComposeDelegate = self;
        
        NSString *body = @"<p>1:17<br/><br/>Mobile: <a href=\"cut2it.com/media.do?mediaId=ff8080814e719e60014e7dbd865b0467&startTime=77&endTime=93&Vtype=shared\"><img src=\"https://i.ytimg.com/vi/0wg4Kix2-nA/hqdefault.jpg\"></img></a><br/>Web: http://bit.ly/1NYFhUu<br/><br/><br/>Clipped by cut2it mobile</p>";
        
        [controller setMessageBody:body isHTML:YES];
        [self presentViewController:controller animated:YES completion:nil];
        [controller release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to send test mail"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

// Bhavya - 17th July 2013 - to remove the search screen for sms, the MFMessageComposeViewControllerDelegate is added in its .h file
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	NSLog(@"SMS result");
	[controller dismissModalViewControllerAnimated:YES];
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			NSLog(@"delegate - message sent");
            NSString * message=@"Message was sent successfully";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            [alert release];
			break;
		case MessageComposeResultFailed:
			NSLog(@"delegate - error");			
			break;
	}
}

// Bhavya - 11th June 2013 - to remove the search screen for email, the MFMailComposeViewControllerDelegate is added in its .h file
- (void) mailComposeController: (MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	NSLog(@"Mail result");
    UIAlertView* alert;
	[controller dismissModalViewControllerAnimated:YES];
	switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"delegate - message canceled");
            alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Send mail canceled."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
			break;
		case MFMailComposeResultSaved:
			NSLog(@"delegate - message saved");
			
			break;
		case MFMailComposeResultSent:
			NSLog(@"delegate - message sent");
			NSString * message=@"Message was sent successfully";
            alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
			break;
		case MFMailComposeResultFailed:
			NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
            break;
	}
}

// Facebook friends - send cut2it Request to the user via facebook notification
- (void)sendRequestViaFacebook{
    
    //    NSMutableDictionary* params =
    //    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://www.cut2it.com", @"link",
    //     nil];
    //
    //    // Filter and only show targeted friends
    //    if (targeted != nil && [targeted count] > 0) {
    //        NSString *selectIDsStr = [targeted componentsJoinedByString:@","];
    //        [params setObject:selectIDsStr forKey:@"suggestions"];
    //    }
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Learn how to make your iOS apps social."
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}

/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Twitter Followings
-(void)getTwitterFriendsIdsForAccount:(ACAccount*)account {
    @try {
        // In this case I am creating a dictionary for the account
        // Add the account screen name
        NSMutableDictionary *accountDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
        // Add the user id (I needed it in my case, but it's not necessary for doing the requests)
        if(account!=nil)
        {
            [accountDictionary setObject:[[[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]] objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
            // Setup the URL, as you can see it's just Twitter's own API url scheme. In this case we want to receive it in JSON
            NSURL *followingURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/friends/ids.json"];
            
            // Pass in the parameters (basically '.ids.json?screen_name=[screen_name]')
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
            // Setup the request
            TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:followingURL
                                                            parameters:parameters
                                                         requestMethod:TWRequestMethodGET];
            // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
            [twitterRequest setAccount:account];
            // Perform the request for Twitter friends
            [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error) {
                    // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
                }
                NSError *jsonError = nil;
                // Convert the response into a dictionary
                NSDictionary *twitterFriends = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&jsonError];
                // Grab the Ids that Twitter returned and add them to the dictionary we created earlier
                [accountDictionary setObject:[twitterFriends objectForKey:@"ids"] forKey:@"friends_ids"];
                NSLog(@"%@", accountDictionary);
            }];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// Twitter Followings
-(void)getTwitterFriendsNamesForAccount:(ACAccount*)account {
    @try {
        // In this case I am creating a dictionary for the account
        // Add the account screen name
        NSMutableDictionary *accountDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
        // Add the user id (I needed it in my case, but it's not necessary for doing the requests)
        if(account!=nil)
        {
            [accountDictionary setObject:[[[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]] objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
            // Setup the URL, as you can see it's just Twitter's own API url scheme. In this case we want to receive it in JSON
            NSURL *followingURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/friends/list.json"];
            
            // Pass in the parameters (basically '.ids.json?screen_name=[screen_name]')
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
            // Setup the request
            TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:followingURL
                                                            parameters:parameters
                                                         requestMethod:TWRequestMethodGET];
            // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
            [twitterRequest setAccount:account];
            // Perform the request for Twitter friends
            [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error) {
                    // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
                }
                NSError *jsonError = nil;
                // Convert the response into a dictionary
                NSDictionary *twitterFriends = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&jsonError];
                // Grab the Ids that Twitter returned and add them to the dictionary we created earlier
                [accountDictionary setObject:[twitterFriends objectForKey:@"users"] forKey:@"friends_names"];
                NSLog(@"%@", accountDictionary);
            }];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}


// Twitter followers
-(void)getTwitterFollowersIdsForAccount:(ACAccount*)account {
    @try {
        // In this case I am creating a dictionary for the account
        // Add the account screen name
        NSMutableDictionary *accountDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
        // Add the user id (I needed it in my case, but it's not necessary for doing the requests)
        if(account!=nil)
        {
            [accountDictionary setObject:[[[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]] objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
            // Setup the URL, as you can see it's just Twitter's own API url scheme. In this case we want to receive it in JSON
            NSURL *followersURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/followers/ids.json"];
            
            // Pass in the parameters (basically '.ids.json?screen_name=[screen_name]')
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
            // Setup the request
            TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:followersURL
                                                            parameters:parameters
                                                         requestMethod:TWRequestMethodGET];
            // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
            [twitterRequest setAccount:account];
            // Perform the request for Twitter friends
            [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error) {
                    // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
                }
                NSError *jsonError = nil;
                // Convert the response into a dictionary
                NSDictionary *twitterFollowers = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&jsonError];
                // Grab the Ids that Twitter returned and add them to the dictionary we created earlier
                [accountDictionary setObject:[twitterFollowers objectForKey:@"ids"] forKey:@"followers_ids"];
                NSLog(@"%@", accountDictionary);
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// Twitter followers
-(void)getTwitterFollowersNamesForAccount:(ACAccount*)account {
    @try {
        // In this case I am creating a dictionary for the account
        // Add the account screen name
        NSMutableDictionary *accountDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
        // Add the user id (I needed it in my case, but it's not necessary for doing the requests)
        if(account!=nil)
        {
            [accountDictionary setObject:[[[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]] objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
            // Setup the URL, as you can see it's just Twitter's own API url scheme. In this case we want to receive it in JSON
            NSURL *followersURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/followers/list.json"];
            
            // Pass in the parameters (basically '.ids.json?screen_name=[screen_name]')
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
            // Setup the request
            TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:followersURL
                                                            parameters:parameters
                                                         requestMethod:TWRequestMethodGET];
            // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
            [twitterRequest setAccount:account];
            // Perform the request for Twitter friends
            [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error) {
                    // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
                }
                NSError *jsonError = nil;
                // Convert the response into a dictionary
                NSDictionary *twitterFollowers = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&jsonError];
                // Grab the Ids that Twitter returned and add them to the dictionary we created earlier
                [accountDictionary setObject:[twitterFollowers objectForKey:@"users"] forKey:@"followers_names"];
                NSLog(@"%@", accountDictionary);
            }];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}



-(ACAccount *)getTwitterAccount{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ACAccount *accountSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"] ;
    if (_accountStore == nil) {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    if (_accounts == nil) {
        ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                //dispatch_sync(dispatch_get_main_queue(), ^{
                for (int i=0; i<[_accounts count]; i++) {
                    ACAccount *account1 = [_accounts objectAtIndex:i];
                    NSLog(@"account1 user is %@ and twitter username is %@ and twitter user is %@",account1.username, [Util getProperties:TWITTER_USERNAME], [Util getProperties:TWITTER_USER]);
                    // If twitter acc selected is equal to twitter acc present on device
                    if([account1.username isEqualToString:[Util getProperties:TWITTER_USER]]){
                        appDelegate.account = account1;
                        [[NSUserDefaults standardUserDefaults] setObject: appDelegate.account forKey:@"account"] ;
                    }
                    
                }
                
                // });
            }
        }];
    }
    else{
        //dispatch_syync(dispatch_get_main_queue(), ^{
        for (int i=0; i<[_accounts count]; i++) {
            ACAccount *account1 = [_accounts objectAtIndex:i];
            NSLog(@"account1 user is %@ and twitter username is %@ and twitter user is %@",account1.username, [Util getProperties:TWITTER_USERNAME], [Util getProperties:TWITTER_USER]);
            // If twitter acc selected is equal to twitter acc present on device
            if([account1.username isEqualToString:[Util getProperties:TWITTER_USER]]){
                appDelegate.account = account1;
                [[NSUserDefaults standardUserDefaults] setObject: appDelegate.account forKey:@"account"] ;
            }
        }
        
        //});
    }
    return appDelegate.account;
}


- (void) success:(BOOL) success
{
    if(success == TRUE)//&&  self.isPost == TRUE)
    {
        if(IsSuccessForAnnotation == TRUE)
        {
            IsSuccessForAnnotation = FALSE;
        }
        else if(IsSuccessForLoadTemplate == TRUE)
        {
            IsSuccessForLoadTemplate = FALSE;
        }
        else
        {
            NSLog(@"__SUCCESS");
            // Bhavya - 26th July 2013 commented the code to show the alert box with "Post was performed successfully.". It was not required.
//            
//            NSString * message=@"Post was performed successfully";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
//                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//            [alert show];
//            [alert release];
            
            self.isPost = FALSE;
        }
        
    }
    if(success == FALSE)
    {
        NSLog(@"__NOT__SUCCESS");
    }
}


@end
