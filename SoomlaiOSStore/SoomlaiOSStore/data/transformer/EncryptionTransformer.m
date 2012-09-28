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

#import "EncryptionTransformer.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "UIDevice+IdentifierAddition.h"
#import "StoreConfig.h"

@implementation EncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

/*
 * The encryption key is comprised of the custom secret and a unique global identifier for the specific application.
 * NOTE: change the custom secret in StoreConfig.h.
 */
- (NSString*)key
{
    return [STORE_CUSTOM_SECRET stringByAppendingString:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
}

- (id)transformedValue:(NSData*)data
{
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
    
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:self.key
                                               error:&error];

    if (!encryptedData){
        NSLog(@"ERROR ENC: %@", error.localizedDescription);
    }
    
    return encryptedData;
}

- (id)reverseTransformedValue:(NSData*)data
{
    if (nil == [self key])
    {
        return data;
    }
    
    if (nil == data)
    {
        return nil;
    }
    
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:data
                                        withPassword:self.key
                                               error:&error];
    if (!decryptedData){
        NSLog(@"ERROR DEC: %@", error.localizedDescription);
    }
    
    return decryptedData;
}

@end

