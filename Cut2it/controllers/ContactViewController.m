//
//  ContactViewController.m
//  cut2it
//
//  Created by Eugene on 8/28/12.
//
//

#import "ContactViewController.h"

NSInteger const ROW_HEIGHT = 42;

NSInteger const NAME_TAG = 101;
NSInteger const IMAGE_TAG = 102;
NSInteger const CONTACT_TAG = 103;
NSInteger const MAIN_CHECK_TAG = 104;
NSInteger const LABLE_TAG = 201;
NSInteger const VALUE_TAG = 202;
NSInteger const CHECK_TAG = 203;

@implementation ContactViewController

@synthesize table;
@synthesize searchBar;
@synthesize selected;
@synthesize style;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
        UIBarButtonItem *done = [self createBarButtonWithName:@"Done" image:@"rounded" width:68 target:self action:@selector(done:)];
        
        self.navigationItem.leftBarButtonItem = back;
        self.navigationItem.rightBarButtonItem = done;
        
        [back release];
        [done release];
        
        self.searchBar = [[CSearchView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
        [self.searchBar addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.searchBar];
        [self.searchBar release];
        
        CFErrorRef error = nil;
        if ([Util isIOS5]) {
            addressBook = ABAddressBookCreate();
        } else {
            addressBook = ABAddressBookCreateWithOptions(NULL,&error);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }
        infos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    [people release];
    
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    people =  (NSMutableArray*) ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    [self filtered:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) search:(CSearchView *) search {
    if (self.selected) {
        UITableViewCell *cell = [table cellForRowAtIndexPath:self.selected];
        cell.selected = NO;
        UIView *contact = [cell viewWithTag:CONTACT_TAG];
        contact.alpha = 0;
        self.selected = nil;
    }
    
    [people release];
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    people =  (NSMutableArray*) ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
    
    [self filtered:search.text];
    [table reloadData];
}

- (void) filtered:(NSString *) name {
    int size = [people count];
    for ( NSUInteger i=0; i < size; i++ ) {
        ABRecordRef person = (ABRecordRef)[people objectAtIndex:i];
        NSString *fullname = (NSString * )ABRecordCopyCompositeName(person);
        
        ABMutableMultiValueRef items;
        if (style == ContactPhone) {
            items = ABRecordCopyValue(person, kABPersonPhoneProperty);
        } else if (style == ContactEmail) {
            items = ABRecordCopyValue(person, kABPersonEmailProperty);
        }
        
        CFIndex count = ABMultiValueGetCount(items);
        CFRelease(items);
        
        if (count == 0 || (![Util isEmpty:name] && [[fullname lowercaseString] rangeOfString:name].location == NSNotFound)) {
            [people removeObjectAtIndex:i];
            i--;
            size--;
        }
        //CFRelease(fullname);
    }
}

#pragma mark Table Data Source

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [people count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath isEqual:selected] ? height : ROW_HEIGHT;
}


- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *name;
    UIImageView *image;
    UIView *contact;
    
    ABRecordRef person = [people objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ContactCell"];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
        image.layer.borderWidth = 1;
        image.layer.borderColor = [UIColor blackColor].CGColor;
        image.layer.cornerRadius = 2;
        image.layer.shadowColor = [UIColor colorWithRed:85 green:85 blue:85 alpha:1].CGColor;
        image.layer.shadowOffset = CGSizeMake(0, 1);
        image.layer.masksToBounds = YES;
        image.tag = IMAGE_TAG;
        [cell  addSubview:image];
        [image release];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 300, 30)];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        name.tag = NAME_TAG;
        [cell addSubview:name];
        [name  release];
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_backgroundpattern_f"]];
        cell.backgroundView = background;
        [background release];
        
        UIView *select = [[CTileView alloc] initWithFrame:CGRectMake(0, 0, 320, ROW_HEIGHT) image:[UIImage imageNamed:@"c_backgroundpattern_a"]];
        cell.selectedBackgroundView = select;
        [select release];
        
        UIImageView *maincheck = [[UIImageView alloc] initWithFrame:CGRectMake(293, 14, 12, 14)];
        maincheck.image = [UIImage imageNamed:@"c_checkmark"];
        maincheck.hidden = YES;
        maincheck.tag = MAIN_CHECK_TAG;
        [cell addSubview:maincheck];
        [maincheck release];
        
        contact = [[UIView alloc] initWithFrame:CGRectMake(0, ROW_HEIGHT, 320, 0)];
        contact.backgroundColor = [UIColor clearColor];
        contact.tag = CONTACT_TAG;
        contact.alpha = 0;
        [cell addSubview:contact];
        [contact release];
    } else {
        name = (UILabel *) [cell viewWithTag:NAME_TAG];
        image = (UIImageView *) [cell viewWithTag:IMAGE_TAG];
        contact = [cell viewWithTag:CONTACT_TAG];
    }
    
    for (UIView *view in [contact subviews]) {
        [view removeFromSuperview];
    }
    
    CFStringRef fullname = ABRecordCopyCompositeName(person);
    name.text = (NSString *) fullname;
    //CFRelease(fullname);
    
    CFDataRef imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    if (imageData) {
        image.image = [UIImage imageWithData:(NSData *) imageData];
        CFRelease(imageData);
    } else {
        image.image = [UIImage imageNamed:@"c_avatar"];
    }
    
    
    ABMutableMultiValueRef items;
    if (style == ContactPhone) {
        items = ABRecordCopyValue(person, kABPersonPhoneProperty);
    } else if (style == ContactEmail){
        items = ABRecordCopyValue(person, kABPersonEmailProperty);
    }
    
    CFIndex count = ABMultiValueGetCount(items);
    for (NSUInteger i=0; i < count; i++ ) {
        CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(items, i);
        CFStringRef phoneValue = ABMultiValueCopyValueAtIndex(items, i);
        CFStringRef phoneLocalizedLabel = ABAddressBookCopyLocalizedLabel( phoneLabel);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, 74, ROW_HEIGHT)];
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lable.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        lable.textAlignment = UITextAlignmentRight;
        lable.adjustsFontSizeToFitWidth = YES;
        lable.minimumFontSize = 12;
        lable.text = (NSString *) phoneLocalizedLabel;
        lable.tag = LABLE_TAG;
        
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(124, 0, 168, ROW_HEIGHT)];
        value.backgroundColor = [UIColor clearColor];
        value.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        value.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        value.adjustsFontSizeToFitWidth = YES;
        value.minimumFontSize = 12;
        value.text = (NSString *) phoneValue;
        value.tag = VALUE_TAG;
        
        UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(293, 14, 12, 14)];
        check.image = [UIImage imageNamed:@"c_checkmark"];
        check.hidden = YES;
        check.tag = CHECK_TAG;
        
        UIButton *number = [[UIButton alloc] initWithFrame:CGRectMake(0, ROW_HEIGHT * i, 320, ROW_HEIGHT)];
        number.selected = YES;
        [number addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [number addSubview:lable];
        [number addSubview:value];
        [number addSubview:check];
        
        if (i == 0) {
            UIView *footer = [[CTileView alloc] initWithFrame:CGRectMake(0, 0, 320, 1) image:[UIImage imageNamed:@"c_separator_secondary"]];
            [number addSubview:footer];
            [footer release];
        }
        
        if (i != count-1) {
            UIView *secondry = [[CTileView alloc] initWithFrame:CGRectMake(0, ROW_HEIGHT - 1, 320, 1) image:[UIImage imageNamed:@"c_separator_secondary"]];
            [number addSubview:secondry];
            [secondry release];
        }
        
        [contact addSubview:number];
        [number release];
        [lable release];
        [value release];
        [check release];
        
        CFRelease(phoneLocalizedLabel);
        CFRelease(phoneLabel);
        CFRelease(phoneValue);
    }
    CFRelease(items);
    
    CGRect frame = contact.frame;
    frame.size.height = ROW_HEIGHT * count;
    contact.frame = frame;
    
    return cell;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    
    self.selected = indexPath;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *contact = [cell viewWithTag:CONTACT_TAG];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = cell.frame;
                         frame.size.height = ROW_HEIGHT + contact.frame.size.height;
                         height = frame.size.height;
                         cell.frame = frame;
                         contact.alpha = 1;
                         [cell.selectedBackgroundView setNeedsDisplay];
                     }
                     completion:^(BOOL finished){
                         [tableView endUpdates];
                     }];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *contact = [cell viewWithTag:CONTACT_TAG];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = cell.frame;
                         frame.size.height = ROW_HEIGHT;
                         height = frame.size.height;
                         cell.frame = frame;
                         contact.alpha = 0;
                         [cell.selectedBackgroundView setNeedsDisplay];
                     }
                     completion:^(BOOL finished){
                         [tableView endUpdates];
                     }];
}

- (void) selected:(UIButton *) sender {
    BOOL select = sender.selected;
    UILabel *lable = (UILabel *) [sender viewWithTag:LABLE_TAG];
    UILabel *value = (UILabel *) [sender viewWithTag:VALUE_TAG];
    UIImageView *check = (UIImageView *) [sender viewWithTag:CHECK_TAG];
    if (select) {
        check.hidden = NO;
        lable.textColor = [UIColor whiteColor];
        value.textColor = [UIColor whiteColor];
        [infos addObject:value.text];
    } else {
        check.hidden = YES;
        lable.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        value.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [infos removeObject:value.text];
    }
    
    sender.selected = !select;
    
    UIView *contscts = [sender superview];
    UIView *cell = [contscts superview];
    UILabel *name = (UILabel *) [cell viewWithTag:NAME_TAG];
    UIImageView *maincheck = (UIImageView *) [cell viewWithTag:MAIN_CHECK_TAG];
    
    name.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    maincheck.hidden = YES;
    
    for (UIButton *button in [contscts subviews]) {
        if (!button.selected) {
            name.textColor = [UIColor whiteColor];
            maincheck.hidden = NO;
        }
    }
}

- (void) done:(id) sender {
    Annotation *annotation = [[Annotation alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAnnotation"
														object: annotation];
    NSString *url;
    if (annotation.pk) {
        url = [NSString stringWithFormat:@"cut2it://player/%@/%@", self.container.selected.pk, annotation.pk];
    } else {
        url = [NSString stringWithFormat:@"cut2it://player/%@", self.container.selected.pk];
    }
    
    if (style == ContactPhone) {
        SimpleIdentifier *template = [self.api loadTemplate:annotation.pk mediaId:self.container.selected.pk type:@"SMS"];
        if ([MFMessageComposeViewController canSendText] && template) {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
            controller.messageComposeDelegate = self;
            controller.recipients = infos;
            
            
            NSString *body = template.identifier;
            body = [body stringByReplacingOccurrencesOfString:@"$comment" withString:annotation.content];
            body = [body stringByReplacingOccurrencesOfString:@"$link" withString:url];
            
            controller.body = body;
            
            [self presentModalViewController:controller animated:YES];
            [controller release];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    } else if (style == ContactEmail) {
        SimpleIdentifier *template = [self.api loadTemplate:annotation.pk mediaId:self.container.selected.pk type:@"EMAIL"];
        if ([MFMailComposeViewController canSendMail] && template)
        {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            [controller setSubject:@"a cut2it video clip"];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:infos];
            
            NSString *body = template.identifier;         
            
            body = [body stringByReplacingOccurrencesOfString:@"$comment" withString:annotation.content]; 
            body = [body stringByReplacingOccurrencesOfString:@"$mobile_link" withString:url];
            body = [body stringByReplacingOccurrencesOfString:@"$user_info" withString:@""];
            
            [controller setMessageBody:body isHTML:YES];
            //[controller addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"image.png"];
            
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Not able to share." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    [annotation release];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	NSLog(@"SMS result");
	[controller dismissModalViewControllerAnimated:YES];
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			NSLog(@"delegate - message sent");
			
			break;
		case MessageComposeResultFailed:
			NSLog(@"delegate - error");
			
			break;
	}
}

- (void) mailComposeController: (MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	NSLog(@"Mail result");
	[controller dismissModalViewControllerAnimated:YES];
	switch (result) {
		case MFMailComposeResultCancelled:
			
			break;
		case MFMailComposeResultSaved:
			NSLog(@"delegate - message saved");
			
			break;
		case MFMailComposeResultSent:
			NSLog(@"delegate - message sent");
			
			break;
		case MFMailComposeResultFailed:
			NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
            break;
	}
}

- (void)dealloc {
    [searchBar release];
    [people release];
    [selected release];
    [infos release];
    if(addressBook)
    {
    CFRelease(addressBook);
    }
    [super dealloc];
}

@end
