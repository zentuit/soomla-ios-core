//
//  EventHandling.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED;
extern NSString * EVENT_VIRTUAL_GOOD_PURCHASED;
extern NSString * EVENT_BILLING_SUPPORTED;
extern NSString * EVENT_BILLING_NOT_SUPPORTED;
extern NSString * EVENT_MARKET_PURCHASE_STARTED;
extern NSString * EVENT_GOODS_PURCHASE_STARTED;
extern NSString * EVENT_CLOSING_STORE;
extern NSString * EVENT_OPENING_STORE;
extern NSString * EVENT_UNEXPECTED_ERROR_IN_STORE;

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
