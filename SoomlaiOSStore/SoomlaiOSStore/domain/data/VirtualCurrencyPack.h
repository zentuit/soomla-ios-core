//
//  VirtualCurrencyPack.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualItem.h"

@class VirtualCurrency;
@class VirtualCategory;
@class AppStoreItem;

@interface VirtualCurrencyPack : VirtualItem{
    double  price;
    int     currencyAmount;
    VirtualCurrency* currency;
    VirtualCategory* category;
    AppStoreItem* appstoreItem;
}

@property double  price;
@property int     currencyAmount;
@property (retain, nonatomic) VirtualCurrency* currency;
@property (retain, nonatomic) VirtualCategory* category;
@property (retain, nonatomic) AppStoreItem* appstoreItem;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId andPrice:(double)oPrice
    andProductId:(NSString*)productId andCurrencyAmount:(int)oCurrencyAmount andCurrency:(VirtualCurrency*)currency andCategory:(VirtualCategory*)oCategory;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@end
