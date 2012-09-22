//
//  VirtualGoodStorage.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/19/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VirtualGood;

@interface VirtualGoodStorage : NSObject

- (int)getBalanceForGood:(VirtualGood*)virtualGood;
- (int)addAmount:(int)amount toGood:(VirtualGood*)virtualGood;
- (int)removeAmount:(int)amount fromGood:(VirtualGood*)virtualGood;

@end
