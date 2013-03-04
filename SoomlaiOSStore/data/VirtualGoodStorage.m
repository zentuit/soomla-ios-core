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
#import "KeyValDatabase.h"
#import "StoreEncryptor.h"
#import "EventHandling.h"

@implementation VirtualGoodStorage

- (int)getBalanceForGood:(VirtualGood*)virtualGood{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodBalance:virtualGood.itemId]];
    NSString* val = [[[StorageManager getInstance] kvDatabase] getValForKey:key];
    
    if (!val || [val length]==0){
        return 0;
    }
    
    NSNumber* balance = [StoreEncryptor decryptToNumber:val];
    return [balance intValue];
}

- (int)addAmount:(int)amount toGood:(VirtualGood*)virtualGood{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodBalance:virtualGood.itemId]];
    int balance = [self getBalanceForGood:virtualGood] + amount;
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forKey:key];
    
    [EventHandling postChangedBalance:balance forGood:virtualGood withAmount:amount];
    
    return balance;
}

- (int)removeAmount:(int)amount fromGood:(VirtualGood*)virtualGood{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodBalance:virtualGood.itemId]];
    int balance = [self getBalanceForGood:virtualGood] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forKey:key];

    [EventHandling postChangedBalance:balance forGood:virtualGood withAmount:(-1*amount)];
    
    return balance;
}

- (int)setBalance:(int)balance toGood:(VirtualGood*)virtualGood {
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodBalance:virtualGood.itemId]];
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forKey:key];
    
    [EventHandling postChangedBalance:balance forGood:virtualGood withAmount:0];
    
    return balance;
}

- (BOOL)isGoodEquipped:(VirtualGood*)virtualGood{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodEquipped:virtualGood.itemId]];
    NSString* val = [[[StorageManager getInstance] kvDatabase] getValForKey:key];
    
    if (!val || [val length]==0){
        return NO;
    }
    
    BOOL equip = [StoreEncryptor decryptToBoolean:val];
    
    return equip;
}

- (void)equipGood:(VirtualGood*)virtualGood withEquipValue:(BOOL)equip{
    NSString* key = [StoreEncryptor encryptString:[KeyValDatabase keyGoodEquipped:virtualGood.itemId]];
    
    if (equip) {
        [[[StorageManager getInstance] kvDatabase] setVal:@"" forKey:key];
        [EventHandling postVirtualGoodEquipped:virtualGood];
    } else {
        [[[StorageManager getInstance] kvDatabase] deleteKeyValWithKey:key];
        [EventHandling postVirtualGoodUnEquipped:virtualGood];
    }
}

@end
