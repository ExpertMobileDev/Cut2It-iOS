//
//  UIImageThumbnailView.m
//  cut2it
//
//  Created by Mac on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageThumbnailView.h"

@implementation UIImageThumbnailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Called from homeViewController and videoViewController
- (void) fill:(Media *) view {
    @try {
        [self retain];
        [[Cut2itApi shared] imageThumbnail:view.thumbnailUrl delegate:self];
//      [[Cut2itApi shared] imageYouTube:view.videoId name:@"default.jpg" delegate:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void) fillAttachment:(Attachment *) attachment {
    
    [self retain];

    if(attachment.imageUrl != nil)
    {
    [[Cut2itApi shared] imageAttachment:attachment.imageUrl delegate:self];
    }
    if(attachment.thumbnailUrl)
    {
        [[Cut2itApi shared] imageAttachment:attachment.thumbnailUrl delegate:self];
    }
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    NSData *responseData = [request responseData];
    self.image = [UIImage imageWithData:responseData];
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self release];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
