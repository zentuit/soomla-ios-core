//
//  AppStoreItem.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "AppStoreItem.h"

@implementation AppStoreItem

@synthesize consumable, productId;

- (id)initWithProductId:(NSString*)oProductId andConsumable:(Consumable)oConsumable{
    self = [super init];
    if (self){
        self.productId = oProductId;
        self.consumable = oConsumable;
    }
    
    return self;
}

@end
