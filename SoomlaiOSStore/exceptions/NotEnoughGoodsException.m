//
//  NotEnoughGoodsException.m
//  SoomlaiOSStore
//
//  Created by Refael Dakar on 10/2/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "NotEnoughGoodsException.h"

@implementation NotEnoughGoodsException

- (id)initWithItemId:(NSString*)itemId{
    NSString* reason = [NSString stringWithFormat:@"You tried to equip virtual good with itemId: %@ but you don't have any of it." ,itemId];
    
    self = [super initWithName:@"InsufficientFundsException" reason:reason userInfo:nil];
    if (self){
    }
    
    return self;

}
@end
