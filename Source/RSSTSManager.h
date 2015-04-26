// RSSTSManager.h
//
// Copyright (c) 2015 Shintaro Kaneko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE == 1
#import <UIKit/UIKit.h>
#endif

#import "RSSTSProvider.h"

#if TARGET_OS_IPHONE == 1
typedef void (^RSSTSImageBlock)(UIImage *__nonnull);
#endif
typedef void (^RSSTSErrorBlock)(NSError *__nullable);

extern NSString *const __nonnull RSSTSManagerConfigurationTokenKey;

@interface RSSTSManager : NSObject
+ (RSSTSManager *__nullable)defaultManager;

- (void)setConfiguration:(NSDictionary *__nonnull)configuration;
- (RSSTSProvider *__nullable)addProviderByChannel:(NSString *__nonnull)channel;
- (RSSTSProvider *__nullable)providerByChannel:(NSString *__nonnull)channel;
- (void)removeProviderByChannel:(NSString *__nonnull)channel;

- (void)start;
- (void)stop;
@end
