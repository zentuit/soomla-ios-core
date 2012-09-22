//
//  StaticPriceModel.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "PriceModel.h"

@interface StaticPriceModel : PriceModel{
    NSDictionary* currencyValue;
}

@property (retain, nonatomic) NSDictionary* currencyValue;

- (id)initWithCurrencyValue:(NSDictionary*)oCurrencyValue;

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood;
- (NSDictionary*)toDictionary;

+ (StaticPriceModel*)modelWithNSDictionary:(NSDictionary*)dict;

@end
