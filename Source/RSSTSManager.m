// RSSTSManager.m
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

#import "RSSTSManager.h"

#if TARGET_OS_IPHONE == 1
#import <UIKit/UIKit.h>
#endif

#import "RSSTSUtility.h"

NSString *const RSSTSManagerConfigurationTokenKey = @"RSSTSManagerConfigurationTokenKey";

@interface RSSTSManager()
@property (nonatomic, strong, nonnull) NSString *token;
@property (nonatomic, strong, nonnull) NSMutableDictionary *providers;
@end

@implementation RSSTSManager

+ (RSSTSManager * __nullable)defaultManager {
    static RSSTSManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RSSTSManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.providers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setConfiguration:(NSDictionary * __nonnull)configuration {
    NSString *token = configuration[RSSTSManagerConfigurationTokenKey];
    if (token) {
        self.token = token;
    }
}

- (RSSTSProvider * __nullable)addProviderByChannel:(NSString * __nonnull)channel {
    RSSTSProvider *provider = [self providerByChannel:channel];
    if (!provider) {
        provider = [[RSSTSProvider alloc] initWithToken:self.token channel:channel];
        self.providers[channel] = provider;
    }
    return provider;
}

- (RSSTSProvider * __nullable)providerByChannel:(NSString * __nonnull)channel {
    return self.providers[channel];
}

- (void)removeProviderByChannel:(NSString * __nonnull)channel {
    [self.providers removeObjectForKey:channel];
}

- (void)start {
#if TARGET_OS_IPHONE == 1
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didTakeScreenshot)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
#endif
}

- (void)stop {
#if TARGET_OS_IPHONE == 1
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
#endif
}

- (void)didTakeScreenshot {
    __block RSSTSProvider *p = nil;
    [self.providers enumerateKeysAndObjectsUsingBlock:^(NSString *key, RSSTSProvider *provider, BOOL *stop) {
        p = provider;
    }];
#if TARGET_OS_IPHONE == 1
    [[[RSSTSUtility alloc] init] latestScreenshotWithSuccess:^(UIImage *image) {
        [p uploadImage:image.CGImage];
    } failure:^(NSError *error) {
    }];
#endif
}

@end
