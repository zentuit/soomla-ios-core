//
//  StoreController.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StoreController.h"
#import "StoreConfig.h"
#import "StorageManager.h"
#import "StoreInfo.h"
#import "EventHandling.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"
#import "InsufficientFundsException.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@implementation StoreController

- (void)initializeWithManagedContext:(NSManagedObjectContext*)context andStoreAssets:(id<IStoreAsssets>)storeAssets{
    STORE_DEBUG = YES;
    
    [[StorageManager getInstance] initializeWithManagedContext:context];
    [[StoreInfo getInstance] initializeWithIStoreAsssets:storeAssets];
}

- (void)buyCurrencyPackWithProcuctId:(NSString*)productId{
    [EventHandling postMarketPurchaseStarted];
    
    NSSet *productIdentifiers = [NSSet setWithObject:productId];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)buyVirtualGood:(NSString*)itemId{
    [EventHandling postGoodsPurchaseStarted];
    
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:itemId];
    
    // fetching currencies and amounts that the user needs in order to purchase the current VirtualGood.
    NSDictionary* currencyValues = [good currencyValues];
    
    // preparing list of VirtualCurrency objects.
    NSMutableArray* virtualCurrencies = [[NSMutableArray alloc] init];
    for (NSString* currencyItemId in [currencyValues allKeys]){
        [virtualCurrencies addObject:[[StoreInfo getInstance] currencyWithItemId:currencyItemId]];
    }
    
    // checking if the user has enough of each of the virtual currencies in order to purchase this virtual
    // good.
    VirtualCurrency* needMore = NULL;
    for (VirtualCurrency* virtualCurrency in virtualCurrencies){
        int currencyBalance = [[StorageManager getInstance].virtualCurrencyStorage getBalanceForCurrency:virtualCurrency];
        int currencyBalanceNeeded = [(NSNumber*)[currencyValues objectForKey:virtualCurrency.itemId] intValue];
        if (currencyBalance < currencyBalanceNeeded){
            needMore = virtualCurrency;
            break;
        }
    }
    
    // if the user has enough, the virtual good is purchased.
    if (needMore == NULL){
        [[StorageManager getInstance].virtualGoodStorage addAmount:1 toGood:good];
        for (VirtualCurrency* virtualCurrency in virtualCurrencies){
            int currencyBalanceNeeded = [(NSNumber*)[currencyValues objectForKey:virtualCurrency.itemId] intValue];
            [[StorageManager getInstance].virtualCurrencyStorage removeAmount:currencyBalanceNeeded fromCurrency:virtualCurrency];
        }
        
        [EventHandling postVirtualGoodPurchased:good];
    }
    else {
        @throw [[InsufficientFundsException alloc] initWithItemId:needMore.itemId];
    }
}

- (void)storeOpening{
    if(![[StoreInfo getInstance] initializeFromDB]){
        [EventHandling postUnexpectedError];
        NSLog(@"An unexpected error occured while trying to initialize storeInfo from DB.");
        return;
    }
    
    [EventHandling postOpeningStore];
}

- (void)storeClosing{
    [EventHandling postClosingStore];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    //    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


@end
