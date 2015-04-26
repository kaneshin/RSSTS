# RSSTS

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RSSTS = Report Screenshot To Slack

## Installation

### Carthage

1. Add the following to your *Cartfile*: `github "kaneshin/RSSTS" ~> 0.1`
2. Run `carthage update`
3. Add RSSTS as an embedded framework.

## Support

**ONLY iOS**
**ONLY Dynamic Library**

## Usage

Import `#import <RSSTS/RSSTS.h>` in your header file.

### Objective-C

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RSSTSManager *manager = [RSSTSManager defaultManager];
    [manager setConfiguration:@{RSSTSManagerConfigurationTokenKey: @"YOUR ACCESS TOKEN IS HERE"}];
    [manager addProviderByChannel:@"CHANNEL IDs"];
    [manager start];
    return YES;
}
```

## License

[The MIT License (MIT)](http://kaneshin.mit-license.org/)

## Author

Shintaro Kaneko <kaneshin0120@gmail.com>
