//
//  CSearchView.m
//  cut2it
//
//  Created by Eugene on 8/24/12.
//
//

#import "CSearchView.h"

@implementation CSearchView

@synthesize text;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"y_search_background"]];
        background.frame = CGRectMake(0, 0, 320, 52);
        [self addSubview:background];
        [background release];
        
        CTextField *textField = [[CTextField alloc] initWithFrame:CGRectMake(12, 12, 296, 28)];
        textField.background = [UIImage imageNamed:@"y_search_input"];
        textField.placeholder = @"search";
        textField.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        textField.textColor = [UIColor colorWithRed:179 green:179 blue:179 alpha:1];
        textField.autocorrectionType = UITextAutocorrectionTypeYes;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.borderStyle = UITextBorderStyleNone;
        textField.returnKeyType = UIReturnKeySearch;
        textField.tag = 1;
        textField.delegate = self;
        [self addSubview:textField];
        [textField release];
        
        UIImageView *left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"y_icon_magnify"]];
        textField.leftView = left;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.indent = 30;
        [left release];
        
        UIButton *right =[[UIButton alloc] initWithFrame:CGRectZero];
        [right setImage:[UIImage imageNamed:@"y_icon_cancel"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
        
        textField.rightView = right;
        textField.rightViewMode = UITextFieldViewModeAlways;
        [right release];
        
        
        textField.leftView = left;

        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) setValue:(NSString *) t {
    UITextField *field = (UITextField *) [self viewWithTag:1];
    field.text = t;
}

- (void) clear:(id) sender {
    UITextField *field = (UITextField *) [self viewWithTag:1];
    field.text = @"";
    self.text = @"";
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) sender {
    [sender resignFirstResponder];
    self.text = sender.text;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    return YES;
}

- (void) dealloc {
    [text release];
    [super dealloc];
}

@end
