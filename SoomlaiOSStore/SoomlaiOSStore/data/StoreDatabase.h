//
//  StoreDatabase.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/18/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDatabase : NSObject {
    @private
    NSManagedObjectContext* managedContext;
}

@property (nonatomic, retain) NSManagedObjectContext* managedContext;

- (id)initWithContext:(NSManagedObjectContext*)oManagedContext;
- (void)updateCurrencyBalanceWithItemID:(NSString*)itemId andBalance:(NSNumber*)balance;
- (void)updateGoodBalanceWithItemId:(NSString*)itemId andBalance:(NSNumber*)balance;
- (NSDictionary*)getCurrencyBalanceWithItemId:(NSString*)itemId;
- (NSDictionary*)getGoodBalanceWithItemId:(NSString*)itemId;
- (void)setStoreInfo:(NSString*)storeInfoData;
- (void)setStorefrontInfo:(NSString*)storefrontInfoData;
- (NSString*)getStoreInfo;
- (NSString*)getStorefrontInfo;

@end
