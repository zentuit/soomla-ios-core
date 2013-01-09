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

@synthesize currencyAmount, currency, appstoreItem;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andItemId:(NSString*)oItemId andPrice:(double)oPrice andProductId:(NSString*)productId andCurrencyAmount:(int)oCurrencyAmount andCurrency:(VirtualCurrency*)oCurrency{
    
    self = [super initWithName:oName andDescription:oDescription andItemId:oItemId];
    if (self) {
        self.currencyAmount = oCurrencyAmount;
        self.currency = oCurrency;
        self.appstoreItem = [[AppStoreItem alloc] initWithProductId:productId andConsumable:kConsumable andPrice:oPrice];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super initWithDictionary:dict];
    if (self) {
        NSNumber* amountNum = [dict objectForKey:JSON_CURRENCYPACK_AMOUNT];
        self.currencyAmount = [amountNum intValue];
        self.appstoreItem = [[AppStoreItem alloc] initWithDictionary:dict];
        
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
    NSDictionary* aiDict = [appstoreItem toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [aiDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [toReturn setObject: obj forKey: key];
    }];
    [toReturn setValue:[NSNumber numberWithInt:self.currencyAmount] forKey:JSON_CURRENCYPACK_AMOUNT];
    [toReturn setValue:self.currency.itemId forKey:JSON_CURRENCYPACK_CURRENCYITEMID];
    
    return toReturn;
}

@end
