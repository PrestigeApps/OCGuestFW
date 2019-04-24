//
//  ASSAAbloyIntegration.m
//  BerTlv
//
//  Created by Prestige Apps on 23/04/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <SeosMobileKeysSDK/SeosMobileKeysSDK.h>
#import "ASSAAbloyIntegration.h"

#define APPLICATION_ID @"AAH-CLOUDHOSPITALITY"
#define LOCK_SERVICE_CODE_AAMK 1
#define LOCK_SERVICE_CODE_HID 2

@interface ASSAAbloyIntegration ()

    @property(nonatomic) MobileKeysManager *mobileKeysManager;
    @property(nonatomic) NSMutableArray *mobileKeys;
    @property(nonatomic) NSMutableDictionary *keyTags;
    @property(nonatomic) CLLocationManager *locationManager;
    @property(nonatomic) NSDate *timeOfLastConnection;

@end

@implementation ASSAAbloyIntegration {
    BOOL _applicationIsStarting;
    NSArray *_lockServiceCodes;
    NSArray * _currentlyEnabledOpeningModes;
}

- (id)init {
    self = [super init];
    if (self) {
        // Create the MobileKeysManager
        _mobileKeysManager = [self createInitializedMobileKeysManager];
        // The location manager is used to ask the user for permission to use location services.
        _locationManager = [[CLLocationManager alloc] init];
        // Lock service codes are used to specify what readers the Manager should scan for
        _lockServiceCodes = @[];
        // Used for calculating time between vibration alerts
        _timeOfLastConnection = [NSDate dateWithTimeIntervalSince1970:1.0];
        // Opening modes enabled on startup
        _currentlyEnabledOpeningModes = @[@(MobileKeysOpeningTypeProximity)];
    }
    return self;
}

- (void)start {
    if ([self isEndpointSetup]) {
        _applicationIsStarting = YES;
    }
    // The startup will either give a callback to "mobileKeysDidStartup" or "mobileKeysDidFail"
    [_mobileKeysManager startup];
}

/*
 This is a factory method that creates an instance of the MobileKeysManager.
 */
- (MobileKeysManager *)createInitializedMobileKeysManager {
    
    NSString *version = [NSString stringWithFormat:@"%@-%@ (%@)", APPLICATION_ID, [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    NSDictionary *config = @{MobileKeysOptionApplicationId: APPLICATION_ID, MobileKeysOptionVersion: version};
    
    // Specify your own iBeacon UUID or use the internal one by not specifying this option
    // ***********************************************************************************
    // NSString *myBeaconUUIDString = @"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    // NSDictionary *config = @{MobileKeysOptionApplicationId: APPLICATION_ID, MobileKeysOptionVersion: version, MobileKeysOptionBeaconUUID: myBeaconUUIDString};
    
    return [[MobileKeysManager alloc] initWithDelegate:self options:config];
}
- (void)handleError:(NSError *)error {
    if (error != nil) {
        NSLog(@"ERROR %lxd : %@", (long) error.code, error.localizedDescription);
    }
}
- (BOOL)isEndpointSetup {
    NSError *error;
    BOOL setupComplete = [_mobileKeysManager isEndpointSetup:&error];
    [self handleError:error];
    return setupComplete;
}
- (void)setupEndpoint {
    if (self.isEndpointSetup) {
        [_mobileKeysManager updateEndpoint];
    }
}

/*
 Start Up
 */

- (void)mobileKeysDidStartup {
    if (_applicationIsStarting) {
//        setupEndpoint();
        _applicationIsStarting = false;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"assaabloystart_ok" object:nil];
}

- (void)mobileKeysDidFailToStartup:(nonnull NSError *)error {
    
}

/*
 Setup Endpoint
*/

- (void)mobileKeysDidFailToSetupEndpoint:(nonnull NSError *)error {
    
}

- (void)mobileKeysDidSetupEndpoint {
    
}



@end

