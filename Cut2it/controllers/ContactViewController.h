//
//  ContactViewController.h
//  cut2it
//
//  Created by Eugene on 8/28/12.
//
//

#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"
#import "CSearchView.h"
#import "CTileView.h"
#import "SimpleIdentifier.h"

typedef enum {
    ContactPhone,
    ContactEmail
} ContactStyle;

@interface ContactViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    
    ABAddressBookRef addressBook;
    NSMutableArray *people;
    NSMutableArray *infos;
    float height;
}

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) CSearchView *searchBar;
@property (retain, nonatomic) NSIndexPath *selected;
@property (nonatomic) ContactStyle style;

- (void) search:(CSearchView *) search;
- (void) done:(id) sender;

@end
