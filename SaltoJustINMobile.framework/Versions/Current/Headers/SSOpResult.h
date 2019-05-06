//
//  SSOpResult.h
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

/**
 List of authentication operation results.
 */
@interface SSOpResult : NSObject

/** General groupings to be used whenever we can't match a specific OpResult. **/
typedef NS_ENUM(NSInteger, SSOpResultGroup) {
    kGroupUnknownResult,
    kGroupFailure,
    kGroupAccepted,
    kGroupRejected
};

/** List of authentication operation results **/
/** Successful authentication but no information about the operation result. */
extern unsigned char const AUTH_SUCCESS_UNKNOWN_RESULT;
/** Successful authentication and access granted (lock opened). */
extern unsigned char const AUTH_SUCCESS_ACCESS_GRANTED;
/** Successful authentication and access rejected. */
extern unsigned char const AUTH_SUCCESS_ACCESS_REJECTED;
/** Successful authentication and door opened with office mode set. */
extern unsigned char const AUTH_SUCCESS_DOOR_IN_OFFICE;
/** Successful authentication and door closed with office mode removed. */
extern unsigned char const AUTH_SUCCESS_END_OFFICE;
/** Successful authentication and opening roller. */
extern unsigned char const AUTH_SUCCESS_OPENING_ROLLER;
/** Successful authentication and closing roller. */
extern unsigned char const AUTH_SUCCESS_CLOSING_ROLLER;
/** Successful authentication and stop roller. */
extern unsigned char const AUTH_SUCCESS_STOP_ROLLER;
/** Successful authentication and waiting for a second valid key for opening. */
extern unsigned char const AUTH_SUCCESS_WAIT_SECOND_CARD;
/** Successful authentication, access rejected, PIN required. Introduce PIN before key. */
extern unsigned char const AUTH_SUCCESS_PIN_REQUIRED;
/** Successful authentication, access rejected and key should be deleted. */
extern unsigned char const AUTH_SUCCESS_CANCELLED_KEY;
/** Successful authentication, key data was processed successfully. Doesn't imply any further outcome. */
extern unsigned char const AUTH_SUCCESS_KEY_PROCESSED;

/**
 Get group of the given operation result code.

 @param opResult Operation result code.
 @return Group of the given operation result.
 */
+ (SSOpResultGroup)getGroup:(NSInteger)opResult;

@end
