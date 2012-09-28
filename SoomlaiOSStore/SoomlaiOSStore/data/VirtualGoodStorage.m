/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
