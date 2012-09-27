//
//  StorefrontController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StorefrontController.h"
#import "StorefrontViewController.h"
#import "EventHandling.h"
#import "StorefrontJS.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "StorageManager.h"
#import "VirtualCurrencyStorage.h"
#import "JSONKit.h"
#import "StorefrontInfo.h"

@implementation StorefrontController

@synthesize sfViewController;

+ (StorefrontController*)getInstance{
    static StorefrontController* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StorefrontController alloc ] init];
        }
    }
    
    return _instance;
}

- (void)openStoreWithParentViewController:(UIViewController *)viewController andStorefrontInfoJSON:(NSString*)storefrontJSON{

    [[StorefrontInfo getInstance] initializeWithJSON:storefrontJSON];
    
//    UIStoryboard *storyboard = [viewController storyboard];
    StorefrontViewController *svc = [[StorefrontViewController alloc] init];
    
    [viewController presentViewController:svc animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(virtualCurrencyPackPurchased:) name:EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(virtualGoodPurchased:) name:EVENT_VIRTUAL_GOOD_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billingNotSupported:) name:EVENT_BILLING_NOT_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closingStore:) name:EVENT_CLOSING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unexpectedError:) name:EVENT_UNEXPECTED_ERROR_IN_STORE object:nil];
}

- (void)virtualCurrencyPackPurchased:(NSNotification*)notification{
    NSDictionary* userInfo = notification.userInfo;
    VirtualCurrencyPack* pack = [userInfo objectForKey:@"VirtualCurrencyPack"];
    VirtualCurrency* currency = pack.currency;
    
    int balance = [[[StorageManager getInstance] virtualCurrencyStorage] getBalanceForCurrency:currency];
    NSDictionary* currencyBalanceDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         currency.itemId, [NSNumber numberWithInt:balance], nil];
    [sfViewController sendToJSWithAction:@"currencyBalanceChanged" andData:[currencyBalanceDict JSONString]];
}

- (void)virtualGoodPurchased:(NSNotification*)notification{
    [sfViewController.storefrontJS updateContentInJS];
}

- (void)billingNotSupported:(NSNotification*)notification{
    [sfViewController sendToJSWithAction:@"disableCurrencyStore" andData:@""];
}

- (void)closingStore:(NSNotification*)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)unexpectedError:(NSNotification*)notification{
    [sfViewController sendToJSWithAction:@"unexpectedError" andData:@""];
}

@end
