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

/**
 * The itemId must be of a VirtualCurrency or SingleUseVG or LifetimeVG or EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (int)getItemBalance:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void)giveAmount:(int)amount ofItem:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void)takeAmount:(int)amount ofItem:(NSString*)itemId;

/** Virtual Goods **/
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId;
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId;
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (int)goodUpgradeLevel:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (void)upgradeVirtualGood:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (void)removeUpgrades:(NSString*)goodItemId;

/** NonConsumables **/
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL) nonConsumableItemExists:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void) addNonConsumableItem:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void) removeNonConsumableItem:(NSString*)itemId;

@end
