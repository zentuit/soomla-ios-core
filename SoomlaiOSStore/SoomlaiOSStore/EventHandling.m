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

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector{
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
