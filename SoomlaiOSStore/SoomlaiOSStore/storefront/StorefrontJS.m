//
//  StorefrontController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

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
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"wantsToBuyCurrencyPacks"])
		{
            NSString* productId = [components objectAtIndex:2];
            NSLog(@"wantsToBuyCurrencyPacks %@", productId);
            
            [[StoreController getInstance] buyCurrencyPackWithProcuctId:productId];
        }
        
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
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"wantsToLeaveStore"])
		{
            NSLog(@"wantsToLeaveStore");
            
            [sfViewController closeStore];
        }
        
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
