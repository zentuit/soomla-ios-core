//
//  EncryptionTransformer.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/17/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

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
    
//    NSData *data = [@"Data" dataUsingEncoding:NSUTF8StringEncoding];
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

