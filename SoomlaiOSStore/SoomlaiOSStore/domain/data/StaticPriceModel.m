//
//  StaticPriceModel.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StaticPriceModel.h"
#import "JSONConsts.h"

@implementation StaticPriceModel

@synthesize currencyValue;

- (id)initWithCurrencyValue:(NSDictionary*)oCurrencyValue{
    self = [super init];
    if (self){
        self.currencyValue = oCurrencyValue;
        type = @"static";
    }
    
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    return self.currencyValue;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    [toReturn setValue:currencyValue forKey:JSON_GOOD_PRICE_MODEL_VALUES];
    
    return toReturn;
}

+ (StaticPriceModel*)modelWithNSDictionary:(NSDictionary*)dict{
    return [[StaticPriceModel alloc] initWithCurrencyValue:[dict valueForKey:JSON_GOOD_PRICE_MODEL_VALUES]];
}

@end
