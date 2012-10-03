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
#import "NotEnoughGoodsException.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@implementation StoreController

+ (StoreController*)getInstance{
    static StoreController* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StoreController alloc ] init];
        }
    }
    
    return _instance;
}

- (void)initializeWithStoreAssets:(id<IStoreAsssets>)storeAssets{
    STORE_DEBUG = YES;
    
    [StorageManager getInstance];
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


- (void) equipVirtualGood:(NSString*) itemId{
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:itemId];
    
    // if the user has enough, the virtual good is purchased.
    if ([[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:good] > 0){
        [[[StorageManager getInstance] virtualGoodStorage] equipGood:good withEquipValue:true];
        
        [EventHandling postVirtualGoodEquipped:good];
    }

    @throw [[NotEnoughGoodsException alloc] initWithItemId:itemId];
}
                         
- (void) unequipVirtualGood:(NSString*) itemId{
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:itemId];
    
    [[[StorageManager getInstance] virtualGoodStorage] equipGood:good withEquipValue:false];
    
    [EventHandling postVirtualGoodUnEquipped:good];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


@end
