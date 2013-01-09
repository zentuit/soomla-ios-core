//
//  NonConsumableItem.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 08/01/13.
//  Copyright (c) 2013 SOOMLA. All rights reserved.
//

#import "NonConsumableItem.h"
#import "AppStoreItem.h"

@implementation NonConsumableItem

@synthesize appStoreItem;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
         andItemId:(NSString*)oItemId andPrice:(double)oPrice
      andProductId:(NSString*)productId {
    self = [super initWithName:oName andDescription:oDescription andItemId:oItemId];
    if (self) {
        appStoreItem = [[AppStoreItem alloc] initWithProductId:productId andConsumable:kNonConsumable andPrice:oPrice];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        appStoreItem = [[AppStoreItem alloc] initWithDictionary:dict];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    NSDictionary* aiDict = [appStoreItem toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [aiDict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [toReturn setObject: obj forKey: key];
    }];
    
    return toReturn;
}

@end
