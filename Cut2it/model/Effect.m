//
//  Effect.m
//  cut2it
//
//  Created by Eugene on 10/24/12.
//
//

/*
 CICrystallize
 CIDepthOfField
 CIEdges
 CIEdgeWork
 CIFalseColor
 CIHighlightShadowAdjust
 CILineOverlay
 CIPixellate
 CIToneCurve
 CIUnsharpMask
 CIVignette
 CIVibrance
 */

#import "Effect.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@implementation Effect

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        sepiaTone = [CIFilter filterWithName:@"CISepiaTone"];
        [sepiaTone setDefaults];
        [sepiaTone setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
        
        hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
        [hueAdjust setDefaults];
        [hueAdjust setValue: [NSNumber numberWithFloat: 2.094] forKey: @"inputAngle"];
        
        pinchDistortion = [CIFilter filterWithName:@"CIPinchDistortion"];
        [pinchDistortion setDefaults];
        
        CIFilter* greenGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        CIColor* green = [CIColor colorWithRed:0.30 green:0.596 blue:0.172];
        [greenGenerator setValue:green forKey:@"inputColor"];
        CIImage* greenImage = [greenGenerator valueForKey:@"outputImage"];
        
        multiplyCompositing = [CIFilter filterWithName:@"CIMultiplyCompositing"];
        [multiplyCompositing setValue:greenImage forKey:@"inputBackgroundImage"];
        
        bloom = [CIFilter filterWithName:@"CIBloom"];
        [bloom setValue:[NSNumber numberWithFloat:1] forKey:@"inputRadius"];
        [bloom setValue:[NSNumber numberWithFloat:5] forKey:@"inputIntensity"];
        
        colorControls = [CIFilter filterWithName:@"CIColorControls"];
        [colorControls setValue:[NSNumber numberWithFloat:2] forKey:@"inputSaturation"];
        [colorControls setValue:[NSNumber numberWithFloat:0] forKey:@"inputBrightness"];
        [colorControls setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputContrast"];
        
        colorInvert = [CIFilter filterWithName:@"CIColorInvert"];
        
        colorPosterize = [CIFilter filterWithName:@"CIColorPosterize"];
        [colorPosterize setValue:[NSNumber numberWithFloat:10] forKey:@"inputLevels"];
        
        filters = [[NSArray arrayWithObjects:sepiaTone, sepiaTone, hueAdjust, pinchDistortion, multiplyCompositing,bloom,colorControls,colorInvert, colorPosterize, nil] retain];
    }
    return self;
}

- (void) start {
    [self wathermark1];
}

- (void) wathermark {
 NSURL *inputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/sample3.mov"]]];
    [self effect:inputURL
      videoLayer:^(CALayer *layer){
          CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
          positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
          positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
          positionAnimation.removedOnCompletion = NO;
          positionAnimation.beginTime = 4.5;
          positionAnimation.duration = 2.0;
          
          CABasicAnimation *resize = [CABasicAnimation animationWithKeyPath:@"bounds"];
          resize.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 360, 480)];
          resize.toValue = [NSValue valueWithCGRect:CGRectMake(0,0,100, 100)];
          resize.removedOnCompletion = NO;
          resize.beginTime = 3.5;
          resize.duration = 1.0;
          resize.fillMode = kCAFillModeBoth;
          
          [layer addAnimation:resize forKey:nil];
          [layer addAnimation:positionAnimation forKey:nil];
      }
     parentLayer:^(CALayer *layer){
         /*CATextLayer *titleLayer = [CATextLayer layer];
         titleLayer.string = @"TESt";
         titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
         titleLayer.font = (void*)[UIFont fontWithName:@"Helvetica" size:assetVideoTrack.naturalSize.height/4] ;
         titleLayer.shadowOpacity = 0.5;
         titleLayer.alignmentMode = kCAAlignmentCenter;
         titleLayer.bounds = CGRectMake(0, 0, assetVideoTrack.naturalSize.width/2, assetVideoTrack.naturalSize.height/2);*/
         
         UIImage *myImage = [UIImage imageNamed:@"vm_gray"];
         layer.frame = CGRectMake(100, 100, 100, 100);
         layer.contents = (id)myImage.CGImage ;
         layer.opacity = 0.5;
     }];
}

- (void) wathermark1 {
    NSURL *inputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/sample3.mov"]]];
    [self effect:inputURL
      videoLayer:^(CALayer *layer){
          /*CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
          positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
          positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
          positionAnimation.removedOnCompletion = NO;
          positionAnimation.beginTime = 1.5;
          positionAnimation.duration = 2.0;
          
          [layer addAnimation:positionAnimation forKey:nil];*/
          
          /*CABasicAnimation *resize = [CABasicAnimation animationWithKeyPath:@"bounds"];
          resize.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 360, 480)];
          resize.toValue = [NSValue valueWithCGRect:CGRectMake(0,0,100, 100)];
          resize.removedOnCompletion = NO;
          resize.beginTime = 3.5;
          resize.duration = 1.0;
          resize.fillMode = kCAFillModeBoth;
          
          [layer addAnimation:resize forKey:nil];*/
          

    }
     parentLayer:^(CALayer *layer){
         /*CATextLayer *titleLayer = [CATextLayer layer];
          titleLayer.string = @"TESt";
          titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
          titleLayer.font = (void*)[UIFont fontWithName:@"Helvetica" size:assetVideoTrack.naturalSize.height/4] ;
          titleLayer.shadowOpacity = 0.5;
          titleLayer.alignmentMode = kCAAlignmentCenter;
          titleLayer.bounds = CGRectMake(0, 0, assetVideoTrack.naturalSize.width/2, assetVideoTrack.naturalSize.height/2);*/
         layer.bounds = CGRectMake(0, 0, 200, 200);
         layer.backgroundColor = [UIColor whiteColor].CGColor;
         layer.filters = [NSArray arrayWithObject:sepiaTone];
    }];
}


- (void) effect:(NSURL *) url videoLayer:(void(^)(CALayer *layer)) vLayer parentLayer:(void(^)(CALayer *layer)) pLayer {
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    AVAssetTrack *assetVideoTrack = nil;
	AVAssetTrack *assetAudioTrack = nil;
	
	if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
		assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
	}
	if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
		assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
	}

	NSError *error = nil;
	
	double halfDuration = CMTimeGetSeconds([asset duration]);
	CMTime trimmedDuration = CMTimeMakeWithSeconds(halfDuration, 1);
	
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    
    if(assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDuration) ofTrack:assetVideoTrack atTime:kCMTimeZero error:&error];
    }
    if(assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDuration) ofTrack:assetAudioTrack atTime:kCMTimeZero error:&error];
    }
	
	CGAffineTransform t2 = CGAffineTransformRotate(CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0.0), degreesToRadians(90.0));
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.renderSize = CGSizeMake(assetVideoTrack.naturalSize.height,assetVideoTrack.naturalSize.width);
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mutableComposition duration]);
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:(mutableComposition.tracks)[0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
      
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    
    CALayer *effectLayer = [CALayer layer];
    vLayer(videoLayer);
    pLayer(effectLayer);
    
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:effectLayer];

    mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    instruction.layerInstructions = @[layerInstruction];
    mutableVideoComposition.instructions = @[instruction];
    
    NSString *outputVideo = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Output.mov"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:outputVideo]) {
        [fileManager removeItemAtPath:outputVideo error:nil];
    }
    
    NSURL *outputURL = [NSURL fileURLWithPath:outputVideo];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetMediumQuality];
    session.videoComposition = mutableVideoComposition;
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    
    [session exportAsynchronouslyWithCompletionHandler:^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Export Finished: %@", session.error);

            if (session.error) {
                [[NSFileManager defaultManager] removeItemAtPath:outputVideo error:NULL];
            }
        });
    }];
    [session release];
}

- (int) countEffects {
    return filters.count;
}

- (UIImage *) effectImage:(UIImage *) image atIndex:(int) index {
    CIFilter *filter = [filters objectAtIndex:index];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
    return [UIImage imageWithCIImage:filter.outputImage];
}

- (void) applyFilter:(NSURL *) url atIndex:(int) index {
    CIFilter *filter = [filters objectAtIndex:index];
    
    [self modifyVideo:url
               filter:^(CIImage *image) {
                   [filter setValue:image forKey:@"inputImage"];
                   return filter.outputImage;
               }
               output:^(NSURL *url) {
                   if ([delegate respondsToSelector:@selector(finish:index:)]) {
                       [delegate finish:url index:index];
                   }
               }];
}

- (void) generateImage:(NSURL *) url handle:(void(^)(UIImage *url)) handle {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];;
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        handle ([UIImage imageWithCGImage:im]);
        [generator release];
    };
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
}

- (void) modifyVideo:(NSURL *) url filter:(CIImage *(^)(CIImage *image)) handler output:(void(^)(NSURL *url)) output {
    NSString *tempVideo = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/video_tack_out.mov"]];
    NSURL *tempURL = [NSURL fileURLWithPath:tempVideo];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:tempVideo]) {
        [fileManager removeItemAtPath:tempVideo error:nil];
    }
    
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetTrack *assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
        dispatch_queue_t queue = dispatch_queue_create("video_queue", NULL);
        dispatch_async(queue, ^{
            if (!imageContext) {
                imageContext = [[CIContext contextWithOptions:nil] retain];
            }
            
            NSError *error;
            movieReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
            if (error) NSLog(@"%@",error.localizedDescription);
            
            NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
            NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
            NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
            [movieReader addOutput:[AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetVideoTrack outputSettings:videoSettings]];
            [movieReader startReading];
            
            videoWriter = [[AVAssetWriter alloc] initWithURL:tempURL
                                                    fileType:AVFileTypeQuickTimeMovie
                                                       error:&error];
            NSParameterAssert(videoWriter);
            
            NSDictionary *writerSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                            AVVideoCodecH264, AVVideoCodecKey,
                                            [NSNumber numberWithInt:assetVideoTrack.naturalSize.width], AVVideoWidthKey,
                                            [NSNumber numberWithInt:assetVideoTrack.naturalSize.height], AVVideoHeightKey,
                                            nil];
            AVAssetWriterInput *writerInput = [[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                                  outputSettings:writerSettings] retain];
            
            NSParameterAssert(writerInput);
            NSParameterAssert([videoWriter canAddInput:writerInput]);
            [videoWriter addInput:writerInput];
            videoWriter.shouldOptimizeForNetworkUse = NO;
            [videoWriter startWriting];
            [videoWriter startSessionAtSourceTime:kCMTimeZero];
            
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                     [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                     nil];
            
            while (movieReader.status == AVAssetReaderStatusReading) {
                AVAssetReaderTrackOutput *outputTrack = [movieReader.outputs objectAtIndex:0];
                CMSampleBufferRef sampleBuffer = [outputTrack copyNextSampleBuffer];
                if (sampleBuffer) {
                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    CVPixelBufferLockBaseAddress(imageBuffer,0);
                    
                    CMSampleTimingInfo timimgInfo = kCMTimingInfoInvalid;
                    CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &timimgInfo);
                    
                    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
                    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                    size_t width = CVPixelBufferGetWidth(imageBuffer);
                    size_t height = CVPixelBufferGetHeight(imageBuffer);
                    
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                    
                    CGImageRef	imageRef = CGBitmapContextCreateImage(newContext);
                    CIImage *image = [CIImage imageWithCGImage:imageRef];
                    image = handler(image);
                    
                    CGImageRef outputImage = [imageContext createCGImage:image fromRect:image.extent];
                    
                    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
                    
                    CVPixelBufferRef buffer = [self pixelBufferFromCGImage:outputImage size:CGSizeMake(width, height) options:options];
                    
                    CMVideoFormatDescriptionRef videoInfo;
                    CMVideoFormatDescriptionCreateForImageBuffer(NULL, buffer, &videoInfo);
                    
                    CMSampleBufferRef myBuffer;
                    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, buffer, true, NULL, NULL, videoInfo, &timimgInfo, &myBuffer);
                    
                    while (!writerInput.readyForMoreMediaData && videoWriter.status != AVAssetWriterStatusCancelled)
                        [NSThread sleepForTimeInterval:0.001];
                    
                    [writerInput appendSampleBuffer:myBuffer];
                    
                    CGImageRelease(outputImage);
                    CGImageRelease(imageRef);
                    CFRelease(buffer);
                    CFRelease(videoInfo);
                    CFRelease(myBuffer);
                    
                    CGContextRelease(newContext);
                    CGColorSpaceRelease(colorSpace);
                    CFRelease(sampleBuffer);
                }
            }
            
            if (videoWriter.status != AVAssetWriterStatusCancelled) {
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler: ^{
                    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
                    
                    AVURLAsset *assetOutput = [AVURLAsset URLAssetWithURL:tempURL options:nil];
                    AVAssetTrack *outputVideoTrack = [assetOutput tracksWithMediaType:AVMediaTypeVideo][0];
                    
                    NSError *error;
                    
                    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
                        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
                        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:outputVideoTrack atTime:kCMTimeZero error:&error];
                    }
                    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
                        AVAssetTrack *assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
                        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:kCMTimeZero error:&error];
                    }
                    
                    
                    CGAffineTransform t2 = CGAffineTransformRotate(CGAffineTransformMakeTranslation(outputVideoTrack.naturalSize.height, 0.0), degreesToRadians(90.0));
                    
                    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
                    mutableVideoComposition.renderSize = CGSizeMake(outputVideoTrack.naturalSize.height, outputVideoTrack.naturalSize.width);
                    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
                    
                    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
                    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, assetOutput.duration);
                    
                    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:outputVideoTrack];
                    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
                    
                    instruction.layerInstructions = @[layerInstruction];
                    mutableVideoComposition.instructions = @[instruction];
                    
                    
                    NSString *outputVideo = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Output.mov"]];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if([fileManager fileExistsAtPath:outputVideo]) {
                        [fileManager removeItemAtPath:outputVideo error:nil];
                    }
                    
                    NSURL *outputURL = [NSURL fileURLWithPath:outputVideo];
                    
                    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetMediumQuality];
                    session.videoComposition = mutableVideoComposition;
                    session.outputURL = outputURL;
                    session.outputFileType = AVFileTypeQuickTimeMovie;
                    
                    [session exportAsynchronouslyWithCompletionHandler:^ {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Export Finished: %@", session.error);
                            if([fileManager fileExistsAtPath:tempVideo]) {
                                [fileManager removeItemAtPath:tempVideo error:nil];
                            }
                            
                            output(outputURL);
                            
                            if (session.error) {
                                [[NSFileManager defaultManager] removeItemAtPath:outputVideo error:NULL];
                            }
                        });
                    }];
                    [session release];
                }];
            }
            
            [movieReader release];
            [videoWriter release];
            [writerInput release];
            dispatch_release(queue);
        });
    }];
}

- (void) cancel {
    if (movieReader.status == AVAssetReaderStatusReading) {
        [movieReader cancelReading];
        [videoWriter cancelWriting];
    }
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image  size:(CGSize) size options:(NSDictionary *) options {
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
                                          &pxbuffer);
    if (status == kCVReturnSuccess && pxbuffer) {
        CVPixelBufferLockBaseAddress(pxbuffer, 0);
        void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
        NSParameterAssert(pxdata);
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                     size.height, 8, 4*size.width, rgbColorSpace,
                                                     kCGImageAlphaNoneSkipFirst);
        NSParameterAssert(context);
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image);
        CGColorSpaceRelease(rgbColorSpace);
        CGContextRelease(context);
        
        CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    }
    return pxbuffer;
}

-(void)resizeVideo:(NSString*)pathy {
    NSString *newName = [pathy stringByAppendingString:@".down.mov"];
    NSURL *fullPath = [NSURL fileURLWithPath:newName];
    NSURL *path = [NSURL fileURLWithPath:pathy];
    
    
    NSLog(@"Write Started");
    
    NSError *error = nil;
    
    AVAssetWriter *videoWriter1 = [[AVAssetWriter alloc] initWithURL:fullPath fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter1);
    AVAsset *avAsset = [[[AVURLAsset alloc] initWithURL:path options:nil] autorelease];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:1280], AVVideoWidthKey,
                                   [NSNumber numberWithInt:720], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* videoWriterInput = [[AVAssetWriterInput
                                             assetWriterInputWithMediaType:AVMediaTypeVideo
                                             outputSettings:videoSettings] retain];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter1 canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter1 addInput:videoWriterInput];
    NSError *aerror = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:avAsset error:&aerror];
    AVAssetTrack *videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    videoWriterInput.transform = videoTrack.preferredTransform;
    NSDictionary *videoOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *asset_reader_output = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOptions];
    [reader addOutput:asset_reader_output];
    //audio setup
    
    AVAssetWriterInput* audioWriterInput = [[AVAssetWriterInput
                                             assetWriterInputWithMediaType:AVMediaTypeAudio
                                             outputSettings:nil] retain];
    AVAssetReader *audioReader = [[AVAssetReader assetReaderWithAsset:avAsset error:&error] retain];
    AVAssetTrack* audioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVAssetReaderOutput *readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
    
    [audioReader addOutput:readerOutput];
    NSParameterAssert(audioWriterInput);
    NSParameterAssert([videoWriter1 canAddInput:audioWriterInput]);
    audioWriterInput.expectsMediaDataInRealTime = NO;
    [videoWriter1 addInput:audioWriterInput];
    [videoWriter1 startWriting];
    [videoWriter1 startSessionAtSourceTime:kCMTimeZero];
    [reader startReading];
    dispatch_queue_t _processingQueue = dispatch_queue_create("assetAudioWriterQueue", NULL);
    [videoWriterInput requestMediaDataWhenReadyOnQueue:_processingQueue usingBlock:^{
        [self retain];
        while ([videoWriterInput isReadyForMoreMediaData]) {
            CMSampleBufferRef sampleBuffer;
            if ([reader status] == AVAssetReaderStatusReading &&
                (sampleBuffer = [asset_reader_output copyNextSampleBuffer])) {
                
                BOOL result = [videoWriterInput appendSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
                
                if (!result) {
                    [reader cancelReading];
                    break;
                }
            } else {
                [videoWriterInput markAsFinished];
                
                switch ([reader status]) {
                    case AVAssetReaderStatusReading:
                        // the reader has more for other tracks, even if this one is done
                        break;
                        
                    case AVAssetReaderStatusCompleted:
                        // your method for when the conversion is done
                        // should call finishWriting on the writer
                        //hook up audio track
                        [audioReader startReading];
                        [videoWriter1 startSessionAtSourceTime:kCMTimeZero];
                        dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
                        [audioWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^
                         {
                             NSLog(@"Request");
                             NSLog(@"Asset Writer ready :%d",audioWriterInput.readyForMoreMediaData);
                             while (audioWriterInput.readyForMoreMediaData) {
                                 CMSampleBufferRef nextBuffer;
                                 if ([audioReader status] == AVAssetReaderStatusReading &&
                                     (nextBuffer = [readerOutput copyNextSampleBuffer])) {
                                     NSLog(@"Ready");
                                     if (nextBuffer) {
                                         NSLog(@"NextBuffer");
                                         [audioWriterInput appendSampleBuffer:nextBuffer];
                                     }
                                 }else{
                                     [audioWriterInput markAsFinished];
                                     switch ([audioReader status]) {
                                         case AVAssetReaderStatusCompleted:
                                             [videoWriter finishWriting];
                                             // [self hookUpVideo:newName];
                                             break;
                                     }
                                 }
                             }
                             
                         }
                         ];
                        break;
                        
                    case AVAssetReaderStatusFailed:
                        [videoWriter1 cancelWriting];
                        break;
                }
                
                break;
            }
        }
    }
     ];
    NSLog(@"Write Ended");
}

- (void)dealloc {
    [imageContext release];
    [filters release];
    [super dealloc];
}

@end
