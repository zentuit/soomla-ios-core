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

#import "PurchasableVirtualItem.h"

/**
 * A representation of a non-consumable item in the Market. These kinds of items are bought by the user once and kept for him forever.
 *
 * NOTE: Don't be confused: this is not a Lifetime VirtualGood, it's a MANAGED item in the Market. This means that the product can be purchased only once per user (such as a new levelin a game), and is remembered by the Market (can be restored if this application is uninstalled and then re-installed).
 * If you want to make a LifetimeVG available for purchase in the market (purchase with real money $$), you will need to declare it as a NonConsumableItem.
 *
 * Inheritance: NonConsumableItem > PurchasableVirtualItem > VirtualItem
 */
@interface NonConsumableItem : PurchasableVirtualItem {
}

/** Constructor
 *
 * oName see parent
 * oDescription see parent
 * oItemId see parent
 * oPurchaseType see parent
 */
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
                andItemId:(NSString*)oItemId andPurchaseType:(PurchaseType*)oPurchaseType;

/**
 * see parent
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 * see parent
 */
- (NSDictionary*)toDictionary;

@end
