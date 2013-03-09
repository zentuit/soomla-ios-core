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
#import "VirtualCategory.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "VirtualCurrencyStorage.h"
#import "NonConsumableStorage.h"
#import "VirtualGoodStorage.h"
#import "InsufficientFundsException.h"
#import "NotEnoughGoodsException.h"
#import "VirtualItemNotFoundException.h"
#import "ObscuredNSUserDefaults.h"
#import "AppStoreItem.h"
#import "NonConsumableItem.h"

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

- (void)initializeWithStoreAssets:(id<IStoreAsssets>)storeAssets andCustomSecret:(NSString*)secret {
    
    if (secret && ![secret isEqualToString:@""]) {
        [ObscuredNSUserDefaults setString:secret forKey:@"ISU#LL#SE#REI"];
    } else if ([[ObscuredNSUserDefaults stringForKey:@"ISU#LL#SE#REI"] isEqualToString:@""]){
        NSLog(@"secret is null or empty. can't initialize store !!");
        return;
    }
    
    [ObscuredNSUserDefaults setInt:[storeAssets getVersion] forKey:@"SA_VER_NEW"];
    
    [StorageManager getInstance];
    [[StoreInfo getInstance] initializeWithIStoreAsssets:storeAssets];
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        if (![ObscuredNSUserDefaults boolForKey:@"RESTORED"]) {
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can Make Payments !"
//                                                        message:@"Woohoo !"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Make Payments !"
//                                                        message:@"Crap !"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}

- (void)buyAppStoreItemWithProcuctId:(NSString*)productId{
    
    AppStoreItem* asi = NULL;
    
    @try {
        VirtualCurrencyPack* pack = [[StoreInfo getInstance] currencyPackWithProductId:productId];
        asi = pack.appstoreItem;
    }
    
    @catch (VirtualItemNotFoundException *e) {
        @try {
            NonConsumableItem* nonCons = [[StoreInfo getInstance] nonConsumableItemWithProductId:productId];
            asi = nonCons.appStoreItem;
        }
        @catch (NSException *exception) {
            NSLog(@"Couldn't find a VirtualCurrencyPack or NonConsumableItem with productId: %@. Purchase is cancelled.", productId);
            @throw exception;
        }
    }
    
    if ([SKPaymentQueue canMakePayments]) {
        SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
        payment.productIdentifier = productId;
        payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        [EventHandling postMarketPurchaseStarted:asi];
    } else {
        NSLog(@"Can't make purchases. Parental control is probably enabled.");
    }
}

- (void)buyVirtualGood:(NSString*)itemId{
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:itemId];
    
    [EventHandling postGoodsPurchaseStarted];
    
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
        
        if (good.category.equippingModel == kSingle) {
            for (VirtualGood* g in [[StoreInfo getInstance] virtualGoods]) {
                if (g.category.Id == good.category.Id &&
                    ![g.itemId isEqualToString:good.itemId]) {
                    [[[StorageManager getInstance] virtualGoodStorage] equipGood:g withEquipValue:false];
                }
            }
        }
    }

    @throw [[NotEnoughGoodsException alloc] initWithItemId:itemId];
}
                         
- (void) unequipVirtualGood:(NSString*) itemId{
    VirtualGood* good = [[StoreInfo getInstance] goodWithItemId:itemId];
    
    [[[StorageManager getInstance] virtualGoodStorage] equipGood:good withEquipValue:false];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{

    NSLog(@"Transaction completed for product: %@", transaction.payment.productIdentifier);
    AppStoreItem* appStoreItem = NULL;
    
    @try{
        VirtualCurrencyPack* pack = [[StoreInfo getInstance] currencyPackWithProductId:transaction.payment.productIdentifier];
        appStoreItem = pack.appstoreItem;
    
        // updating the currency balance
        // note that a refunded purchase is treated as a purchase.
        // a friendly refund policy is nice for the user.
        [[[StorageManager getInstance] virtualCurrencyStorage] addAmount:pack.currencyAmount toCurrency:pack.currency];
    }
    @catch (VirtualItemNotFoundException* e) {
        @try{
            NonConsumableItem* nonCons = [[StoreInfo getInstance] nonConsumableItemWithProductId:transaction.payment.productIdentifier];
            appStoreItem = nonCons.appStoreItem;
            
            [[[StorageManager getInstance] nonConsumableStorage] add:nonCons];
        }
        @catch (VirtualItemNotFoundException* e) {
            NSLog(@"ERROR : Couldn't find the VirtualCurrencyPack OR AppStoreItem with productId: %@"
                  @". It's unexpected so an unexpected error is being emitted.", transaction.payment.productIdentifier);
            [EventHandling postUnexpectedError];
        }
    }
    
    if (appStoreItem != NULL) {
        [EventHandling postAppStorePurchase:appStoreItem];
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [ObscuredNSUserDefaults setBool:YES forKey:@"RESTORED"];
    NSLog(@"Restore transaction for product: %@", transaction.payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [EventHandling postTransactionRestored:transaction.payment.productIdentifier];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"An error occured for product id \"%@\" with code \"%d\" and description \"%@\"", transaction.payment.productIdentifier, transaction.error.code, transaction.error.localizedDescription);
        
        [EventHandling postUnexpectedError];
    }
    else{
        AppStoreItem* appStoreItem = NULL;
        
        @try{
            VirtualCurrencyPack* pack = [[StoreInfo getInstance] currencyPackWithProductId:transaction.payment.productIdentifier];
            appStoreItem = pack.appstoreItem;
        }
        @catch (VirtualItemNotFoundException* e) {
            @try{
                NonConsumableItem* nonCons = [[StoreInfo getInstance] nonConsumableItemWithProductId:transaction.payment.productIdentifier];
                appStoreItem = nonCons.appStoreItem;
            }
            @catch (VirtualItemNotFoundException* e) {
                NSLog(@"ERROR : Couldn't find the CANCELLED VirtualCurrencyPack OR AppStoreItem with productId: %@"
                      @". It's unexpected so an unexpected error is being emitted.", transaction.payment.productIdentifier);
                [EventHandling postUnexpectedError];
            }
        }
        
        [EventHandling postMarketPurchaseCancelled:appStoreItem];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

// When using SOOMLA's server you don't need to get information about your products. SOOMLA will keep this information
// for you and will automatically load it into your game.
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
//    NSArray *products = response.products;
//    proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
//    if (proUpgradeProduct)
//    {
//        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
//        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
//        NSLog(@"Product price: %@" , proUpgradeProduct.price);
//        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
//    }
//
//    for (NSString *invalidProductId in response.invalidProductIdentifiers)
//    {
//        NSLog(@"Invalid product id: %@" , invalidProductId);
//    }
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


@end
