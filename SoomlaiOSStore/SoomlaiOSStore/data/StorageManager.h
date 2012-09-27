//
//  StorageManager.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreDatabase;
@class VirtualGoodStorage;
@class VirtualCurrencyStorage;

@interface StorageManager : NSObject{
    StoreDatabase* database;
    VirtualGoodStorage* virtualGoodStorage;
    VirtualCurrencyStorage* virtualCurrenctStorage;
}

@property (nonatomic, retain)StoreDatabase* database;
@property (nonatomic, retain)VirtualGoodStorage* virtualGoodStorage;
@property (nonatomic, retain)VirtualCurrencyStorage* virtualCurrencyStorage;

+ (StorageManager*)getInstance;

- (id)init;

@end
