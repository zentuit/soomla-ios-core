//
//  StoreInfo.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IStoreAsssets.h"

@class VirtualCategory;
@class VirtualCurrency;
@class VirtualGood;
@class VirtualCurrencyPack;

@interface StoreInfo : NSObject{
    NSArray* virtualCurrencies;
    NSArray* virtualGoods;
    NSArray* virtualCurrencyPacks;
    NSArray* virtualCategories;
}

@property (nonatomic, retain) NSArray* virtualCurrencies;
@property (nonatomic, retain) NSArray* virtualGoods;
@property (nonatomic, retain) NSArray* virtualCurrencyPacks;
@property (nonatomic, retain) NSArray* virtualCategories;

+ (StoreInfo*)getInstance;

- (void)initializeWithIStoreAsssets:(id <IStoreAsssets>)storeAssets;
- (BOOL)initializeFromDB;
- (NSDictionary*)toDictionary;

- (VirtualCategory*)categoryWithId:(int)Id;
- (VirtualGood*)goodWithItemId:(NSString*)itemId;
- (VirtualCurrency*)currencyWithItemId:(NSString*)itemId;

@end
