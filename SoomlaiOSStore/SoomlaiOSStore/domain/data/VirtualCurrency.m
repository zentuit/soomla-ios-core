//
//  VirtualCurrency.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCurrency.h"

@implementation VirtualCurrency
    
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId{
    
    self = [super initWithName:oName andDescription:oDescription andImgFilePath:oImgFilePath andItemId:oItemId];
    if (self) {
        // Nothing to initialize
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super initWithDictionary:dict];
    if (self) {
        // Nothing to initialize
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [super toDictionary];
}

@end
