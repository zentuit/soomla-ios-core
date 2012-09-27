//
//  StorageManager.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StorageManager.h"
#import "StoreDatabase.h"

@implementation StorageManager

@synthesize database, virtualCurrencyStorage, virtualGoodStorage;

+ (StorageManager*)getInstance{
    static StorageManager* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StorageManager alloc ] init];
        }
    }
    
    return _instance;
}

- (id)init{
    self = [super init];
    if (self){
        database = [[StoreDatabase alloc] init];
    }
    
    return self;
}

@end
