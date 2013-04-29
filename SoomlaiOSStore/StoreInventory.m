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



+ (int)getItemBalance:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    return [[[StorageManager getInstance] virtualItemStorage:item] balanceForItem:item];
}

+ (void)giveAmount:(int)amount ofItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    [item giveAmount:amount];
}

+ (void)takeAmount:(int)amount ofItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    [item takeAmount:amount];
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
    
    UpgradeVG* first = [[StoreInfo getInstance] firstUpgradeForGoodWithItemId:goodItemId];
    int level = 1;
    while (![first.itemId isEqualToString:upgradeVG.itemId]) {
        first = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:first.nextGoodItemId];
        level++;
    }
    
    return level;
}

+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId {
    VirtualGood* good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    UpgradeVG* upgradeVG = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:good];
    if (!upgradeVG) {
        return @"";
    }
    
    return upgradeVG.itemId;
}

+ (void)upgradeVirtualGood:(NSString*)goodItemId {
    VirtualGood* good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    UpgradeVG* upgradeVG = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:good];
    if (upgradeVG) {
        NSString* nextItemId = upgradeVG.nextGoodItemId;
        if ((!nextItemId) ||
            (nextItemId.length == 0)) {
            return;
        }
        UpgradeVG* vgu = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:nextItemId];
        [vgu buy];
    } else {
        UpgradeVG* first = [[StoreInfo getInstance] firstUpgradeForGoodWithItemId:goodItemId];
        if (first) {
            [first buy];
        }
    }
}

+ (void)removeUpgrades:(NSString*)goodItemId {
    VirtualGood* good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    [[[StorageManager getInstance] virtualGoodStorage] removeUpgradesFrom:good];
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
