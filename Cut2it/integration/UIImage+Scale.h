//
//  UIImage+Scale.h
//  Undrel
//
//  Created by Mukesh Sharma on 10/30/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIImage *)resizeImage:(UIImage *)image;
@end
