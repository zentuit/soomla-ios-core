//
//  InsufficientFundsException.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "InsufficientFundsException.h"

@implementation InsufficientFundsException

- (id)initWithItemId:(NSString*)itemId{
    NSString* reason = [NSString stringWithFormat:@"You tried to buy with itemId: %@ but you don't have enough money to buy it." ,itemId];
    self = [super initWithName:@"InsufficientFundsException" reason:reason userInfo:nil];
    if (self){
        
    }
    
    return self;
}

@end
