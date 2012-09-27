//
//  StoreDatabase.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/18/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StoreDatabase.h"
#import "NumberEncryptionTransformer.h"
#import "StringEncryptionTransformer.h"

#define DATABASE_FILE_NAME           @"store.sqlite"

#define ENTITY_NAME_CURRENCY_BALANCE @"CurrencyBalance"
#define ENTITY_NAME_GOOD_BALANCE     @"GoodBalance"
#define ENTITY_NAME_METADATA         @"Metadata"

#define ATTR_NAME_BALANCE            @"balance"
#define ATTR_NAME_ITEMID             @"itemId"
#define ATTR_NAME_STOREINFO          @"storeInfo"
#define ATTR_NAME_STOREFRONTINFO     @"storefrontInfo"

@interface StoreDatabase()

- (void)saveOrUpdateItem:(NSString*)itemId withBalance:(NSNumber*)balance andEntityName:(NSString*)entityName;
- (NSDictionary*)getItem:(NSString*)itemId andEntityName:(NSString*)entityName;
- (NSManagedObject *)getManagedObjectWithValue:(NSString *)value forAttribute:(NSString*)attr andEntityName:(NSString*)entityName;
- (void)saveOrUpdateStoreInfo:(NSString*)storeInfo withData:(NSString*)storeInfoData;
- (NSString*)getStoreInfo:(NSString*)storeInfo;

@end

@implementation StoreDatabase

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)setStoreInfo:(NSString*)storeInfoData{
    [self saveOrUpdateStoreInfo:ATTR_NAME_STOREINFO withData:storeInfoData];
}

- (void)setStorefrontInfo:(NSString*)storefrontInfoData{
    [self saveOrUpdateStoreInfo:ATTR_NAME_STOREFRONTINFO withData:storefrontInfoData];
}

- (NSString*)getStoreInfo{
    return [self getStoreInfo:ATTR_NAME_STOREINFO];
}

- (NSString*)getStorefrontInfo{
    return [self getStoreInfo:ATTR_NAME_STOREFRONTINFO];
}

- (void)updateCurrencyBalanceWithItemID:(NSString*)itemId andBalance:(NSNumber*)balance{
    [self saveOrUpdateItem:itemId withBalance:balance andEntityName:ENTITY_NAME_CURRENCY_BALANCE];
}

- (void)updateGoodBalanceWithItemId:(NSString*)itemId andBalance:(NSNumber*)balance{
    [self saveOrUpdateItem:itemId withBalance:balance andEntityName:ENTITY_NAME_GOOD_BALANCE];
}

- (NSDictionary*)getCurrencyBalanceWithItemId:(NSString*)itemId{
    return [self getItem:itemId andEntityName:ENTITY_NAME_CURRENCY_BALANCE];
}

- (NSDictionary*)getGoodBalanceWithItemId:(NSString*)itemId{
    return [self getItem:itemId andEntityName:ENTITY_NAME_GOOD_BALANCE];
}

- (void)saveOrUpdateStoreInfo:(NSString*)storeInfo withData:(NSString*)storeInfoData{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:NULL forAttribute:storeInfo andEntityName:ENTITY_NAME_METADATA];
    
    if (managedObject != NULL){
        NSLog(@"setting value for existing storeInfo: %@", storeInfo);
        [managedObject setValue:storeInfoData forKey:storeInfo];
        [self saveContext];
    }
    else{
        NSLog(@"setting value for new storeInfo: %@", storeInfo);
        managedObject = [NSEntityDescription
                         insertNewObjectForEntityForName:ENTITY_NAME_METADATA
                         inManagedObjectContext:self.managedObjectContext];
        [managedObject setValue:storeInfoData forKey:storeInfo];
        [self saveContext];
    }
}


- (void)saveOrUpdateItem:(NSString*)itemId withBalance:(NSNumber*)balance andEntityName:(NSString*)entityName{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:itemId forAttribute:ATTR_NAME_ITEMID andEntityName:entityName];
    
    if (managedObject != NULL){
        NSLog(@"setting value for existing itemId: %@", itemId);
        [managedObject setValue:balance forKey:ATTR_NAME_BALANCE];
        [self saveContext];
    }
    else{
        NSLog(@"setting value for new itemId: %@", itemId);
        managedObject = [NSEntityDescription
                         insertNewObjectForEntityForName:entityName
                         inManagedObjectContext:self.managedObjectContext];
        [managedObject setValue:balance forKey:ATTR_NAME_BALANCE];
        [managedObject setValue:itemId forKey:ATTR_NAME_ITEMID];
        [self saveContext];
    }
}

- (NSString*)getStoreInfo:(NSString*)storeInfo{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:NULL forAttribute:storeInfo andEntityName:ENTITY_NAME_METADATA];
    
    if (managedObject != NULL){
        NSLog(@"fetching value for existing storeInfo: %@", storeInfo);
        return [managedObject valueForKey:storeInfo];
    }

    NSLog(@"can't find the storeInfo %@. returning an empty string.", storeInfo);
    return @"";
}

- (NSDictionary*)getItem:(NSString*)itemId andEntityName:(NSString*)entityName{
    NSManagedObject *managedObject = [self getManagedObjectWithValue:itemId forAttribute:ATTR_NAME_ITEMID andEntityName:entityName];
    
    if (managedObject != NULL){
        NSLog(@"found object with itemId: %@", itemId);
        return [NSDictionary dictionaryWithObjectsAndKeys:itemId, ATTR_NAME_ITEMID,
                [managedObject valueForKey:ATTR_NAME_BALANCE], ATTR_NAME_BALANCE, nil];
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
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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


#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSAttributeDescription *)attributeWithName:(NSString*)attrName andTrasformableName:(NSString*)transName andOptional:(BOOL)optional;
{
    NSAttributeDescription *itemIdAttribute= [[NSAttributeDescription alloc] init];
    [itemIdAttribute setName:attrName];
    [itemIdAttribute setAttributeType:NSTransformableAttributeType];
    [itemIdAttribute setValueTransformerName:transName];
    [itemIdAttribute setOptional:optional];
    return itemIdAttribute;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    [NSValueTransformer setValueTransformer:[[NumberEncryptionTransformer alloc] init] forName:@"NumberEncryptionTransformer"];
    [NSValueTransformer setValueTransformer:[[StringEncryptionTransformer alloc] init] forName:@"StringEncryptionTransformer"];
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] init];
    
    
    // CurrencyBalance
    NSEntityDescription *currencyBalanceEntity = [[NSEntityDescription alloc] init];
    [currencyBalanceEntity setName:ENTITY_NAME_CURRENCY_BALANCE];
    [currencyBalanceEntity setManagedObjectClassName:ENTITY_NAME_CURRENCY_BALANCE];
    
    NSMutableArray *currencyBalanceProperties = [NSMutableArray array];
    [currencyBalanceProperties addObject:[self attributeWithName:ATTR_NAME_BALANCE andTrasformableName:@"NumberEncryptionTransformer" andOptional:NO]];
    [currencyBalanceProperties addObject:[self attributeWithName:ATTR_NAME_ITEMID andTrasformableName:@"StringEncryptionTransformer" andOptional:NO]];
    [currencyBalanceEntity setProperties:currencyBalanceProperties];

    // GoodBalance
    NSEntityDescription *goodBalanceEntity = [[NSEntityDescription alloc] init];
    [goodBalanceEntity setName:ENTITY_NAME_GOOD_BALANCE];
    [goodBalanceEntity setManagedObjectClassName:ENTITY_NAME_GOOD_BALANCE];
    
    NSMutableArray *goodBalanceProperties = [NSMutableArray array];
    [goodBalanceProperties addObject:[self attributeWithName:ATTR_NAME_BALANCE andTrasformableName:@"NumberEncryptionTransformer" andOptional:NO]];
    [goodBalanceProperties addObject:[self attributeWithName:ATTR_NAME_ITEMID andTrasformableName:@"StringEncryptionTransformer" andOptional:NO]];
    [goodBalanceEntity setProperties:goodBalanceProperties];
    
    // Metadata
    NSEntityDescription *metadataBalanceEntity = [[NSEntityDescription alloc] init];
    [metadataBalanceEntity setName:ENTITY_NAME_METADATA];
    [metadataBalanceEntity setManagedObjectClassName:ENTITY_NAME_GOOD_BALANCE];
    
    NSMutableArray *metadataBalanceProperties = [NSMutableArray array];
    [metadataBalanceProperties addObject:[self attributeWithName:ATTR_NAME_STOREINFO andTrasformableName:@"StringEncryptionTransformer" andOptional:YES]];
    [metadataBalanceProperties addObject:[self attributeWithName:ATTR_NAME_STOREFRONTINFO andTrasformableName:@"StringEncryptionTransformer" andOptional:YES]];
    [metadataBalanceEntity setProperties:metadataBalanceProperties];
    
    
    
    [mom setEntities:@[currencyBalanceEntity, goodBalanceEntity, metadataBalanceEntity]];
    return mom;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DATABASE_FILE_NAME];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
