//
//  JabcodeDecoder.m
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/15/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JabcodeDecoder.h"

@implementation JabcodeDecoder
- (NSString *)decodeImage:(UIImage *)uiImage {
    // Create a UIImage from the image file path
    CGImageRef image = [uiImage CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(image);
    NSUInteger bitsPerPixel = CGImageGetBitsPerPixel(image);
    NSUInteger channel_count = bitsPerPixel / bitsPerComponent;
    NSUInteger bytesPerRow = (bitsPerPixel * width) / 8;
    
    size_t dataSize = height * width * channel_count;
    
    jab_bitmap *bitmap = (jab_bitmap *)calloc(1, sizeof(jab_bitmap) + dataSize);
    
    bitmap->width =  (jab_int32)width;
    bitmap->height = (jab_int32)height;
    
    
    bitmap->bits_per_channel = (jab_int32)bitsPerComponent;
    bitmap->bits_per_pixel = (jab_int32)bitsPerPixel;
    bitmap->channel_count = (jab_int32)channel_count;
    
    CGContextRef context = CGBitmapContextCreate(bitmap->pixel, width, height, bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    jab_int32 decode_status;
    
    jab_data *decoded_data = decodeJABCode(bitmap, NORMAL_DECODE, &decode_status);
    
    // Retrieve the decoded string
    NSString *decodedString = nil;
    if (decoded_data != NULL) {
        decodedString = [NSString stringWithCString:decoded_data->data encoding:NSUTF8StringEncoding];
        free(decoded_data);
    }
    
    free(bitmap);
    
    return decodedString;
}
@end
