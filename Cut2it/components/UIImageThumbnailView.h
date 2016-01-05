//
//  UIImageThumbnailView.h
//  cut2it
//
//  Created by Mac on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

#import "Cut2itApi.h"
#import "Media.h"
#import "Attachment.h"

@interface UIImageThumbnailView : UIImageView <ASIHTTPRequestDelegate>

- (void) fill:(Media *) view;
- (void) fillAttachment:(Attachment *) attachment;
@end
