//
//  PlayViewController.h
//  cut2it
//
//  Created by admin on 5/7/13.
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h> 
#import <AudioToolbox/AudioFile.h> 
#import <AudioToolbox/AudioServices.h> 
#import "RtmpLib.h"

@interface PlayViewController : UIViewController<RtmpLibDelegate>
{
    IBOutlet RtmpLib *rtmpController;
    int rtmpid;
    BOOL isFunctionCalled;
    IBOutlet UIImageView *imageView; float lastFrameTime;
    int context_id;
    NSTimer *videoTimer; NSTimeInterval startTime; UIImageView *displayImageView;
}


@end
