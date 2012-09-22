//
//  VirtualGoodStorage.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualGoodStorage.h"
#import "VirtualGood.h"
#import "StorageManager.h"
#import "StoreDatabase.h"

@implementation VirtualGoodStorage

- (int)getBalanceForGood:(VirtualGood*)virtualGood{
    NSString* itemId = virtualGood.itemId;
    NSDictionary* goodBalance = [[[StorageManager getInstance] database] getGoodBalanceWithItemId:itemId];
    
    if (!goodBalance){
        return 0;
    }
    
    return [[goodBalance valueForKey:@"balance"] intValue];
}

- (int)addAmount:(int)amount toGood:(VirtualGood*)virtualGood{
    NSString* itemId = virtualGood.itemId;
    int balance = [self getBalanceForGood:virtualGood] + amount;
    [[[StorageManager getInstance] database] updateGoodBalanceWithItemId:itemId andBalance:[NSNumber numberWithInt:balance]];
    
    return balance;
}

- (int)removeAmount:(int)amount fromGood:(VirtualGood*)virtualGood{
    NSString* itemId = virtualGood.itemId;
    int balance = [self getBalanceForGood:virtualGood] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] database] updateGoodBalanceWithItemId:itemId andBalance:[NSNumber numberWithInt:balance]];
    
    return balance;
}

@end
