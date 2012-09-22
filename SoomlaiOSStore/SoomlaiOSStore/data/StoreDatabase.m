//
//  StoreDatabase.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/18/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StoreDatabase.h"

@interface StoreDatabase()

- (void)saveOrUpdateItem:(NSString*)itemId withBalance:(NSNumber*)balance andEntityName:(NSString*)entityName;
- (NSDictionary*)getItem:(NSString*)itemId andEntityName:(NSString*)entityName;
- (NSManagedObject *)getManagedObjectWithValue:(NSString *)value forAttribute:(NSString*)attr andEntityName:(NSString*)entityName;
- (void)saveOrUpdateStoreInfo:(NSString*)storeInfo withData:(NSString*)storeInfoData;
- (NSString*)getStoreInfo:(NSString*)storeInfo;

@end

@implementation StoreDatabase

@synthesize managedContext;

- (void)setStoreInfo:(NSString*)storeInfoData{
    [self saveOrUpdateStoreInfo:@"storeInfo" withData:storeInfoData];
}

- (void)setStorefrontInfo:(NSString*)storefrontInfoData{
    [self saveOrUpdateStoreInfo:@"storefrontInfo" withData:storefrontInfoData];
}

- (NSString*)getStoreInfo{
    return [self getStoreInfo:@"storeInfo"];
}

- (NSString*)getStorefrontInfo{
    return [self getStoreInfo:@"storefrontInfo"];
}

- (void)updateCurrencyBalanceWithItemID:(NSString*)itemId andBalance:(NSNumber*)balance{
    [self saveOrUpdateItem:itemId withBalance:balance andEntityName:@"CurrencyBalance"];
}

- (void)updateGoodBalanceWithItemId:(NSString*)itemId andBalance:(NSNumber*)balance{
    [self saveOrUpdateItem:itemId withBalance:balance andEntityName:@"GoodBalance"];
}

- (NSDictionary*)getCurrencyBalanceWithItemId:(NSString*)itemId{
    return [self getItem:itemId andEntityName:@"CurrencyBalance"];
}

- (NSDictionary*)getGoodBalanceWithItemId:(NSString*)itemId{
    return [self getItem:itemId andEntityName:@"GoodBalance"];
}

- (id)initWithContext:(NSManagedObjectContext*)oManagedContext{
    
    self = [super init];
    if (self){
        self.managedContext = oManagedContext;
    }
    
    return self;
}

- (void)saveOrUpdateStoreInfo:(NSString*)storeInfo withData:(NSString*)storeInfoData{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:NULL forAttribute:storeInfo andEntityName:@"Metadata"];
    
    if (managedObject != NULL){
        NSLog(@"setting value for existing storeInfo: %@", storeInfo);
        [managedObject setValue:storeInfoData forKey:storeInfo];
        NSError *error;
        if (![managedContext save:&error]){
            NSLog(@"Can't save balance for storeInfo: %@", storeInfo);
        }
    }
    else{
        NSLog(@"setting value for new storeInfo: %@", storeInfo);
        managedObject = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Metadata"
                         inManagedObjectContext:managedContext];
        [managedObject setValue:storeInfoData forKey:storeInfo];
        NSError *error;
        if (![managedContext save:&error]){
            NSLog(@"Can't add storeInfo: %@", storeInfo);
        }
    }
}


- (void)saveOrUpdateItem:(NSString*)itemId withBalance:(NSNumber*)balance andEntityName:(NSString*)entityName{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:itemId forAttribute:@"itemId" andEntityName:entityName];
    
    if (managedObject != NULL){
        NSLog(@"setting value for existing itemId: %@", itemId);
        [managedObject setValue:balance forKey:@"balance"];
        NSError *error;
        if (![managedContext save:&error]){
            NSLog(@"Can't save balance for itemId: %@", itemId);
        }
    }
    else{
        NSLog(@"setting value for new itemId: %@", itemId);
        managedObject = [NSEntityDescription
                         insertNewObjectForEntityForName:entityName
                         inManagedObjectContext:managedContext];
        [managedObject setValue:balance forKey:@"balance"];
        [managedObject setValue:itemId forKey:@"itemId"];
        NSError *error;
        if (![managedContext save:&error]){
            NSLog(@"Can't add itemId: %@", itemId);
        }
    }
}

- (NSString*)getStoreInfo:(NSString*)storeInfo{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:NULL forAttribute:storeInfo andEntityName:@"Metadata"];
    
    if (managedObject != NULL){
        NSLog(@"fetching value for existing storeInfo: %@", storeInfo);
        return [managedObject valueForKey:storeInfo];
    }

    NSLog(@"can't find the storeInfo %@. returning an empty string.", storeInfo);
    return @"";
}

- (NSDictionary*)getItem:(NSString*)itemId andEntityName:(NSString*)entityName{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:itemId forAttribute:@"itemId" andEntityName:entityName];
    
    if (managedObject != NULL){
        NSLog(@"found object with itemId: %@", itemId);
        return [NSDictionary dictionaryWithObjectsAndKeys:itemId, @"itemId",
                [managedObject valueForKey:@"balance"], @"balance", nil];
    }
    
    NSLog(@"coouldn't find object for itemId %@. returning a NULL dictionary.", itemId);
    return NULL;
}

/**
 * This function fetches a NSManagedObject for the given criterias.
 * value - Is the value that the given attr needs to meet. If the value is NULL, The first object in the fetched array is returned (or NULL if there aren't any.
 * attr - Is the attribute to find value in. (it's actually the table column we search value in).
 * entityName - Is the name of the required entity (from the core data model definition).
 */
- (NSManagedObject *)getManagedObjectWithValue:(NSString *)value forAttribute:(NSString*)attr andEntityName:(NSString*)entityName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName
                                   inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    
    if (value == NULL){
        if (fetchedObjects.count > 0){
            return [fetchedObjects objectAtIndex:0];
        }
        else{
            return NULL;
        }
    }
    
    NSManagedObject *managedObject = NULL;
    for (NSManagedObject *mo in fetchedObjects) {
        if ([value isEqualToString:[mo valueForKey:attr]]) {
            managedObject = mo;
        }
    }
    return managedObject;
}

@end
