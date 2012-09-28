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

#import "StorefrontJS.h"
#import "InsufficientFundsException.h"
#import "StorefrontViewController.h"
#import "VirtualItemNotFoundException.h"
#import "StoreInfo.h"
#import "StorefrontInfo.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "StorageManager.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"
#import "JSONKit.h"
#import "StoreController.h"


@implementation StorefrontJS

@synthesize sfViewController;

- (id)initWithStorefrontViewController:(StorefrontViewController*)sfvc{
    self = [super init];
    if (self){
        self.sfViewController = sfvc;
    }
    
    return self;
}

- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
	NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
	if ([components count] > 1 &&
		[(NSString *)[components objectAtIndex:0] isEqualToString:@"soomla"]) {
        
        /**
         * The user wants to buy a virtual currency pack.
         * productId is the product id of the pack.
         */
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"wantsToBuyCurrencyPacks"])
		{
            NSString* productId = [components objectAtIndex:2];
            NSLog(@"wantsToBuyCurrencyPacks %@", productId);
            
            [[StoreController getInstance] buyCurrencyPackWithProcuctId:productId];
        }
        
        /**
         * The user wants to buy a virtual good.
         * itemId is the item id of the virtual good.
         */
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"wantsToBuyVirtualGoods"])
		{
            NSString* itemId = [components objectAtIndex:2];
            NSLog(@"wantsToBuyVirtualGoods %@", itemId);
            
            @try {
                [[StoreController getInstance] buyVirtualGood:itemId];
            }
            
            @catch (InsufficientFundsException *e) {
                NSLog(@"%@", e.reason);
                
                [sfViewController sendToJSWithAction:@"insufficientFunds" andData:[NSString stringWithFormat:@"'%@'", e.itemId]];
            }
            
            @catch (VirtualItemNotFoundException *e) {
                NSLog(@"Couldn't find a VirtualGood with itemId: %@. Purchase is cancelled.", itemId);
                [sfViewController sendToJSWithAction:@"unexpectedError" andData:@""];
            }
        }
        
        /**
         * The user wants to leave the store.
         * Clicked on "close" button.
         */
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"wantsToLeaveStore"])
		{
            NSLog(@"wantsToLeaveStore");
            
            [sfViewController closeStore];
        }
        
        /**
         * The store's storefront is ready to receive calls.
         */
		if([(NSString *)[components objectAtIndex:1] isEqualToString:@"uiReady"])
		{
            NSLog(@"uiReady");
            
            sfViewController.jsUIReady = YES;
            
            NSMutableDictionary* storeInfoDict = [NSMutableDictionary dictionaryWithDictionary:[[StoreInfo getInstance] toDictionary]];
            NSDictionary* storefrontInfoDict = [[StorefrontInfo getInstance] toDictionary];
            
            [storeInfoDict setObject:[storefrontInfoDict objectForKey:@"theme"] forKey:@"theme"];
            
            NSString* initJSON = [storeInfoDict JSONString];
            
            NSLog(@"initializing JS with JSON: %@", initJSON);
            [sfViewController sendToJSWithAction:@"initialize" andData:initJSON];
            
            [self updateContentInJS];
		}
        
        /**
         * The store is initialized (everything is loaded and ready for the user).
         */
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"storeInitialized"])
		{
            NSLog(@"storeInitialized");
            
            [sfViewController loadWebView];
        }

        
		return NO;
	}
    
	return YES; // Return YES to make sure regular navigation works as expected.
}

- (void)updateContentInJS{
    NSMutableDictionary* currenciesDict = [[NSMutableDictionary alloc] init];
    for(VirtualCurrency* currency in [[StoreInfo getInstance] virtualCurrencies]){
        int balance = [[[StorageManager getInstance] virtualCurrencyStorage] getBalanceForCurrency:currency];
        [currenciesDict setValue:[NSNumber numberWithInt:balance] forKey:currency.itemId];
    }
    
    [sfViewController sendToJSWithAction:@"currencyBalanceChanged" andData:[currenciesDict JSONString]];

    NSMutableDictionary* goodsDict = [[NSMutableDictionary alloc] init];
    for(VirtualGood* good in [[StoreInfo getInstance] virtualGoods]){
        int balance = [[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:good];
        NSDictionary* updatedValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"balance", [NSNumber numberWithInt:balance],
                                       @"price", [good currencyValues],
                                       nil];
        [goodsDict setValue:updatedValues forKey:good.itemId];
    }

    [sfViewController sendToJSWithAction:@"goodsUpdated" andData:[goodsDict JSONString]];

}

@end
