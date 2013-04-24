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
#import "SingleUsePackVG.h"
#import "JSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"
#import "SingleUseVG.h"
#import "StoreInfo.h"
#import "StoreUtils.h"
#import "VirtualItemNotFoundException.h"

@implementation SingleUsePackVG

@synthesize amount, good;

static NSString* TAG = @"SOOMLA SingleUsePackVG";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andGood:(SingleUseVG *)oGood andAmount:(int)oAmount {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.good = oGood;
        self.amount = oAmount;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSString* goodItemId = [dict objectForKey:JSON_VGP_GOOD_ITEMID];
        self.amount = [[dict objectForKey:JSON_VGP_GOOD_AMOUNT] intValue];
        
        @try {
            self.good = (SingleUseVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
        }
        @catch (VirtualItemNotFoundException *exception) {
            LogError(TAG, ([NSString stringWithFormat:@"Tried to fetch single use VG with itemId '%@' but it didn't exist.", goodItemId]));
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[NSNumber numberWithInt:self.amount] forKey:JSON_VGP_GOOD_AMOUNT];
    [toReturn setValue:self.good.itemId forKey:JSON_VGP_GOOD_ITEMID];
    
    return toReturn;
}

- (void)giveAmount:(int)oAmount {
    [[[StorageManager getInstance] virtualGoodStorage] addAmount:self.amount*oAmount toItem:self.good];
}

- (void)takeAmount:(int)oAmount {
    [[[StorageManager getInstance] virtualGoodStorage] removeAmount:self.amount*oAmount fromItem:self.good];
}

- (BOOL)canBuy {
    return YES;
}

@end
