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

/** ABSTRACT
 * This is the parent class of all virtual items in the application.
 * Almost every entity in your virtual economy will be a virtual item. There are many types
 * of virtual items, each one will extend this class. Each one of the various types extends
 * VirtualItem and adds its own behavior on top of it.
 */
@interface VirtualItem : NSObject {
    NSString* name;
    NSString* description;
    NSString* itemId;
}

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* description;
@property (retain, nonatomic) NSString* itemId;


- (id)init;

/** Constructor
 *
 * @param oName - the name of the virtual item.
 * @param oDescription - the description of the virtual item.
 * @param oItemId - the itemId of the virtual item.
 */
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription andItemId:(NSString*)oItemId;

/** Constructor
 *
 * Generates an instance of VirtualItem from an NSDictionary.
 *
 * @param dict an NSDictionary representation of the wanted VirtualItem.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 * Converts the current VirtualItem to a NSDictionary.
 */
- (NSDictionary*)toDictionary;

/**
 * Gives your user the given amount of the specific @c VirtualItem @c.
 * For example, when your user plays your game for the first time you GIVE him 1000 gems.
 *
 * NOTE: This action is different than `buy()`:
 * You use `giveAmount()` to give your user something for free.
 * You use `buy()` to give your user something and get something in return.
 *
 * @param amount the amount of the specific item to be given
 * @return balance after the giving process
 */
- (int)giveAmount:(int)amount;

/**
 * Takes from your user the given amount of the specific virtual item.
 * For example, when you want to downgrade a virtual good, you take the upgrade.
 *
 * @param amount the amount of the specific item to be taken
 * @return balance after the taking process
 */
- (int)giveAmount:(int)amount withEvent:(BOOL)notify;

/**
 * Takes from your user the given amount of the specific virtual item.
 * For example, when you want to downgrade a virtual good, you take the upgrade.
 *
 * @param amount the amount of the specific item to be taken
 * @return balance after the taking process
 */
- (int)takeAmount:(int)amount;

/**
 * Takes from your user the given amount of the specific virtual item.
 * For example, when you want to downgrade a virtual good, you take the upgrade.
 *
 * @param amount the amount of the specific item to be taken
 * @return balance after the taking process
 */
- (int)takeAmount:(int)amount withEvent:(BOOL)notify;

/**
 * Resets this Virtual Item's balance to the given balance.
 *
 * @param balance the balance of the current virtual item
 * @return balance after the reset process
 */
- (int)resetBalance:(int)balance;

/**
 * Takes from your user the given amount of the specific virtual item.
 * For example, when you want to downgrade a virtual good, you take the upgrade.
 *
 * @param amount the amount of the specific item to be taken
 * @return balance after the taking process
 */
- (int)resetBalance:(int)balance withEvent:(BOOL)notify;
@end
