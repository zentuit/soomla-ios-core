//
//  StoreInventory.m
//  SoomlaiOSStore
//
//  Created by Refael Dakar on 10/27/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StoreInventory.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "StorageManager.h"
#import "StoreInfo.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"

@implementation StoreInventory

+ (int)getCurrencyBalance:(NSString*)currencyItemId {
    VirtualCurrency* currency = [[StoreInfo getInstance] currencyWithItemId:currencyItemId];
    
    return [[[StorageManager getInstance] virtualCurrencyStorage] getBalanceForCurrency:currency];
}

+ (int)addAmount:(int)amount toCurrency:(NSString*)currencyItemId {
    VirtualCurrency* currency = [[StoreInfo getInstance] currencyWithItemId:currencyItemId];
    
    return [[[StorageManager getInstance] virtualCurrencyStorage] addAmount:amount toCurrency:currency];
}

+ (int)removeAmount:(int)amount fromCurrency:(NSString*)currencyItemId {
    VirtualCurrency* currency = [[StoreInfo getInstance] currencyWithItemId:currencyItemId];
    
    return [[[StorageManager getInstance] virtualCurrencyStorage] removeAmount:amount fromCurrency:currency];
}

+ (int)getGoodBalance:(NSString*)goodItemId {
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:good];
}

+ (int)addAmount:(int)amount toGood:(NSString*)goodItemId {
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] addAmount:amount toGood:good];
}

+ (int)removeAmount:(int)amount fromGood:(NSString*)goodItemId {
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] removeAmount:amount fromGood:good];
}

@end
