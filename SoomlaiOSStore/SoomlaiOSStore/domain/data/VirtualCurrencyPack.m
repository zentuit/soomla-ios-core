//
//  VirtualCurrencyPack.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCurrencyPack.h"
#import "VirtualCurrency.h"
#import "VirtualCategory.h"
#import "JSONConsts.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"
#import "AppStoreItem.h"

@implementation VirtualCurrencyPack

@synthesize price, currencyAmount, currency, category, appstoreItem;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId andPrice:(double)oPrice andProductId:(NSString*)productId andCurrencyAmount:(int)oCurrencyAmount andCurrency:(VirtualCurrency*)oCurrency andCategory:(VirtualCategory*)oCategory{
    
    self = [super initWithName:oName andDescription:oDescription andImgFilePath:oImgFilePath andItemId:oItemId];
    if (self) {
        self.price = oPrice;
        self.currencyAmount = oCurrencyAmount;
        self.currency = oCurrency;
        self.category = oCategory;
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
        
        NSNumber* categoryId = [dict objectForKey:JSON_CURRENCYPACK_CATEGORY_ID];
        @try {
            self.category = [[StoreInfo getInstance] categoryWithId:[categoryId intValue]];
        }
        @catch (VirtualItemNotFoundException *exception) {
            NSLog(@"Can't find category with id: %@", categoryId);
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
    [toReturn setValue:[NSNumber numberWithInt:self.category.Id] forKey:JSON_CURRENCYPACK_CATEGORY_ID];
    [toReturn setValue:appstoreItem.productId forKey:JSON_CURRENCYPACK_PRODUCT_ID];
    
    return toReturn;
}

@end
