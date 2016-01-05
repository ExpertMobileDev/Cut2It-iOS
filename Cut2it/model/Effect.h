//
//  Effect.h
//  cut2it
//
//  Created by Eugene on 10/24/12.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreImage/CIFilter.h>

@protocol EffectDelegate <NSObject>

- (void) finish:(NSURL *) url index:(int) index;

@end

@interface Effect : NSObject {
    AVAssetReader *movieReader;
    AVAssetWriter *videoWriter;
    CIContext *imageContext;
    
    NSArray *filters;
    CIFilter *sepiaTone;
    CIFilter *hueAdjust;
    CIFilter *pinchDistortion;
    CIFilter *multiplyCompositing;
    CIFilter *bloom;
    CIFilter *colorControls;
    CIFilter *colorInvert;
    CIFilter *colorPosterize;
}

@property (nonatomic, assign) id <EffectDelegate> delegate;

- (void) start;
- (void) cancel;
- (int) countEffects;
- (UIImage *) effectImage:(UIImage *) image atIndex:(int) index;
- (void) applyFilter:(NSURL *) url atIndex:(int) index;
- (void) generateImage:(NSURL *) url handle:(void(^)(UIImage *url)) handle;

@end
