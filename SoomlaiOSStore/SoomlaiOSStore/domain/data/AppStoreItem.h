//
//  AppStoreItem.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

typedef enum {
    kConsumable = 1,
    kNonConsumable = 2,
    kAutoRenewableSubscription = 3,
    kNonRenewableSubscription = 4,
    kFreeSubscription = 5
} Consumable;

@interface AppStoreItem : NSObject{
    NSString* productId;
    Consumable consumable;
}

@property (nonatomic, retain) NSString* productId;
@property Consumable consumable;

- (id)initWithProductId:(NSString*)oProductId andConsumable:(Consumable)oConsumable;

@end
