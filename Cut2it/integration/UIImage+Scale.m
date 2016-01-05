//
//  UIImage+Scale.m
//  Undrel
//
//  Created by Mukesh Sharma on 10/30/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//Resize image and keep aspect ratio
+(UIImage *)resizeImage:(UIImage *)image {
	int w = image.size.width;
    int h = image.size.height;
	
	CGImageRef imageRef = [image CGImage];
	
	int width, height;
	
	int destWidth = 640;
	int destHeight = 480;
	if(w > h){
		width = destWidth;
		height = h*destWidth/w;
	} else {
		height = destHeight;
		width = w*destHeight/h;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef bitmap;
	bitmap = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	if (image.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, M_PI/2);
		CGContextTranslateCTM (bitmap, 0, -height);
		
	} else if (image.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, -M_PI/2);
		CGContextTranslateCTM (bitmap, -width, 0);
		
	} else if (image.imageOrientation == UIImageOrientationUp) {
		
	} else if (image.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, -M_PI);
		
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}

@end
