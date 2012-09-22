//
//  IntEncryptionTransformer.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/17/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "NumberEncryptionTransformer.h"

@implementation NumberEncryptionTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

- (NSData*)transformedValue:(NSNumber*)number
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:number];
    return [super transformedValue:data];
}

- (NSNumber*)reverseTransformedValue:(NSData*)data
{
    if (nil == data)
    {
        return nil;
    }
    
    data = [super reverseTransformedValue:data];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
