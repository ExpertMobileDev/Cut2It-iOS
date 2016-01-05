//
//  MessageView.m
//  cut2it
//
//  Created by Eugene on 9/5/12.
//
//

#import "MessageView.h"

@implementation MessageView

@synthesize message;
@synthesize messages;
@synthesize messageTemplate;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden =  YES;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        
        preview = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [preview setImage:[UIImage imageNamed:@"m_prev_f"] forState:UIControlStateNormal];
        [preview setImage:[UIImage imageNamed:@"m_prev_a"] forState:UIControlStateHighlighted];
        [preview setImage:[UIImage imageNamed:@"m_prev_d"] forState:UIControlStateDisabled];
        [preview addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        preview.hidden = YES;
        [self addSubview:preview];
        [preview release];
        
        
        next = [[UIButton alloc] initWithFrame:CGRectMake(390, 10, 30, 30)];
        [next setImage:[UIImage imageNamed:@"m_next_f"] forState:UIControlStateNormal];
        [next setImage:[UIImage imageNamed:@"m_next_a"] forState:UIControlStateHighlighted];
        [next setImage:[UIImage imageNamed:@"m_next_d"] forState:UIControlStateDisabled];
        [next addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        next.hidden = YES;
        [self addSubview:next];
        [next release];
        
        UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(430, 10, 30, 30)];
        [close setImage:[UIImage imageNamed:@"vm_close_f"] forState:UIControlStateNormal];
        [close setImage:[UIImage imageNamed:@"vm_close_a"] forState:UIControlStateHighlighted];
        [close addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        close.hidden = YES;
        [self addSubview:close];
        [close release];
        
        //self.message = [[UIWebView alloc] initWithFrame:CGRectMake(45, 10, 348, 30)];
        self.message = [[UIWebView alloc] initWithFrame:CGRectMake(45, 10, 348, 30)];
        self.message.opaque = NO;
        self.message.hidden = YES;
        self.message.scrollView.scrollEnabled = NO;
        self.message.backgroundColor = [UIColor clearColor];
        self.message.delegate = self;
        self.message.dataDetectorTypes = UIDataDetectorTypeNone;
        [self addSubview:self.message];
        [self.message release];
        
        self.messageTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"message" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
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

- (void) left:(UIButton *) sender {
    Annotation *current = [self.messages objectAtIndex:index];
    current.mark = NO;
    sender.enabled = --index != 0;
    
    next.enabled = index != size;
    
    Annotation *prev = [self.messages objectAtIndex:index];
    prev.mark = YES;
    [self viewMessage:prev];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

- (void) right:(UIButton *) sender {
    Annotation *current = [self.messages objectAtIndex:index];
    current.mark = NO;
    
    sender.enabled = ++index != size;
    preview.enabled = index != 0;
    
    Annotation *prev = [self.messages objectAtIndex:index];
    
    prev.mark = YES;
    [self viewMessage:prev];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        Annotation *current = [self.messages objectAtIndex:index];
        current.mark = NO;
        current.button.enabled = YES;
        
        [self close];
        
        if ([delegate respondsToSelector:@selector(more:)]) {
            [delegate more:[self.messages objectAtIndex:index]];
        }
    }
    
    return YES; 
}

- (void) done:(id) sender {
    [self clear];
    [self close];
    
    if ([delegate respondsToSelector:@selector(done)]) {
        
        [delegate done];
    }
}

- (void) clear {
    Annotation *current = [self.messages objectAtIndex:index];
    current.mark = NO;
    
    current.button.enabled = YES;
}

- (void) show:(NSArray *) msg {
    if(msg!=nil && [msg count]>0)
    {
        index = 0;
        size = [msg count] - 1;
        self.messages = msg;
        
        preview.enabled = index != 0;
        next.enabled = index != size;
        
        Annotation *prev = [self.messages objectAtIndex:index];
        prev.mark = YES;
        prev.button.enabled = NO;
        [self viewMessage:prev];
        
        CGRect frame = self.frame;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        self.hidden = NO;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = frame;
                         }
                         completion:^(BOOL finished){
                             for (UIView *view in self.subviews) {
                                 view.hidden = NO;
                             }
                             preview.hidden = size == 0;
                             next.hidden = size == 0;
                         }];

    }
}
/*
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title></title>
 </head>
 <body vlink="#0096ff" alink="#0096ff" link="#0096ff" style="margin: 0px;padding: 0px;margin-top: 0px">
 <div style="width:348px;color:white;font-size:10pt;font-family:HelveticaNeue;line-height:11pt;word-wrap: break-word;">
 <b>%@&nbsp;</b>%@<a href="#" style="text-decoration:none;">&nbsp;more ></a>
 </div>
 </body>
 </html>
 
 */

- (void) viewMessage:(Annotation *) annotation {
    //NSString *name =[NSString stringWithFormat:@"%@:", annotation.username];
    if(!annotation.lastName){
        annotation.lastName = @"";
    }
        
    NSString *name = [NSString stringWithFormat:@"%@ %@:", annotation.firstName,annotation.lastName];
    
    //NSString *name = [NSString stringWithFormat:@"%@ %@:", @"ABCD",@"EFGH"];
    int width = [name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]].width;
    
    NSString *temp = annotation.content;
    
    //to show string text from html text
    NSRange r;
    while ((r = [temp rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        temp = [temp stringByReplacingCharactersInRange:r withString:@""];

    
    NSString *text = [Util stringByTruncatingToWidth:temp width:640 - width withFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
   // NSString *text=[NSString stringWithFormat:@"%@",annotation.content];
    
    //NSString *text = annotation.content;
    name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"&#8209;"];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@"&#8209;"];
    NSString *truncatedText = nil;
    NSString *html = nil;
    
    NSLog(@"[text length]%i",[text length]);
    
    if(([text length] + [name length])>45){
        NSLog(@"([text length] + [name length])>45");
        truncatedText = [NSString stringWithFormat:@"%@...", [text substringToIndex:45 - [name length]]] ;
        NSLog(@"truncatedText:%@...",truncatedText);
        html = [NSString stringWithFormat:messageTemplate, name, truncatedText];
    }
    else if (([text length] + [name length])<=45){
        html = [NSString stringWithFormat:messageTemplate, name, text];
        NSLog(@"%@",text);
        NSLog(@"%@",html);
    }
     
    
    //NSString *str =@"<a style='color:#1cffff' href='http://www.somesite.com'>www.somesite.com</a>";    
    //[self.message loadHTMLString:[NSString stringWithFormat:@"<html><body style='background-color: transparent;font-family:Helvetica;font-size:13;color: rgb(65,75,86);'>%@</body></html>",str] baseURL:nil];
    
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<\br>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"//" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    [self.message loadHTMLString:html baseURL:nil];
    
    if ([delegate respondsToSelector:@selector(current:)]) {
        [delegate current:annotation];
    }
    
      
}

- (void) close {
    CGRect frame = self.frame;
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         self.frame = frame;
                     }];
}

- (void) dealloc {
    [message release];
    [messages release];
    [messageTemplate release];
    [super dealloc];
}

@end
