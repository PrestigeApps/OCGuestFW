//
//  ASSAAbloyIntegration.h
//  Pods
//
//  Created by Prestige Apps on 23/04/2019.
//

#import <Foundation/Foundation.h>
#import <SeosMobileKeysSDK/SeosMobileKeysSDK.h>

@interface ASSAAbloyIntegration : NSObject <MobileKeysManagerDelegate>

- (void)start;

@end
