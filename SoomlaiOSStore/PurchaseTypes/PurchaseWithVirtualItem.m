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

#import "PurchaseWithVirtualItem.h"
#import "StoreUtils.h"
#import "VirtualItem.h"
#import "EventHandling.h"
#import "PurchasableVirtualItem.h"
#import "VirtualItemStorage.h"
#import "StorageManager.h"
#import "InsufficientFundsException.h"

@implementation PurchaseWithVirtualItem

@synthesize item, amount;

static NSString* TAG = @"SOOMLA PurchaseWithVirtualItem";

- (id) initWithVirtualItem:(VirtualItem*)oItem andAmount:(int)oAmount {
    if (self = [super init]) {
        self.item = oItem;
        self.amount = oAmount;
    }
    
    return self;
}


- (void)buy {
    LogDebug(TAG, ([NSString stringWithFormat:@"Trying to buy a %@ with %d pieces of %@.",
                    self.associatedItem.name, self.amount, self.item.name]));
    
    [EventHandling postItemPurchaseStarted:self.associatedItem];
    
    VirtualItemStorage* storage = [[StorageManager getInstance] virtualItemStorage:self.item];
    
    assert(storage);
    
    int balance = [storage balanceForItem:self.item];
    if (balance < amount) {
        @throw [[InsufficientFundsException alloc] initWithItemId:self.item.itemId];
    }
    
    [storage removeAmount:amount fromItem:self.item];
    
    [self.associatedItem giveAmount:1];
    [EventHandling postItemPurchased:self.associatedItem];
}


@end
