//
//  BalanceDrivenPriceModel.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "BalanceDrivenPriceModel.h"
#import "JSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"

@implementation BalanceDrivenPriceModel

@synthesize currencyValuePerBalance;

- (id)initWithCurrencyValuePerBalance:(NSArray*)oCurrencyValuePerBalance{
    self = [super init];
    if (self){
        self.currencyValuePerBalance = oCurrencyValuePerBalance;
        self.type = @"balance";
    }
    
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    int balance = [[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:virtualGood];
    
    // if the balance is bigger than the size of the array, return the last value in the array.
    if (balance >= [self.currencyValuePerBalance count]){
        return [self.currencyValuePerBalance objectAtIndex:([self.currencyValuePerBalance count] - 1)];
    }
    
    return [self.currencyValuePerBalance objectAtIndex:balance];
}

- (NSDictionary*)toDictionary{
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    [toReturn setValue:currencyValuePerBalance forKey:JSON_GOOD_PRICE_MODEL_VALUES];
    
    return toReturn;
}

+ (BalanceDrivenPriceModel*)modelWithNSDictionary:(NSDictionary*)dict{
    return [[BalanceDrivenPriceModel alloc] initWithCurrencyValuePerBalance:[dict valueForKey:JSON_GOOD_PRICE_MODEL_VALUES]];
}

@end
