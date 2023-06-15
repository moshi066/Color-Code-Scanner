//
//  JabcodeDecoder.h
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/15/23.
//

#ifndef JabcodeDecoder_h
#define JabcodeDecoder_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "../jabcode/jabcode.h"

@interface JabcodeDecoder : NSObject
- (NSString *) decodeImage: (UIImage *) uiImage;
@end

#endif /* JabcodeDecoder_h */
