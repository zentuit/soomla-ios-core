/*
 * Copyright (C) 2012-2014 Soomla Inc.
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

#import <Foundation/Foundation.h>
#import "IStoreAssets.h"

@class VirtualCategory;
@class VirtualCurrency;
@class VirtualGood;
@class VirtualCurrencyPack;
@class NonConsumableItem;
@class VirtualItem;
@class PurchasableVirtualItem;
@class UpgradeVG;

/**
 * This class holds the store's meta data including:
 * - Virtual Currencies
 * - Virtual Currency Packs
 * - All kinds of Virtual Goods
 * - Virtual Categories
 * - Non-Consumables
 */
@interface StoreInfo : NSObject{
    @private
    NSMutableDictionary* virtualItems;
    NSMutableDictionary* purchasableItems;
    NSMutableDictionary* goodsCategories;
    NSMutableDictionary* goodsUpgrades;
    @public
    NSMutableArray* virtualCurrencies;
    NSMutableArray* virtualGoods;
    NSMutableArray* virtualCurrencyPacks;
    NSMutableArray* nonConsumableItems;
    NSMutableArray* virtualCategories;
}

@property (nonatomic, retain) NSMutableArray* virtualCurrencies;
@property (nonatomic, retain) NSMutableArray* virtualGoods;
@property (nonatomic, retain) NSMutableArray* virtualCurrencyPacks;
@property (nonatomic, retain) NSMutableArray* nonConsumableItems;
@property (nonatomic, retain) NSMutableArray* virtualCategories;
@property (nonatomic, retain) NSMutableDictionary* virtualItems;
@property (nonatomic, retain) NSMutableDictionary* purchasableItems;
@property (nonatomic, retain) NSMutableDictionary* goodsCategories;
@property (nonatomic, retain) NSMutableDictionary* goodsUpgrades;

+ (StoreInfo*)getInstance;

/**
 * Initializes `StoreInfo`, either from `IStoreAssets` or from database.
 * On first initialization, when the database doesn't have any previous version 
 * of the store metadata, `StoreInfo` gets loaded from the given `IStoreAssets`.
 * After the first initialization, `StoreInfo` will be initialized from the 
 * database.
 *
 * IMPORTANT: If you want to override the current `StoreInfo`, you'll have to 
 * bump the version of your implementation of `IStoreAssets` in order to remove 
 * the metadata when the application loads. Bumping the version is done by 
 * returning a higher number in `IStoreAssets`'s function `getVersion()`.
 */
- (void)initializeWithIStoreAssets:(id <IStoreAssets>)storeAssets;

/**
 * Initializes `StoreInfo` from the database.
 * This action should be performed only once during the lifetime of a session of the game.
 * `StoreController` automatically initializes `StoreInfo`.
 * Don't do it if you don't know what you're doing.
 *
 * @return YES if successful, NO otherwise
 */
- (BOOL)initializeFromDB;

/**
 * Converts this to an `NSDictionary`.
 */
- (NSDictionary*)toDictionary;

/**
 * Retrieves a single `VirtualItem` that resides in the metadata.
 *
 * @param itemId the item id of the required `VirtualItem`.
 * @exception VirtualItemNotFoundException when the given `itemId` is not found.
 */
- (VirtualItem*)virtualItemWithId:(NSString*)itemId;

/**
 * Retrieves a single `PurchasableVirtualItem` that resides in the metadata.
 *
 * IMPORTANT: The retrieved `PurchasableVirtualItem` has a purchaseType of `PurchaseWithMarket`. This is why we fetch here with `productId` and not with `itemId` (`productId` is the id of the product in the App Store).
 *
 * @param productId the product id of the required `PurchasableVirtualItem`.
 * @exception VirtualItemNotFoundException when the given productId was not found.
 */
- (PurchasableVirtualItem*)purchasableItemWithProductId:(NSString*)productId;

/**
 * Retrieves a single `VirtualCategory` for the given `VirtualGood`'s `itemId`.
 *
 * @param goodItemId the item id of the `virtualGood` in the category
 * @return a `VirtualCategory` for the `VirtualGood` with the given `goodItemId`.
 * @exception VirtualItemNotFoundException when the given `goodItemId` is not found.
 */
- (VirtualCategory*)categoryForGoodWithItemId:(NSString*)goodItemId;

/**
 * Retrieves the first `UpgradeVG` for the`VirtualGood` with the given`itemId`.
 *
 * @param goodItemId the `VirtualGood` we're searching the upgrade for.
 * @return the first `UpgradeVG` for the `VirtualGood` with the given`itemId`.
 */
- (UpgradeVG*)firstUpgradeForGoodWithItemId:(NSString*)goodItemId;

/**
 * Retrieves a last `UpgradeVG` for the given `VirtualGood` `itemId`.
 *
 * @param goodItemId the `VirtualGood` we're searching the upgrade for.
 */
- (UpgradeVG*)lastUpgradeForGoodWithItemId:(NSString*)goodItemId;

/**
 * Retrieves all `UpgradeVG`s for the given `VirtualGood` `itemId`.
 *
 * @param goodItemId the `VirtualGood` we're searching the upgrades for.
 */
- (NSArray*)upgradesForGoodWithItemId:(NSString*)goodItemId;

/**
 * Retrieves all `productId`s.
 *
 * @return array of all `product Id`s
 */
- (NSArray*)allProductIds;

/**
 * Checks if the virtual good with the given `goodItemId` has upgrades.
 *
 * @return true if the good has upgrades
 */
- (BOOL)goodHasUpgrades:(NSString*)goodItemId;

/**
 * Saves the store's metadata in the database as JSON.
 */
- (void)save;

/**
 * Replaces the given virtual item, and then saves the store's metadata.
 *
 * @param virtualItem the virtual item to replace
 */
- (void)save:(VirtualItem*)virtualItem;

/**
 * Replaces an old virtual item with the given one by removing the given virtual item from the
 * relevant list if it exists, and then adds the given virtual item.
 *
 * @param virtualItem if the given virtual item exists in relevant list, replace with the
 *                    given virtual item, otherwise add the given virtual item.
 */
- (void)replaceVirtualItem:(VirtualItem*)virtualItem;
@end
