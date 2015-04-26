// RSSTSUtility.m
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

#import "RSSTSUtility.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface RSSTSUtility ()
@end

@implementation RSSTSUtility

+ (ALAssetsLibrary *)assetsLibrary {
    static ALAssetsLibrary *_library = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _library = [[ALAssetsLibrary alloc] init];
    });
    return _library;
}

- (void)latestScreenshotWithSuccess:(RSSTSImageBlock __nullable)successBlock failure:(RSSTSErrorBlock __nullable)failureBlock {
    @autoreleasepool {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                if (alAsset) {
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                    if ([[self class] isScreenshot:latestPhoto]) {
                        if (successBlock) {
                            successBlock(latestPhoto.copy);
                        }
                    }
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

+ (BOOL)isScreenshot:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return (fmodf(imageWidth, screenWidth) == 0 && fmodf(imageHeight, screenHeight) == 0) ||
    (fmodf(imageWidth, screenHeight) == 0 && fmodf(imageHeight, screenWidth) == 0);
}

@end
