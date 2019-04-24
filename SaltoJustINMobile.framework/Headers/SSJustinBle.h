//
//  SSJustinBle.h
//  JustIN Mobile SDK
//
//  Copyright (c) 2018 Copyright Salto Systems.
//  All rights reserved.
//
//  Use of binaries contained within SALTO JustIN Mobile's SDK is permitted only to enable the
//  integration of the Systems Systems platform by customers of Salto Systems.
//  Decompilation and modification is not allowed.
//  Neither the name of Salto Systems nor JustIN nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written permission.
//  Redistribution of binaries is disallowed except with specific prior written permission.
//  Any such redistribution must retain the above copyright notice, this list of conditions and the
//  following disclaimer.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
//  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
//  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import <Foundation/Foundation.h>
#import "SSMobileKey.h"
#import "SSLockOpeningParams.h"

#define SSJustinBleInstance [SSJustinBle sharedInstance]

/**
 This block is invoked when the communication process has finished correctly.
 
 @param opResult The code describing the result of the process.
 */
typedef void (^SSSuccessBlock) (NSInteger opResult);

/**
 This block is invoked when any error is found in the process.
 
 @param error The error describing failure.
 */
typedef void (^SSErrorBlock) (NSError * _Nonnull error);

/**
 This block is invoked when a SALTO lock peripheral is found and the Bluetooth API
 is going to connect to it.
 */
typedef void (^SSPeripheralFoundBlock) (void);

/**
 This block will be executed to obtain a suitable key for the opening operation.
 */
typedef SSMobileKey* _Nonnull (^SSJustinBleManagerKeyRetriever)(void);

/**
 The Salto Justin Ble API allows establishing the communication between the mobile phone and the lock.
 
 It is organized around a singleton, accessible via the `+sharedInstance` method. Through this singleton, you can invoke any of
 its methods to communicate with a SALTO lock.
 */
@interface SSJustinBle : NSObject

/** @name Initialization */

/**
 This method provides access to the SSJustinBle singleton.
 
 @return The SSJustinBle singleton.
 */
+ (instancetype _Nonnull)sharedInstance;

/** @name API methods */

/**
 Starts the SALTO lock discovery and connecting process given a `SSMobileKey` to perform a door opening operation.
 
 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.
 
 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.
 
 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.
 
     [SSJustinBleInstance startLockOpeningWithMobileKey:myKey success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     }];
 
 @param currentKey Key to open the door.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 @see If you want to receive when a peripheral is found, call isntead startLockOpeningWithMobileKey:peripheralFound:success:failure:
 */
- (void)startLockOpeningWithMobileKey:(SSMobileKey * _Nonnull)currentKey
                              success:(SSSuccessBlock _Nonnull)successBlock
                              failure:(SSErrorBlock _Nonnull)errorBlock;

/**
 Starts the SALTO lock discovery and connecting process given a `SSMobileKey` to perform a door opening operation.

 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.

 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.

 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.

     [SSJustinBleInstance startLockOpeningWithMobileKey:myKey success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     } params:[[SSLockOpeningParams alloc] initWithOpeningMode:kOpeningStandardMode]];

 @param currentKey Key to open the door.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 @param lockOpeningParams Specify custom lock opening mode parameters.
 @see If you want to receive when a peripheral is found, call isntead startLockOpeningWithMobileKey:peripheralFound:success:failure:
 */
- (void)startLockOpeningWithMobileKey:(SSMobileKey * _Nonnull)currentKey
                              success:(SSSuccessBlock _Nonnull)successBlock
                              failure:(SSErrorBlock _Nonnull)errorBlock
                               params:(SSLockOpeningParams * _Nonnull)lockOpeningParams;

/**
 Starts the SALTO lock discovery and connecting process given a `SSMobileKey` to perform a door opening operation.
 
 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.
 
 Once the scanning process finds a SALTO lock the `SSPeripheralFoundBlock` block will be called. This might be
 useful for user interface purposes.
 
 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.
 
 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.
 
     [SSJustinBleInstance startLockOpeningWithMobileKey:myKey peripheralFound:^{
         // Do peripheral found UI actions.
     } success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     }];
 
 @param currentKey Key to open the door.
 @param peripheralFoundBlock When a SALTO peripheral is found, this block will be called.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 */
- (void)startLockOpeningWithMobileKey:(SSMobileKey * _Nonnull)currentKey
                      peripheralFound:(SSPeripheralFoundBlock _Nonnull)peripheralFoundBlock
                              success:(SSSuccessBlock _Nonnull)successBlock
                              failure:(SSErrorBlock _Nonnull)errorBlock;

/**
 Starts the SALTO lock discovery and connecting process given a `SSMobileKey` to perform a door opening operation.

 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.

 Once the scanning process finds a SALTO lock the `SSPeripheralFoundBlock` block will be called. This might be
 useful for user interface purposes.

 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.

 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.

     [SSJustinBleInstance startLockOpeningWithMobileKey:myKey peripheralFound:^{
         // Do peripheral found UI actions.
     } success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     } params:[[SSLockOpeningParams alloc] initWithOpeningMode:kOpeningStandardMode]];

 @param currentKey Key to open the door.
 @param peripheralFoundBlock When a SALTO peripheral is found, this block will be called.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 @param lockOpeningParams Specify custom lock opening mode parameters.
 */
- (void)startLockOpeningWithMobileKey:(SSMobileKey * _Nonnull)currentKey
                      peripheralFound:(SSPeripheralFoundBlock _Nonnull)peripheralFoundBlock
                              success:(SSSuccessBlock _Nonnull)successBlock
                              failure:(SSErrorBlock _Nonnull)errorBlock
                               params:(SSLockOpeningParams * _Nonnull)lockOpeningParams;

/**
 Starts the SALTO lock discovery and connecting process to perform a door opening operation.
 
 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.
 
 Once the scanning process finds a SALTO lock the `SSPeripheralFoundBlock` block will be called. This might be
 useful for user interface purposes. At the same time, the `SSJustinBleManagerKeyRetriever` block will be executed to obtain a suitable key for the opening operation.
 
 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.
 
 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.
 
     [SSJustinBleInstance startLockOpeningWithMobileKeyBlock:^{
         // Do Key retrieval operations
     } peripheralFound:^{
         // Do peripheral found UI actions.
     } success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     }];
 
 @param currentKey Block to obtain the latest Key to open the door.
 @param peripheralFoundBlock When a SALTO peripheral is found, this block will be called.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 */
- (void)startLockOpeningWithMobileKeyBlock:(SSJustinBleManagerKeyRetriever _Nonnull)currentKey
                           peripheralFound:(SSPeripheralFoundBlock _Nonnull)peripheralFoundBlock
                                   success:(SSSuccessBlock _Nonnull)successBlock
                                   failure:(SSErrorBlock _Nonnull)errorBlock;

/**
 Starts the SALTO lock discovery and connecting process to perform a door opening operation.

 This process will first scan all nearby SALTO Bluetooth locks and if it founds one, it will proceed to connect and perform a secure communication protocol. The process will have a **maximum timeout of 10 seconds**.

 Once the scanning process finds a SALTO lock the `SSPeripheralFoundBlock` block will be called. This might be
 useful for user interface purposes. At the same time, the `SSJustinBleManagerKeyRetriever` block will be executed to obtain a suitable key for the opening operation.

 If the secure process finishes correctly `SSSuccessBlock` will return an authentication operation result code defined in the documentation.

 However, if there is any error in the process the `SSErrorBlock` will be called returning a
 `NSError` with a specific code. Take a look at our documentation to see the specific error code values.

     [SSJustinBleInstance startLockOpeningWithMobileKeyBlock:^{
         // Do Key retrieval operations
     } peripheralFound:^{
         // Do peripheral found UI actions.
     } success:^(NSInteger opResult) {
         // Do actions when the process succeed.
     } failure:^(NSError *error) {
         // Do actions when an error occurred.
     } params:[[SSLockOpeningParams alloc] initWithOpeningMode:kOpeningStandardMode]];

 @param currentKey Block to obtain the latest Key to open the door.
 @param peripheralFoundBlock When a SALTO peripheral is found, this block will be called.
 @param successBlock When the process finishes successfully this block will be called.
 @param errorBlock When any error is found during the opening process this error block will be called.
 @param lockOpeningParams Specify custom lock opening mode parameters.
 */
- (void)startLockOpeningWithMobileKeyBlock:(SSJustinBleManagerKeyRetriever _Nonnull)currentKey
                           peripheralFound:(SSPeripheralFoundBlock _Nonnull)peripheralFoundBlock
                                   success:(SSSuccessBlock _Nonnull)successBlock
                                   failure:(SSErrorBlock _Nonnull)errorBlock
                                    params:(SSLockOpeningParams * _Nonnull)lockOpeningParams;

@end
