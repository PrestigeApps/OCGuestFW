//
//  SSJustinErrorCodes.h
//  JustIN Mobile SDK
//
//  Created by Xabier Gorostidi on 28/04/15.
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


/**
 The list of Salto error codes.
 */
@interface SSJustinErrorCodes : NSObject

/** Domain of all the errors related to this SDK. */
extern NSErrorDomain const SSJustINErrorDomain;

typedef NS_ENUM(NSInteger, SSJustinErrorCode) {
    /** A general error has occurred. */
    kConnectionGeneralError = 400,
    /** The process is already running and until it finishes no more processes can be executed simultaneously. */
    kProcessAlreadyRunningError = 401,
    /** The provided binary information to the Salto Key is not valid. */
    kIncorrectMobileKeyDataError = 402,
    /** Bluetooth is not supported by the device. */
    kBluetoothNotSupportedError = 403,
    /** Bluetooth feature is not enabled. */
    kBluetoothFeatureNotEnabledError = 404,
    /** Bluetooth is not initialized already. */
    kBluetoothNotInitializedError = 405,
    /** GATT (Generic Attribute Profile) server disconnected. */
    kDisconnectedGattServerError = 406,
    /** The operation has been cancelled. */
    kOperationCancelledError = 407,
    /** The search of services has returned zero results. */
    kNoServicesFoundError = 409,
    /** Timeout has been reached. */
    kTimeoutReachedError = 410,
    /** Invalid characteristics found in the service. */
    kInvalidServiceCharacteristicsError = 411,
    /** The lock has returned a protocol version that the current
     SDK version is not compatible with. */
    kInvalidProtocolVersionError = 412,
    /** Invalid data received in the secure protocol process. */
    kInvalidDataReceivedError = 413,
    /** There has been an authentication error between the mobile phone and the lock. */
    kAuthenticationFailedError = 414,
};

@end
