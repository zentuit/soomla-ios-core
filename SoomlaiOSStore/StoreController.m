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
#import "VirtualCurrencyPack.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"
#import "InsufficientFundsException.h"
#import "NotEnoughGoodsException.h"
#import "VirtualItemNotFoundException.h"

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
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can Make Payments !"
                                                        message:@"Woohoo !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Make Payments !"
                                                        message:@"Crap !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)buyCurrencyPackWithProcuctId:(NSString*)productId{
    [EventHandling postMarketPurchaseStarted];
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
    payment.productIdentifier = productId;
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
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
    
    @try{
        VirtualCurrencyPack* pack = [[StoreInfo getInstance] currencyPackWithProductId:transaction.payment.productIdentifier];
    
        // updating the currency balance
        // note that a refunded purchase is treated as a purchase.
        // a friendly refund policy is nice for the user.
        [[[StorageManager getInstance] virtualCurrencyStorage] addAmount:pack.currencyAmount toCurrency:pack.currency];
        
        [EventHandling postVirtualCurrencyPackPurchased:pack];
    }
    @catch (VirtualItemNotFoundException* e) {
        NSLog(@"Hey man... This is serious !!! Some of the items' productIds you provided "
              @"ios-store doesn't correlate to the productId on itunes connect. "
              @"Your user was charged but she won't get the actual product in your game. "
              @"You will have to issue a refund now. Check the CurrencyPacks' productIds now! "
              @"Couldn't find a VirtualCurrencyPack with productId: %@", transaction.payment.productIdentifier);
        [EventHandling postUnexpectedError];
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Restore transaction for product: %@", transaction.payment.productIdentifier);
    [EventHandling postTransactionRestored:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"An error occured for product id \"%@\" with code \"%d\" and description \"%@\"", transaction.payment.productIdentifier, transaction.error.code, transaction.error.localizedDescription);
        
        [EventHandling postUnexpectedError];
    }
    else{
        NSLog(@"payment was canceled by the user. doing nothing for now.");
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
