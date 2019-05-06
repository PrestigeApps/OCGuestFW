//
//  OCGuestFWViewController.h
//  OCGuestFW
//
//  Created by Felix Navarro on 03/03/2019.
//  Copyright © 2019 Cloud Hospitality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <SeosMobileKeysSDK/SeosMobileKeysSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCGuestFWViewController : UIViewController <CBCentralManagerDelegate, MobileKeysManagerDelegate>

    typedef void (^integrationCallback)(NSString *result);
    @property (nonatomic, strong) integrationCallback callback;
    @property NSString *channelkey;
    @property NSString *roomstay_id;
    @property NSString *roomnumber;
    @property NSString *langcode;

//    + (MobileKeysManager *)createInitializedMobileKeysManager: (OCGuestFWViewController *) delegate;
    - (void) startASSAAbloyIntegration;
    - (void) stopScanning;
@end

NS_ASSUME_NONNULL_END
