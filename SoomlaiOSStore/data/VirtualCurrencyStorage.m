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
#import "StoreEncryptor.h"
#import "EventHandling.h"
#import "KeyValDatabase.h"

@implementation VirtualCurrencyStorage

- (int)getBalanceForCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyCurrencyBalance:virtualCurrency.itemId]];
    NSString* val = [[[StorageManager getInstance] kvDatabase] getValForKey:key];
    
    if (!val || [val length]==0){
        return 0;
    }
    
    NSNumber* balance = [StoreEncryptor decryptToNumber:val];
    
    return [balance intValue];
}

- (int)addAmount:(int)amount toCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyCurrencyBalance:virtualCurrency.itemId]];
    int balance = [self getBalanceForCurrency:virtualCurrency] + amount;
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forKey:key ];
    
    [EventHandling postChangedBalance:balance forCurrency:virtualCurrency];
    
    return balance;
}

- (int)removeAmount:(int)amount fromCurrency:(VirtualCurrency*)virtualCurrency{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyCurrencyBalance:virtualCurrency.itemId]];
    int balance = [self getBalanceForCurrency:virtualCurrency] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forKey:key ];
    
    [EventHandling postChangedBalance:balance forCurrency:virtualCurrency];
    
    return balance;
}

@end
