//
//  OCGuestFWQuerys.m
//  OCGuestFW
//
//  Created by Felix Navarro on 4/3/19.
//  Copyright © 2019 Cloud Hospitality. All rights reserved.
//

#import "OCGuestFWQuerys.h"

static NSString *const K_CREDENTIALS_URL = @"https://paas.chws.es:8585/ws/ehotelguest/getproperty";
static NSString *const K_MODULEID = @"8";

static NSString *const K_URL_CONFIG_WEB = @"/ehotelguest/getsettings/web";
static NSString *const K_URL_ROOMSTAY = @"/guestrooms/getroomstay";
static NSString *const K_URL_INVITATION_CODE = @"/integrations/keyless/enrolment";
static NSString *const K_URL_KEY_GENERATE = @"/integrations/keyless/createkey";

NSString *m_channelkey = @"";
NSString *m_base_url = @"";
NSString *m_property_id = @"";
NSString *m_roomstay_id = @"";
NSString *m_roomnumber = @"";
NSString *m_endpointId = @"";
NSString *m_checkin_date = @"";
NSString *m_checkout_date = @"";
NSString *m_keyless_type = @"";

@implementation OCGuestFWQuerys

+ (void) dbb_load_credentials:(NSString *) channelkey {
    m_channelkey = channelkey;
    NSDictionary *dict = @{
                           @"module_id" : K_MODULEID,
                           @"channelkey": m_channelkey,
                           };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    
    [request setURL:[NSURL URLWithString:K_CREDENTIALS_URL]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_channelkey" object:nil];
                                                    return;
                                                }
                                                
                                                NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                NSArray *a = [forJSONObject objectForKey:@"rS"];
                                                if (a.count == 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_channelkey" object:nil];
                                                    return;
                                                }
                                                NSDictionary *rS = a[0];
                                                
                                                m_base_url = [NSString stringWithFormat:@"%@://%@%@",
                                                              [rS objectForKey:@"protocol"], [rS objectForKey:@"host"], [rS objectForKey:@"url"]];
                                                m_property_id = [rS objectForKey:@"property_id"];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"channelkey_ok" object:nil];
                                            }];
    [task resume];
}
+ (void) dbb_load_property_config {
    
    NSDictionary *dict = @{
                           @"property_id" : m_property_id
                           };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    
    NSString *url = [NSString stringWithFormat:@"%@%@",
                     m_base_url, K_URL_CONFIG_WEB];
    
    [request setURL:[NSURL URLWithString : url]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_property" object:nil];
                                                    return;
                                                }
                                                
                                                NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                NSArray *a = [forJSONObject objectForKey:@"rS"];
                                                if (a.count == 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_property" object:nil];
                                                    return;
                                                }
                                                NSDictionary *rS = a[0];
                                                
                                                
                                                m_keyless_type = [rS objectForKey:@"keyless_type"];
                                                
                                                
                                                NSDictionary *keyless_typeO = [NSDictionary dictionaryWithObject:[rS objectForKey:@"keyless_type"] forKey:@"guestmobile_id"];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"property_ok" object:nil userInfo:keyless_typeO];
                                            }];
    [task resume];
}
+ (void) dbb_load_roomstay:(NSString *) roomstay_id {
    m_roomstay_id = roomstay_id;
    NSDictionary *dict = @{
                           @"property_id" : m_property_id,
                           @"guest_id": m_roomstay_id
                           };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    
    NSString *url = [NSString stringWithFormat:@"%@%@",
                     m_base_url, K_URL_ROOMSTAY];
    
    [request setURL:[NSURL URLWithString : url]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_roomstay" object:nil];
                                                    return;
                                                }
                                                
                                                NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                NSArray *a = [forJSONObject objectForKey:@"rS"];
                                                if (a.count == 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrong_roomstay" object:nil];
                                                    return;
                                                }
                                                NSDictionary *rS = a[0];
                                                NSString *_checkin = [NSString stringWithFormat:@"%@", [rS objectForKey:@"checkin_date"]];
                                                
                                                NSLog(@"One of these might exist \n rs: %@-%@-%@", [_checkin substringWithRange:NSMakeRange(0, 4)], [_checkin substringWithRange:NSMakeRange(4, 2)],
                                                      [_checkin substringWithRange:NSMakeRange(6, 2)]);
                                                
                                                
                                                m_checkin_date = [NSString stringWithFormat:@"%@-%@-%@",
                                                                [_checkin substringWithRange:NSMakeRange(0, 4)],[_checkin substringWithRange:NSMakeRange(4, 2)],[_checkin substringWithRange:NSMakeRange(6, 2)]];
                                                NSString *_checkout =[NSString stringWithFormat:@"%@", [rS objectForKey:@"checkout_date"]];
                                                m_checkout_date = [NSString stringWithFormat:@"%@-%@-%@",
                                                                [_checkout substringWithRange:NSMakeRange(0, 4)],[_checkout substringWithRange:NSMakeRange(4, 2)],[_checkout substringWithRange:NSMakeRange(6, 2)]];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"roomstay_ok" object:nil];
                                            }];
    [task resume];
}

+ (void) dbb_requestinvitation:(NSString *) roomnumber {
    m_roomnumber = roomnumber;
    NSDictionary *dict = @{
                           @"channelkey": m_channelkey,
                           @"property_id" : m_property_id,
                           @"roomstay_id" : m_roomstay_id,
                           @"keyless_type" : m_keyless_type,
                           };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    
    NSString *url = [NSString stringWithFormat:@"%@%@",
                     m_base_url, K_URL_INVITATION_CODE];
    
    [request setURL:[NSURL URLWithString : url]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                
                                                NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                NSArray *a = [forJSONObject objectForKey:@"rS"];
                                                if (a.count == 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                NSDictionary *rS = a[0];
                                                if([[rS objectForKey:@"errorcode"] intValue] != 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                
                                                m_endpointId = [rS objectForKey:@"guestmobile_id"];
                                                
                                                NSLog(@"One of these might exist \n m_endpointId: %@", m_endpointId);
                                                
                                                
                                                NSDictionary *guestmobileO = [NSDictionary dictionaryWithObject: m_endpointId forKey:@"guestmobile_id"];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"invitationcode_ok" object:nil userInfo:guestmobileO];
                                            }];
    [task resume];
}
+ (void) dbb_getroomkey {
    
    NSDictionary *dict = @{
       @"guestmobile_id" : m_endpointId,
       @"roomstay_id": m_roomstay_id,
       @"roomnumber": m_roomnumber,
       
       @"property_id": m_property_id,
       @"checkin_date": m_checkin_date,
       @"checkout_date": m_checkout_date,
       @"keyless_type": m_keyless_type
    };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    /*
     NSString *url = [NSString stringWithFormat:@"%@://%@%@%@",
                     @"http", @"192.168.0.111:8585", base_url, @"/integrations/doorkeys/new"];
    //*/
    
    NSString *url = [NSString stringWithFormat:@"%@%@",
                     m_base_url, K_URL_KEY_GENERATE];
    //*/
    //NSLog(@"url %@", url);
    
    [request setURL:[NSURL URLWithString: url]];
    
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error != nil) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                //NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
                                                NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:nil];
                                                NSArray *a = [forJSONObject objectForKey:@"rS"];
                                                if (a.count == 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                NSDictionary *rS = a[0];
                                                if([[rS objectForKey:@"errorcode"] intValue] != 0) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingWentWrongKey" object:nil];
                                                    return;
                                                }
                                                
                                                NSString *keycode = [rS objectForKey:@"keycode"];
                                                
                                                NSLog(@"KEY %@", keycode);
                                                
                                                NSDictionary *keycodeO = [NSDictionary dictionaryWithObject:keycode forKey:@"keycode"];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"generatedkey_ok" object:nil userInfo:keycodeO];
                                            }];
    [task resume];
}

@end
