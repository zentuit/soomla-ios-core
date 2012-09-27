//
//  EventHandling.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "EventHandling.h"
#import "VirtualCurrencyPack.h"
#import "VirtualGood.h"

NSString * EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED = @"VirtualCurrencyPackPurchased";
NSString * EVENT_VIRTUAL_GOOD_PURCHASED          = @"VirtualGoodPurchased";
NSString * EVENT_BILLING_SUPPORTED               = @"BillingSupported";
NSString * EVENT_BILLING_NOT_SUPPORTED           = @"BillingNotSupported";
NSString * EVENT_MARKET_PURCHASE_STARTED         = @"MarketPurchaseProcessStarted";
NSString * EVENT_GOODS_PURCHASE_STARTED          = @"GoodsPurchaseProcessStarted";
NSString * EVENT_CLOSING_STORE                   = @"ClosingStore";
NSString * EVENT_OPENING_STORE                   = @"OpeningStore";
NSString * EVENT_UNEXPECTED_ERROR_IN_STORE       = @"UnexpectedErrorInStore";

@implementation EventHandling

+ (void)observeAllEventsWithObserver:(id)observer andSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_VIRTUAL_GOOD_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_NOT_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOODS_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_CLOSING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_OPENING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_UNEXPECTED_ERROR_IN_STORE object:nil];
}

+ (void)postVirtualCurrencyPackPurchased:(VirtualCurrencyPack*)pack{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:pack forKey:@"VirtualCurrencyPack"];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED object:self userInfo:userInfo];
}

+ (void)postVirtualGoodPurchased:(VirtualGood*)good{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:good forKey:@"VirtualGood"];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_VIRTUAL_GOOD_PURCHASED object:self userInfo:userInfo];
}

+ (void)postBillingSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_SUPPORTED object:self];
}

+ (void)postBillingNotSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_NOT_SUPPORTED object:self];
}

+ (void)postGoodsPurchaseStarted{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOODS_PURCHASE_STARTED object:self];
}

+ (void)postMarketPurchaseStarted{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_STARTED object:self];
}

+ (void)postClosingStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSING_STORE object:self];
}

+ (void)postOpeningStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_OPENING_STORE object:self];
}

+ (void)postUnexpectedError{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UNEXPECTED_ERROR_IN_STORE object:self];
}

@end
