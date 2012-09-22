//
//  IStoreEventHandler.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VirtualCurrencyPack;
@class VirtualGood;

@protocol IStoreEventHandler <NSObject>

- (void)onVirtualCurrencyPackPurchased:(VirtualCurrencyPack*) pack;
- (void)onVirtualGoodPurchased:(VirtualGood*) good;
- (void)onBillingSupported;
- (void)onBillingNotSupported;
- (void)onMarketPurchaseProcessStarted;
- (void)onGoodsPurchaseProcessStarted;
- (void)onClosingStore;
- (void)onUnexpectedErrorInStore;
- (void)onOpeningStore;

@end
