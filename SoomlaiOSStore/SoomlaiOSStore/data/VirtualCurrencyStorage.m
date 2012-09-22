//
//  VirtualCurrencyStorage.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCurrencyStorage.h"
#import "VirtualCurrency.h"
#import "StorageManager.h"
#import "StoreDatabase.h"

@implementation VirtualCurrencyStorage

- (int)getBalanceForCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = virtualCurrency.itemId;
    NSDictionary* currencyBalance = [[[StorageManager getInstance] database] getCurrencyBalanceWithItemId:itemId];
    
    if (!currencyBalance){
        return 0;
    }
    
    return [[currencyBalance valueForKey:@"balance"] intValue];
}

- (int)addAmount:(int)amount toCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = virtualCurrency.itemId;
    int balance = [self getBalanceForCurrency:virtualCurrency] + amount;
    [[[StorageManager getInstance] database] updateCurrencyBalanceWithItemID:itemId andBalance:[NSNumber numberWithInt:balance]];
    
    return balance;
}

- (int)removeAmount:(int)amount fromCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = virtualCurrency.itemId;
    int balance = [self getBalanceForCurrency:virtualCurrency] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] database] updateCurrencyBalanceWithItemID:itemId andBalance:[NSNumber numberWithInt:balance]];
    
    return balance;
}

@end
