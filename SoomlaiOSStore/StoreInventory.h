//
//  StoreInventory.h
//  SoomlaiOSStore
//
//  Created by Refael Dakar on 10/27/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreInventory : NSObject

/**
 * throws InsufficientFundsException, VirtualItemNotFoundException
 */
+ (void)buyItemWithItemId:(NSString*)itemId;

/** Virtual Items **/
// The itemId must be of a VirtualCurrency or SingleUseVG or LifetimeVG or EquippableVG
+ (int)getVirtualItemBalance:(NSString*)itemId;
// The itemId must be of a VirtualCurrency or SingleUseVG or LifetimeVG or EquippableVG
+ (int)addAmount:(int)amount toVirtualItem:(NSString*)itemId;
// The itemId must be of a VirtualCurrency or SingleUseVG or LifetimeVG or EquippableVG
+ (int)removeAmount:(int)amount fromVirtualItem:(NSString*)itemId;

/** Virtual Goods **/
+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId;
+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId;
+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId;
+ (int)goodUpgradeLevel:(NSString*)goodItemId;

/** NonConsumables **/
+ (BOOL) nonConsumableItemExists:(NSString*)itemId;
+ (void) addNonConsumableItem:(NSString*)itemId;
+ (void) removeNonConsumableItem:(NSString*)itemId;

@end
