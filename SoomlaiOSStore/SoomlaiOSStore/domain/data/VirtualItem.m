//
//  VirtualItem.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualItem.h"
#import "JSONConsts.h"

@implementation VirtualItem

@synthesize name, description, imgFilePath, itemId;

- (id)init{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
               reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    return self;
}
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.name = oName;
        self.description = oDescription;
        self.imgFilePath = oImgFilePath;
        self.itemId = oItemId;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if ([self class] == [VirtualItem class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.name = [dict objectForKey:JSON_ITEM_NAME];
        self.description = [dict objectForKey:JSON_ITEM_DESCRIPTION];
        self.imgFilePath = [dict objectForKey:JSON_ITEM_IMAGEFILEPATH];
        self.itemId = [dict objectForKey:JSON_ITEM_ITEMID];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.name, JSON_ITEM_NAME,
                          self.description, JSON_ITEM_DESCRIPTION,
                          self.imgFilePath, JSON_ITEM_IMAGEFILEPATH,
                          self.itemId, JSON_ITEM_ITEMID,
                          nil];
}


@end
