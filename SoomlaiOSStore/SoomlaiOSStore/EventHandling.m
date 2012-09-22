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

NSString * VIRTUAL_CURRENCY_PACK_PURCHASED = @"VirtualCurrencyPackPurchased";
NSString * VIRTUAL_GOOD_PURCHASED          = @"VirtualGoodPurchased";
NSString * BILLING_SUPPORTED               = @"BillingSupported";
NSString * BILLING_NOT_SUPPORTED           = @"BillingNotSupported";
NSString * MARKET_PURCHASE_STARTED         = @"MarketPurchaseProcessStarted";
NSString * GOODS_PURCHASE_STARTED          = @"GoodsPurchaseProcessStarted";
NSString * CLOSING_STORE                   = @"ClosingStore";
NSString * OPENING_STORE                   = @"OpeningStore";
NSString * UNEXPECTED_ERROR_IN_STORE       = @"UnexpectedErrorInStore";

@implementation EventHandling

+ (void)observeAllEventsWithObserver:(id)observer andSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:VIRTUAL_CURRENCY_PACK_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:VIRTUAL_GOOD_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:BILLING_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:BILLING_NOT_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:MARKET_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:GOODS_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:CLOSING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:OPENING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:UNEXPECTED_ERROR_IN_STORE object:nil];
}

+ (void)postVirtualCurrencyPackPurchased:(VirtualCurrencyPack*)pack{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:pack forKey:@"VirtualCurrencyPack"];
    [[NSNotificationCenter defaultCenter] postNotificationName:VIRTUAL_CURRENCY_PACK_PURCHASED object:self userInfo:userInfo];
}

+ (void)postVirtualGoodPurchased:(VirtualGood*)good{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:good forKey:@"VirtualGood"];
    [[NSNotificationCenter defaultCenter] postNotificationName:VIRTUAL_GOOD_PURCHASED object:self userInfo:userInfo];
}

+ (void)postBillingSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:BILLING_SUPPORTED object:self];
}

+ (void)postBillingNotSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:BILLING_NOT_SUPPORTED object:self];
}

+ (void)postGoodsPurchaseStarted{
    [[NSNotificationCenter defaultCenter] postNotificationName:GOODS_PURCHASE_STARTED object:self];
}

+ (void)postMarketPurchaseStarted{
    [[NSNotificationCenter defaultCenter] postNotificationName:MARKET_PURCHASE_STARTED object:self];
}

+ (void)postClosingStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSING_STORE object:self];
}

+ (void)postOpeningStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:OPENING_STORE object:self];
}

+ (void)postUnexpectedError{
    [[NSNotificationCenter defaultCenter] postNotificationName:UNEXPECTED_ERROR_IN_STORE object:self];
}

@end
