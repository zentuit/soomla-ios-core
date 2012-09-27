//
//  StoreDatabase.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/18/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDatabase : NSObject {

}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)updateCurrencyBalanceWithItemID:(NSString*)itemId andBalance:(NSNumber*)balance;
- (void)updateGoodBalanceWithItemId:(NSString*)itemId andBalance:(NSNumber*)balance;
- (NSDictionary*)getCurrencyBalanceWithItemId:(NSString*)itemId;
- (NSDictionary*)getGoodBalanceWithItemId:(NSString*)itemId;
- (void)setStoreInfo:(NSString*)storeInfoData;
- (void)setStorefrontInfo:(NSString*)storefrontInfoData;
- (NSString*)getStoreInfo;
- (NSString*)getStorefrontInfo;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
