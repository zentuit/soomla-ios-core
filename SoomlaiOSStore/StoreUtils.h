/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

#define LogDebug(x,y) [StoreUtils LogDebug:x withMessage:y];
#define LogError(x,y) [StoreUtils LogError:x withMessage:y];

@interface StoreUtils : NSObject

/**
 * Creates Log Debug message according to given tag and message.
 *
 * tag - the name of the class whose instance called this function.
 * msg - debug message to output to log.
 */
+ (void)LogDebug:(NSString*)tag withMessage:(NSString*)msg;

/**
 * Creates Log Error message according to given tag and message.
 *
 * tag - the name of the class whose instance called this function.
 * msg - error message to output to log.
 */
+ (void)LogError:(NSString*)tag withMessage:(NSString*)msg;

/**
 * Retrieves device Id.
 *
 * return: id of the device being used.
 */
+ (NSString*)deviceId;


+ (NSMutableDictionary*)jsonStringToDict:(NSString*)str;

+ (NSMutableArray*)jsonStringToArray:(NSString*)str;

+ (NSString*)dictToJsonString:(NSDictionary*)str;

+ (NSString*)arrayToJsonString:(NSArray*)arr;

@end

