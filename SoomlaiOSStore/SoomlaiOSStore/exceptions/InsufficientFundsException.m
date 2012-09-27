//
//  InsufficientFundsException.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "InsufficientFundsException.h"

@implementation InsufficientFundsException

@synthesize itemId;

- (id)initWithItemId:(NSString*)oItemId{
    NSString* reason = [NSString stringWithFormat:@"You tried to buy with itemId: %@ but you don't have enough money to buy it." ,oItemId];
    
    self = [super initWithName:@"InsufficientFundsException" reason:reason userInfo:nil];
    if (self){
        self.itemId = oItemId;
    }
    
    return self;
}

@end
