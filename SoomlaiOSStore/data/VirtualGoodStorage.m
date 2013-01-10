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
#import "StoreEncryptor.h"
#import "EventHandling.h"

@implementation VirtualGoodStorage

- (int)getBalanceForGood:(VirtualGood*)virtualGood{
    NSString* itemId = [StoreEncryptor encryptString:virtualGood.itemId];
    NSDictionary* goodDict = [[[StorageManager getInstance] database] getGoodWithItemId:itemId];
    
    NSString* balanceStr = [goodDict valueForKey:DICT_KEY_BALANCE];
    
    if (!goodDict || !balanceStr || [balanceStr isEqual:[NSNull null]] || [balanceStr length]==0){
        return 0;
    }
    
    NSNumber* balance = [StoreEncryptor decryptToNumber:balanceStr];
    return [balance intValue];
}

- (int)addAmount:(int)amount toGood:(VirtualGood*)virtualGood{
    NSString* itemId = [StoreEncryptor encryptString:virtualGood.itemId];
    int balance = [self getBalanceForGood:virtualGood] + amount;
    [[[StorageManager getInstance] database] updateGoodBalance:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forItemId:itemId];
    
    [EventHandling postChangedBalance:balance forGood:virtualGood];
    
    return balance;
}

- (int)removeAmount:(int)amount fromGood:(VirtualGood*)virtualGood{
    NSString* itemId = [StoreEncryptor encryptString:virtualGood.itemId];
    int balance = [self getBalanceForGood:virtualGood] - amount;
    balance = balance > 0 ? balance : 0;
    [[[StorageManager getInstance] database] updateGoodBalance:[StoreEncryptor encryptNumber:[NSNumber numberWithInt:balance]] forItemId:itemId];

    [EventHandling postChangedBalance:balance forGood:virtualGood];
    
    return balance;
}

- (BOOL)isGoodEquipped:(VirtualGood*)virtualGood{
    NSString* itemId = [StoreEncryptor encryptString:virtualGood.itemId];
    NSDictionary* goodDict = [[[StorageManager getInstance] database] getGoodWithItemId:itemId];
    
    NSString* equipStr = [goodDict valueForKey:DICT_KEY_EQUIP];
    
    if (!goodDict || !equipStr || [equipStr isEqual:[NSNull null]] || [equipStr length]==0){
        return NO;
    }
    
    BOOL equip = [StoreEncryptor decryptToBoolean:equipStr];
    
    return equip;
}

- (void)equipGood:(VirtualGood*)virtualGood withEquipValue:(BOOL)equip{
    NSString* itemId = [StoreEncryptor encryptString:virtualGood.itemId];
    [[[StorageManager getInstance] database] updateGoodEquipped:[StoreEncryptor encryptBoolean:equip] forItemId:itemId];
    
    if (equip) {
        [EventHandling postVirtualGoodEquipped:virtualGood];
    } else {
        [EventHandling postVirtualGoodUnEquipped:virtualGood];
    }
}

@end
