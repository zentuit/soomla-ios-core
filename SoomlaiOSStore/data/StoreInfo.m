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

#import "StoreInfo.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "JSONKit.h"
#import "JSONConsts.h"
#import "VirtualCategory.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "AppStoreItem.h"
#import "VirtualItemNotFoundException.h"
#import "StoreEncryptor.h"

@implementation StoreInfo

@synthesize virtualCategories, virtualCurrencies, virtualCurrencyPacks, virtualGoods, appStoreNonConsumableItems;

+ (StoreInfo*)getInstance{
    static StoreInfo* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StoreInfo alloc ] init];
        }
    }
    
    return _instance;
}

- (void)initializeWithIStoreAsssets:(id <IStoreAsssets>)storeAssets{
    if(storeAssets == NULL){
        NSLog(@"The given store assets can't be null !");
        return;
    }

    if (![self initializeFromDB]){
        /// fall-back here if the json doesn't exist, we load the store from the given IStoreAssets.
        self.virtualCategories = [storeAssets virtualCategories];
        self.virtualCurrencies = [storeAssets virtualCurrencies];
        self.virtualCurrencyPacks = [storeAssets virtualCurrencyPacks];
        self.virtualGoods = [storeAssets virtualGoods];
        self.appStoreNonConsumableItems = [storeAssets appStoreNonConsumableItems];
        
        // put StoreInfo in the database as JSON
        NSString* storeInfoJSON = [[self toDictionary] JSONString];
//        NSLog(@"%@", storeInfoJSON);
        NSString* ec = [[NSString alloc] initWithData:[storeInfoJSON dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
        NSString* enc = [StoreEncryptor encryptString:ec];
        [[[StorageManager getInstance] database] setStoreInfo:enc];
    }
}

- (BOOL)initializeFromDB{
    // first, trying to load StoreInfo from the local DB.
    NSString* storeInfoJSON = [[[StorageManager getInstance] database] getStoreInfo];
    if(!storeInfoJSON || [storeInfoJSON isEqual:[NSNull null]] || [storeInfoJSON length] == 0){
        return false;
    }
    
    storeInfoJSON = [StoreEncryptor decryptToString:storeInfoJSON];
    
    NSDictionary* storeInfo = [storeInfoJSON objectFromJSONString];
    
    NSMutableArray* categories = [[NSMutableArray alloc] init];
    NSArray* categoriesDicts = [storeInfo objectForKey:JSON_STORE_VIRTUALCATEGORIES];
    for(NSDictionary* categoryDict in categoriesDicts){
        [categories addObject:[[VirtualCategory alloc] initWithDictionary: categoryDict]];
    }
    self.virtualCategories = categories;
    
    NSMutableArray* currencies = [[NSMutableArray alloc] init];
    NSArray* currenciesDicts = [storeInfo objectForKey:JSON_STORE_VIRTUALCURRENCIES];
    for(NSDictionary* currencyDict in currenciesDicts){
        [currencies addObject:[[VirtualCurrency alloc] initWithDictionary: currencyDict]];
    }
    self.virtualCurrencies = currencies;
    
    NSMutableArray* currencyPacks = [[NSMutableArray alloc] init];
    NSArray* currencyPacksDicts = [storeInfo objectForKey:JSON_STORE_CURRENCYPACKS];
    for(NSDictionary* currencyPackDict in currencyPacksDicts){
        [currencyPacks addObject:[[VirtualCurrencyPack alloc] initWithDictionary: currencyPackDict]];
    }
    self.virtualCurrencyPacks = currencyPacks;
    
    NSMutableArray* goods = [[NSMutableArray alloc] init];
    NSArray* goodsDicts = [storeInfo objectForKey:JSON_STORE_VIRTUALGOODS];
    for(NSDictionary* goodDict in goodsDicts){
        [goods addObject:[[VirtualGood alloc] initWithDictionary: goodDict]];
    }
    self.virtualGoods = goods;
    
    NSMutableArray* nonConsumableItems = [[NSMutableArray alloc] init];
    NSArray* nonConsumableItemsDict = [storeInfo objectForKey:JSON_STORE_NONCONSUMABLE];
    for(NSDictionary* nonConsumableItemDict in nonConsumableItemsDict){
        [nonConsumableItems addObject:[[AppStoreItem alloc] initWithDictionary:nonConsumableItemDict]];
    }
    self.appStoreNonConsumableItems = nonConsumableItems;
    
    return YES;
}

- (NSDictionary*)toDictionary{
    
    NSMutableArray* categories = [[NSMutableArray alloc] init];
    for(VirtualCategory* c in self.virtualCategories){
        [categories addObject:[c toDictionary]];
    }
    
    NSMutableArray* currencies = [[NSMutableArray alloc] init];
    for(VirtualCurrency* c in self.virtualCurrencies){
        [currencies addObject:[c toDictionary]];
    }
    
    NSMutableArray* goods = [[NSMutableArray alloc] init];
    for(VirtualGood* c in self.virtualGoods){
        [goods addObject:[c toDictionary]];
    }
    
    NSMutableArray* packs = [[NSMutableArray alloc] init];
    for(VirtualCurrencyPack* c in self.virtualCurrencyPacks){
        [packs addObject:[c toDictionary]];
    }
    
    NSMutableArray* nonConsumables = [[NSMutableArray alloc] init];
    for(AppStoreItem* appStoreItem in self.appStoreNonConsumableItems) {
        [nonConsumables addObject:[appStoreItem toDictionary]];
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:categories forKey:JSON_STORE_VIRTUALCATEGORIES];
    [dict setObject:currencies forKey:JSON_STORE_VIRTUALCURRENCIES];
    [dict setObject:packs forKey:JSON_STORE_CURRENCYPACKS];
    [dict setObject:goods forKey:JSON_STORE_VIRTUALGOODS];
    [dict setObject:nonConsumables forKey:JSON_STORE_NONCONSUMABLE];
    
    return dict;
}

- (VirtualCategory*)categoryWithId:(int)Id{
    for(VirtualCategory* c in self.virtualCategories){
        if (c.Id == Id){
            return c;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"Id" andLookupValue:[NSString stringWithFormat:@"%d", Id]];
}

- (VirtualGood*)goodWithItemId:(NSString*)itemId{
    for(VirtualGood* g in self.virtualGoods){
        if ([g.itemId isEqualToString:itemId]){
            return g;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"itemId" andLookupValue:itemId];
}

- (VirtualCurrency*)currencyWithItemId:(NSString*)itemId{
    for(VirtualCurrency* c in self.virtualCurrencies){
        if ([c.itemId isEqualToString:itemId]){
            return c;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"itemId" andLookupValue:itemId];
}

- (VirtualCurrencyPack*)currencyPackWithProductId:(NSString*)productId{
    for(VirtualCurrencyPack* p in self.virtualCurrencyPacks){
        if ([p.appstoreItem.productId isEqualToString:productId]){
            return p;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"productId" andLookupValue:productId];
}

- (VirtualCurrencyPack*)currencyPackWithItemId:(NSString*)itemId{
    for(VirtualCurrencyPack* p in self.virtualCurrencyPacks){
        if ([p.itemId isEqualToString:itemId]){
            return p;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"itemId" andLookupValue:itemId];
}

- (AppStoreItem*)appStoreNonConsumableItemWithProductId:(NSString*)productId{
    for (AppStoreItem* appStoreItem in self.appStoreNonConsumableItems){
        if ([appStoreItem.productId isEqualToString:productId]){
            return appStoreItem;
        }
    }
    
    @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"productId" andLookupValue:productId];
}

@end
