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

#import "VirtualCurrencyStorage.h"
#import "VirtualCurrency.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "StoreEncryptor.h"

@implementation VirtualCurrencyStorage

- (int)getBalanceForCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = [StoreEncryptor encryptString:virtualCurrency.itemId];
    NSDictionary* currencyDict = [[[StorageManager getInstance] database] getCurrencyWithItemId:itemId];
    
    NSString* balanceStr = [currencyDict valueForKey:DICT_KEY_BALANCE];
    
    if (!currencyDict || !balanceStr || [balanceStr isEqual:[NSNull null]] || [balanceStr length]==0){
        return 0;
    }
    
    NSNumber* balance = [StoreEncryptor decryptToNumber:balanceStr];
    
    return [balance intValue];
}

- (int)addAmount:(int)amount toCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = [StoreEncryptor encryptString:virtualCurrency.itemId];
    int balance = [self getBalanceForCurrency:virtualCurrency] + amount;
    [[[StorageManager getInstance] database] updateCurrencyBalance:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forItemId:itemId];
    
    return balance;
}

- (int)removeAmount:(int)amount fromCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* itemId = [StoreEncryptor encryptString:virtualCurrency.itemId];
    int balance = [self getBalanceForCurrency:virtualCurrency] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] database] updateCurrencyBalance:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forItemId:itemId];
    
    return balance;
}

@end
