//
//  CSearchView.h
//  cut2it
//
//  Created by Eugene on 8/24/12.
//
//

#import <UIKit/UIKit.h>
#import "CTextField.h"

@interface CSearchView : UIControl <UITextFieldDelegate>

@property (retain, nonatomic) NSString *text;

- (void) clear:(id) sender;
- (void) setValue:(NSString *) t;

@end
