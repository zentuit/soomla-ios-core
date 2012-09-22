//
//  BalanceDrivenPriceModel.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "PriceModel.h"

@interface BalanceDrivenPriceModel : PriceModel{
    NSArray* currencyValuePerBalance;
}

@property (retain, nonatomic) NSArray* currencyValuePerBalance;

- (id)initWithCurrencyValuePerBalance:(NSArray*)oCurrencyValuePerBalance;

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood;
- (NSDictionary*)toDictionary;

+ (BalanceDrivenPriceModel*)modelWithNSDictionary:(NSDictionary*)dict;
@end
