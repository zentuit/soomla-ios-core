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

#import <Foundation/Foundation.h>

@class VirtualItem;

/** ABSTRACT
 * This class is an abstract definition of a Virtual Item Storage.
 */
@interface VirtualItemStorage : NSObject {
    @protected
    NSString* tag;
}

/**
 * Retrieves the balance of the given virtual item.
 *
 * @param item the required virtual item.
 */
- (int)balanceForItem:(VirtualItem*)item;

/**
 * Adds the given amount of items to the storage.
 *
 * @param item the required virtual item.
 * @param amount the amount of items to add.
 */
- (int)addAmount:(int)amount toItem:(VirtualItem*)item;
- (int)addAmount:(int)amount toItem:(VirtualItem*)item withEvent:(BOOL)notify;

/**
 * Removes the given amount from the given virtual item's balance.
 *
 * @param item the virtual item to remove the given amount from.
 * @param amount the amount to remove.
 */
- (int)removeAmount:(int)amount fromItem:(VirtualItem*)item;
- (int)removeAmount:(int)amount fromItem:(VirtualItem*)item withEvent:(BOOL)notify;

/**
 * Sets the balance of the given virtual item.
 *
 * @param item the required virtual item.
 */
- (int)setBalance:(int)balance toItem:(VirtualItem*)item;
- (int)setBalance:(int)balance toItem:(VirtualItem*)item withEvent:(BOOL)notify;

/**
 * Retrieves the balance of the virtual item with the given itemId (from the KeyValDatabase).
 *
 * @param itemId id of the virtual item whose balance is to be retrieved.
 * @return String containing name of storage base, itemId, and balance
 */
- (NSString*)keyBalance:(NSString*)itemId;

/**
 * Posts the given amount changed in the given balance of the given virtual item.
 *
 * @param item virtual item whose balance has changed.
 * @param balance the balance that has changed.
 * @param amountAdded the amount added to the item's balance.
 */
- (void)postBalanceChangeToItem:(VirtualItem*)item withBalance:(int)balance andAmountAdded:(int)amountAdded;

@end
