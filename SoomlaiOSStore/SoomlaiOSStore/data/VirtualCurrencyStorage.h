//
//  VirtualCurrencyStorage.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VirtualCurrency;

@interface VirtualCurrencyStorage : NSObject

- (int)getBalanceForCurrency:(VirtualCurrency*)virtualCurrency;
- (int)addAmount:(int)amount toCurrency:(VirtualCurrency*)virtualCurrency;
- (int)removeAmount:(int)amount fromCurrency:(VirtualCurrency*)virtualCurrency;

@end
