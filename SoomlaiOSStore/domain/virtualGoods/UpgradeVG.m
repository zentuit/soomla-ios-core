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

#import "UpgradeVG.h"
#import "JSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"
#import "StoreUtils.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"

@implementation UpgradeVG

@synthesize level, prev, good;

static NSString* TAG = @"SOOMLA UpgradeVG";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andLinkedGood:(VirtualGood*)oGood andLevel:(int)oLevel andPreviousUpgrade:(UpgradeVG*)oPrev {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.level = oLevel;
        self.prev = oPrev;
        self.good = oGood;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSString* goodItemId = [dict objectForKey:JSON_VGU_GOOD_ITEMID];
        NSString* prevItemId = [dict objectForKey:JSON_VGU_PREV_ITEMID];
        level = [[dict objectForKey:JSON_VGU_LEVEL] intValue];
        
        @try {
            self.good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
            self.prev = (!prevItemId) ? nil : (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:prevItemId];
        }
        @catch (VirtualItemNotFoundException *ex) {
            LogError(TAG, @"The wanted virtual good was not found.");
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[NSNumber numberWithInt:self.level] forKey:JSON_VGU_LEVEL];
    [toReturn setValue:self.good.itemId forKey:JSON_VGU_GOOD_ITEMID];
    [toReturn setValue:(self.prev ? self.prev.itemId : @"") forKey:JSON_VGU_PREV_ITEMID];
    
    return toReturn;
}

/**
 * Assigning the current upgrade to the associated VirtualGood (mGood).
 *
 * This action doesn't check nothing!! It just assigns the current UpgradeVG to the associated mGood.
 *
 * amount is NOT USED HERE !
 */
- (void)giveAmount:(int)amount {
    LogDebug(TAG, ([NSString stringWithFormat:@"Assigning %@ to: %@", self.name, self.good.name]));
    
    [[[StorageManager getInstance] virtualGoodStorage] assignCurrentUpgrade:self toGood:self.good];
}

/**
 * This is actually a downgrade of the associated VirtualGood (mGood).
 * We check if the current Upgrade is really associated with the VirtualGood and:
 *  if YES we downgrade to the previous upgrade (or removing upgrades in case of null).
 *  if NO we return (do nothing).
 *
 * amount is NOT USED HERE !
 */
- (void)takeAmount:(int)amount {
    UpgradeVG* upgradeVG = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:self.good];
    if (upgradeVG != self) {
        LogError(TAG, ([NSString stringWithFormat:@"You can't take what's not yours. The UpgradeVG %@ is not assigned to the VirtualGood: %@", self.name, self.good.name]));
        return;
    }
    
    if (self.prev) {
        LogDebug(TAG, ([NSString stringWithFormat:@"Downgrading %@ to %@", self.good.name, self.prev.name]));
        [[[StorageManager getInstance] virtualGoodStorage] assignCurrentUpgrade:self.prev toGood:self.good];
    } else {
        LogDebug(TAG, ([NSString stringWithFormat:@"Downgrading %@ to NO-UPGRADE", self.good.name]));
        [[[StorageManager getInstance] virtualGoodStorage] removeUpgradesFrom:self.good];
    }
}

- (BOOL)canBuy {
    UpgradeVG* upgradeVG = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:self.good];
    return ((!upgradeVG) && self.level==1) ||
            (upgradeVG && ((upgradeVG.level == (self.level-1)) || (upgradeVG.level == (self.level+1))));
}



@end
