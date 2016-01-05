//
//  TwitterConnect.h
//  Twitter
//
//  Created by Eugene 
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TwitterDialogDelegate;

@interface TwitterDialog : UIView <UIWebViewDelegate> {
	id<TwitterDialogDelegate> _delegate;
	
	NSMutableDictionary *_params;
	NSString * _serverURL;
	NSURL* _loadingURL;
	UIWebView* _webView;
	UIActivityIndicatorView* _spinner;
	UIImageView* _iconView;
	UILabel* _titleLabel;
	UIButton* _closeButton;
	UIDeviceOrientation _orientation;
	BOOL _showingKeyboard;
	BOOL _firstLoad;
	
	// Ensures that UI elements behind the dialog are disabled.
	UIView* _modalBackgroundView;
	NSURLRequest *_request;		
}

@property(nonatomic, assign) id<TwitterDialogDelegate> delegate;
@property(nonatomic, retain) NSMutableDictionary* params;
@property(nonatomic, copy) NSString* title;

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle;

- (id)initWithURL: (NSString *) loadingURL
           params: (NSMutableDictionary *) params
         delegate: (id <TwitterDialogDelegate>) delegate;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate;

- (void)show;
- (void)load;

- (void)loadURL:(NSString*)url
            get:(NSDictionary*)getParams;
- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;
- (void)dialogDidSucceed:(NSURL *)url;
- (void)dialogDidCancel:(NSURL *)url;
- (NSString *)locateAuthPinInWebView:(UIWebView *)webView;

@end

@protocol TwitterDialogDelegate <UIWebViewDelegate>

@optional
- (void) requestAccessToken;
- (void) onCloseDialog;

@end
