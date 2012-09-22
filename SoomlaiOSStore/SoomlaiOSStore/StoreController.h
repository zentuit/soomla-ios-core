//
//  StoreController.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IStoreAsssets.h"

@interface StoreController : NSObject <SKProductsRequestDelegate>{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

- (void)initializeWithManagedContext:(NSManagedObjectContext*)context andStoreAssets:(id<IStoreAsssets>)storeAssets;
- (void)buyCurrencyPackWithProcuctId:(NSString*)productId;
- (void)buyVirtualGood:(NSString*)itemId;
- (void)storeOpening;
- (void)storeClosing;

@end
