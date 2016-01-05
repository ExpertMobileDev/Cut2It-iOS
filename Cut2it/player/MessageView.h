//
//  MessageView.h
//  cut2it
//
//  Created by Eugene on 9/5/12.
//
//

#import <UIKit/UIKit.h>
#import "Annotation.h"

@protocol MessageDelegate <NSObject>

- (void) done;
- (void) more:(Annotation *) annotation;
- (void) current:(Annotation *) annotation;

@end

@interface MessageView : UIView <UIWebViewDelegate> {
    UIButton *preview;
    UIButton *next;
    int size;
    int index;
}

@property (retain, nonatomic) UIWebView *message;
@property (retain, nonatomic) NSArray *messages;
@property (retain, nonatomic) NSString *messageTemplate;
@property (assign, nonatomic) id<MessageDelegate> delegate;

- (void) show:(NSArray *) msg;
- (void) done:(id) sender;
- (void) clear;



@end
