//
//  EventHandling.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * VIRTUAL_CURRENCY_PACK_PURCHASED;
extern NSString * VIRTUAL_GOOD_PURCHASED;
extern NSString * BILLING_SUPPORTED;
extern NSString * BILLING_NOT_SUPPORTED;
extern NSString * MARKET_PURCHASE_STARTED;
extern NSString * GOODS_PURCHASE_STARTED;
extern NSString * CLOSING_STORE;
extern NSString * OPENING_STORE;
extern NSString * UNEXPECTED_ERROR_IN_STORE;

@class VirtualCurrencyPack;
@class VirtualGood;

@interface EventHandling : NSObject

+ (void)observeAllEventsWithObserver:(id)observer andSelector:(SEL)selector;

+ (void)postVirtualCurrencyPackPurchased:(VirtualCurrencyPack*)pack;
+ (void)postVirtualGoodPurchased:(VirtualGood*)good;
+ (void)postBillingSupported;
+ (void)postBillingNotSupported;
+ (void)postGoodsPurchaseStarted;
+ (void)postMarketPurchaseStarted;
+ (void)postClosingStore;
+ (void)postOpeningStore;
+ (void)postUnexpectedError;

@end
