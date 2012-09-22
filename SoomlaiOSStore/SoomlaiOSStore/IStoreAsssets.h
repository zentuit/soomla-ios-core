//
//  IStoreAsssets.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

/**
 * This protocol represents a single game's metadata.
 * Use this protocol to create your assets class that will be transferred to StoreInfo
 * upon initialization.
 */
@protocol IStoreAsssets <NSObject>

/**
 * A representation of your game's virtual currency.
 */
- (NSArray*)virtualCurrencies;

/**
 * An array of all virtual goods served by your store.
 * NOTE: The order of the items in the array will be their order when shown to the user.
 */
- (NSArray*)virtualGoods;

/**
 * An array of all virtual currency packs served by your store.
 * NOTE: The order of the items in the array will be their order when shown to the user.
 */
- (NSArray*)virtualCurrencyPacks;

/**
 * An array of all virtual categories served by your store.
 */
- (NSArray*)virtualCategories;

@end
