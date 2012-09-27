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
#import "BalanceDrivenPriceModel.h"

@implementation PriceModel

@synthesize type;

- (id)init{
    self = [super init];
    if ([self class] == [PriceModel class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.type, JSON_GOOD_PRICE_MODEL_TYPE,
            nil];
}

+ (PriceModel*)priceModelWithNSDictionary:(NSDictionary*)dict{
    NSString* type = [dict valueForKey:JSON_GOOD_PRICE_MODEL_TYPE];
    if ([type isEqualToString:@"static"]) {
        return [StaticPriceModel modelWithNSDictionary:dict];
    }
    else if ([type isEqualToString:@"balance"]) {
        return [BalanceDrivenPriceModel modelWithNSDictionary:dict];
    }
    
    return nil;
}

+ (NSDictionary*)dictionaryWithPriceModel:(PriceModel*)priceModel{
    return [priceModel toDictionary];
}


@end
