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

#import "VirtualCurrencyPack.h"
#import "VirtualCurrency.h"
#import "JSONConsts.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"
#import "AppStoreItem.h"

@implementation VirtualCurrencyPack

@synthesize price, currencyAmount, currency, appstoreItem;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andItemId:(NSString*)oItemId andPrice:(double)oPrice andProductId:(NSString*)productId andCurrencyAmount:(int)oCurrencyAmount andCurrency:(VirtualCurrency*)oCurrency{
    
    self = [super initWithName:oName andDescription:oDescription andItemId:oItemId];
    if (self) {
        self.price = oPrice;
        self.currencyAmount = oCurrencyAmount;
        self.currency = oCurrency;
        self.appstoreItem = [[AppStoreItem alloc] initWithProductId:productId andConsumable:kConsumable];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super initWithDictionary:dict];
    if (self) {
        NSNumber* priceNum = [dict objectForKey:JSON_CURRENCYPACK_PRICE];
        self.price = [priceNum doubleValue];
        NSNumber* amountNum = [dict objectForKey:JSON_CURRENCYPACK_AMOUNT];
        self.currencyAmount = [amountNum intValue];
        NSString* productId = [dict objectForKey:JSON_CURRENCYPACK_PRODUCT_ID];
        self.appstoreItem = [[AppStoreItem alloc] initWithProductId:productId andConsumable:kConsumable];
        
        NSString* currencyItemId = [dict objectForKey:JSON_CURRENCYPACK_CURRENCYITEMID];
        @try {
            self.currency = [[StoreInfo getInstance] currencyWithItemId:currencyItemId];
        }
        @catch (VirtualItemNotFoundException *exception) {
            NSLog(@"Couldn't find the associated currency. itemId: %@", currencyItemId);
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[NSNumber numberWithDouble:self.price] forKey:JSON_CURRENCYPACK_PRICE];
    [toReturn setValue:[NSNumber numberWithInt:self.currencyAmount] forKey:JSON_CURRENCYPACK_AMOUNT];
    [toReturn setValue:self.currency.itemId forKey:JSON_CURRENCYPACK_CURRENCYITEMID];
    [toReturn setValue:appstoreItem.productId forKey:JSON_CURRENCYPACK_PRODUCT_ID];
    
    return toReturn;
}

@end
