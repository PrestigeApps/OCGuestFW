//
//  OCGuestFWQuerys.h
//  OCGuestFW
//
//  Created by Felix Navarro on 4/3/19.
//  Copyright © 2019 Cloud Hospitality. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCGuestFWQuerys : NSObject

+ (void) dbb_load_credentials:(NSString *) channelkey;
+ (void) dbb_load_property_config;
+ (void) dbb_load_roomstay:(NSString *) roomstay_id;
+ (void) dbb_requestinvitation:(NSString *) roomnumber;
+ (void) dbb_getroomkey;

@end
