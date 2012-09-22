//
//  PriceModel.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "PriceModel.h"
#import "JSONConsts.h"
#import "StaticPriceModel.h"

@implementation PriceModel

@synthesize type;

- (id)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            JSON_GOOD_PRICE_MODEL_TYPE, self.type,
            nil];
}

+ (PriceModel*)priceModelWithNSDictionary:(NSDictionary*)dict{
    NSString* type = [dict valueForKey:JSON_GOOD_PRICE_MODEL_TYPE];
    if ([type isEqualToString:@"static"]) {
        [StaticPriceModel modelWithNSDictionary:dict];
    }
    else if ([type isEqualToString:@"balance"]) {
        
    }
    
    return nil;
}

+ (NSDictionary*)dictionaryWithPriceModel:(PriceModel*)priceModel{
    return [priceModel toDictionary];
}


@end
