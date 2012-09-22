//
//  StoreInfo.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StoreInfo.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "JSONKit.h"
#import "JSONConsts.h"
#import "VirtualCategory.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "VirtualItemNotFoundException.h"

@implementation StoreInfo

@synthesize virtualCategories, virtualCurrencies, virtualCurrencyPacks, virtualGoods;

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
        self.virtualCategories = [storeAssets virtualCategories];
        self.virtualCurrencies = [storeAssets virtualCurrencies];
        self.virtualCurrencyPacks = [storeAssets virtualCurrencyPacks];
        self.virtualGoods = [storeAssets virtualGoods];
        
        NSString* storeInfoJSON = [[self toDictionary] JSONString];
        [[[StorageManager getInstance] database] setStoreInfo:storeInfoJSON];
    }
}

- (BOOL)initializeFromDB{
    NSString* storeInfoJSON = [[[StorageManager getInstance] database] getStoreInfo];
    if([storeInfoJSON length] == 0){
        return false;
    }
    
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
        [goods addObject:[[VirtualCurrencyPack alloc] initWithDictionary: goodDict]];
    }
    self.virtualGoods = goods;
    
    return YES;
}

- (NSDictionary*)toDictionary{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.virtualCategories forKey:JSON_STORE_VIRTUALCATEGORIES];
    [dict setObject:self.virtualCurrencies forKey:JSON_STORE_VIRTUALCURRENCIES];
    [dict setObject:self.virtualCurrencyPacks forKey:JSON_STORE_CURRENCYPACKS];
    [dict setObject:self.virtualGoods forKey:JSON_STORE_VIRTUALGOODS];
    
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

@end
