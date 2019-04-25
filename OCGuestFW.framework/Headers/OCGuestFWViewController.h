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
    typedef NS_ENUM(NSInteger, ViewState) {
        NO_KEY = 0,
        KEY_GENERATED_ERROR = 1,
        KEY_GENERATED = 2,
        OPEN_TRY = 3,
        NO_BLUETOOTH = 4,
        NO_KEY_DOOR = 5,
        KEY_DOOR_OK = 6,
        LOADING = 7
    };

    typedef NS_ENUM(NSInteger, LockType) {
        Vingcard = 1,
        VingcardD = 101,
        Salto = 3,
        SaltoD = 103
    };

    typedef void (^integrationCallback)(NSString *result);

    @property (nonatomic, strong) integrationCallback callback;

    @property NSString *channelkey;
    @property NSString *roomstay_id;
    @property NSString *roomnumber;
    @property NSString *langcode;

    - (IBAction)bt_key:(id)sender;

    @property (weak, nonatomic) IBOutlet UILabel *m_lb_key;
    @property (weak, nonatomic) IBOutlet UIButton *m_bt_getkey;
    @property (weak, nonatomic) IBOutlet UIImageView *m_image;
    @property (strong, nonatomic) IBOutlet UIView *m_View;
    @property (weak, nonatomic) IBOutlet UIView *rectView;
    @property (strong, nonatomic) CBCentralManager *centralManager;

@end

NS_ASSUME_NONNULL_END
