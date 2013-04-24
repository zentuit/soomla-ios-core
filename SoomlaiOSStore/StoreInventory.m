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
#import "NonConsumableStorage.h"
#import "PurchasableVirtualItem.h"
#import "UpgradeVG.h"

@implementation StoreInventory

+ (void)buyItemWithItemId:(NSString*)itemId {
    PurchasableVirtualItem* pvi = (PurchasableVirtualItem*) [[StoreInfo getInstance] virtualItemWithId:itemId];
    [pvi buy];
}



+ (int)getVirtualItemBalance:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    return [[[StorageManager getInstance] virtualItemStorage:item] balanceForItem:item];
}

+ (int)addAmount:(int)amount toVirtualItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    return [[[StorageManager getInstance] virtualItemStorage:item] addAmount:amount toItem:item];
}

+ (int)removeAmount:(int)amount fromVirtualItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    return [[[StorageManager getInstance] virtualItemStorage:item] removeAmount:amount fromItem:item];
}



+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId {
    EquippableVG* good = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] equipGood:good];
}

+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId {
    EquippableVG* good = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] unequipGood:good];
}

+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId {
    EquippableVG* good = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    
    return [[[StorageManager getInstance] virtualGoodStorage] isGoodEquipped:good];
}

+ (int)goodUpgradeLevel:(NSString*)goodItemId {
    VirtualGood* good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    UpgradeVG* upgradeVG = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:good];
    if (!upgradeVG) {
        return 0;
    }
    
    return upgradeVG.level;
}



+ (BOOL) nonConsumableItemExists:(NSString*)itemId {
    NonConsumableItem* nonConsumable = (NonConsumableItem*)[[StoreInfo getInstance] virtualItemWithId:itemId];
    
    return [[[StorageManager getInstance] nonConsumableStorage] nonConsumableExists:nonConsumable];
}

+ (void) addNonConsumableItem:(NSString*)itemId {
    NonConsumableItem* nonConsumable = (NonConsumableItem*)[[StoreInfo getInstance] virtualItemWithId:itemId];
    
    [[[StorageManager getInstance] nonConsumableStorage] add:nonConsumable];
}

+ (void) removeNonConsumableItem:(NSString*)itemId {
    NonConsumableItem* nonConsumable = (NonConsumableItem*)[[StoreInfo getInstance] virtualItemWithId:itemId];
    
    [[[StorageManager getInstance] nonConsumableStorage] remove:nonConsumable];
}

@end
