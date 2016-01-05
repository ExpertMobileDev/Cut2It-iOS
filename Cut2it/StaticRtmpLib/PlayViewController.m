//
//  PlayViewController.m
//  cut2it
//
//  Created by admin on 5/7/13.
//
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    rtmpController = [[RtmpLib alloc]init];
    rtmpController.delegate=self;
}

//-(void)callRtmpMain{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString* docDir = [paths objectAtIndex:0];
//    NSString* resources = [docDir stringByAppendingString:@"/initFile.flv"];
//    
//    rtmpid=[rtmpController getRtmpStreamId];
//    [[rtmpController callRtmpStream :[NSString stringWithString:connectUrl] outputUrl NSString              stringWithString:resources] rtmpId: rtmpid];
//     
//     
//}
//
//-(IBAction)getStreamInfo{
//    rtmpStreamInfo streamInfo;
//    streamInfo=[rtmpController getRtmpStreamInfo:rtmpid];
//}
//
//-(void)onStatusReceived:(NSString *)status {
//    NSLog(@"<-----Application Call Back--%@-->",status);
//    [self performSelectorOnMainThread:@selector(displayImageViewMethod) withObject:nil waitUntilDone:NO];
//}
//
//-(void)gotData:(char *)rtmpData dataSize:(long)dataSize channel:(short)channel sampleRate:(short)sample_rate sampleSize:(short)sample_size audioFormat: (int)format;
//{
//    aqc.sampleLen+=dataSize;
//    memcpy(pcmdata+write_offset, rtmpData, dataSize);
//    if(!isFunctionCalled)
//    {
//        if(write_offset >10560000) {
//            isFunctionCalled=YES;
//            playBuffer1(argStruct);
//            [self performSelectorOnMainThread:@selector(callGotDataMethod)withObject:self waitUntilDone:NO];
//        }
//    }
//    write_offset+=dataSize;
//}
//
//-(void)callMethodInTread {
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
//    [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(callRtmpGetVideoPacket) userInfo:nil repeats:YES]; [pool release];
//}
//
//-(void)callRtmpGetVideoPacket {
//    [rtmpController setSpinFlag];
//    [rtmpController getVideoDataFromQueue];
//}
//
//-(void)gotVideoData:(char *)data dataSize:(long)dataSize
//{
//    //NSLog(@"\n------Application Video Call Back------>\n");
//    static int count =0;
//    NSData *tempData=[NSData dataWithBytes:data length:320*480*3];
//    [self performSelectorOnMainThread:@selector(displayVideo:)withObject:tempData waitUntilDone:NO];
//    count++;
//}
//
//-(IBAction)displayVideo:(NSData *)tempData {
//    if(tempData!=nil)
//    {
//        UIImage *tempImage=(UIImage *)[self imageWithRawRGBAData1:tempData width:320 height:480];
//        if (tempImage !=nil) {
//            imageView.image=tempImage;
//        }
//    }
//}

                            
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
