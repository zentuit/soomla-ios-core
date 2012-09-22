//
//  StringEncryptionTransformer.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/17/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StringEncryptionTransformer.h"

@implementation StringEncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (NSString*)transformedValue:(NSString*)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [super transformedValue:data];
}

- (NSString*)reverseTransformedValue:(NSData*)data
{
    if (nil == data)
    {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [[NSString alloc] initWithBytes:[data bytes]
                                     length:[data length]
                                   encoding:NSUTF8StringEncoding];
}

@end
