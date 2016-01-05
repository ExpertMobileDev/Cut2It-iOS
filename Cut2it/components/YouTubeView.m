//
//  YouTubeView.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeView.h"

//BB0202: move2podproject
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"

@implementation YouTubeView

@synthesize image;
@synthesize title;
@synthesize description;
@synthesize duration;
@synthesize viewsCount;
@synthesize backImage;
@synthesize username;

- (void) fill:(Media *) view {
    @try {
        //self.title.text =[NSString stringWithFormat:@" %@ = %@",view.videoId,view.pk];//view.title;
        self.title.text = [NSString stringWithFormat:@"%@",view.title];
        
        self.description.text = view.description;
        self.duration.text = [Util timeFormat:[view.duration floatValue]];
        self.image.layer.borderWidth = 1;
        self.image.layer.borderColor = [UIColor whiteColor].CGColor;
        self.image.backgroundColor = [UIColor blackColor];
        [self.image sd_setImageWithURL:[NSURL URLWithString:view.thumbnailUrl]
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 self.image.contentMode = UIViewContentModeScaleToFill;
                                 self.image.image = image;
        }];
//        [[Cut2itApi shared] imageThumbnail:view.thumbnailUrl delegate:self];
        

        //self.image.image=[UIImage imageNamed:@"defaultTest.jpg"];
        
        // Bhavya - 08th Aug 2013
        // For each video thumbnail   
        // [[Cut2itApi shared] imageYouTube:view.videoId name:@"default.jpg" delegate:self];
        // [[Cut2itApi shared] imageThumbnail:view.thumbnailUrl delegate:self];
        
        // Bhavya - 28th Aug 2013, Here we use the new provided setImageWithURL: method to load the web image (for image lazy loading)
//        [self.image setImageWithURL:[NSURL URLWithString:view.thumbnailUrl]];
                       //placeholderImage:[UIImage imageNamed:@"defaultTest.jpg"]];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void) fillMedia:(Media *) view dutation:(NSString *) d {
    
    self.title.text = view.title;
    self.description.text = view.description;
    self.image.layer.borderWidth = 1;
    self.image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.duration.text = d;
    
    CGRect frame = self.duration.frame;
    frame.size.width = 185;
    self.duration.frame = frame;
    
    

    /*
    frame.origin.x = frame.origin.x+ frame.size.width + 50;
    frame.size.width = 200;
    frame.size.height = 21;
    username.frame = frame;
    username.text=@"Anand";
    username.backgroundColor = [UIColor redColor];
     */
    
    
}

// Called from ShareViewController
- (void) fill:(Media *) view dutation:(NSString *) d {
    @try {
        [self fillMedia:view dutation:d];
        [[Cut2itApi shared] imageThumbnail:view.thumbnailUrl delegate:self];        
//      [[Cut2itApi shared] imageYouTube:view.videoId name:@"default.jpg" delegate:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void)requestFinished:(ASIHTTPRequest *) request {
    NSData *responseData = [request responseData];
    self.image.image = [UIImage imageWithData:responseData];
}

@end
