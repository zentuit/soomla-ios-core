/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 *Items offered in In-App Purchase fall within one of the five following purchase types.
 */
typedef enum {
    kConsumable = 1,
    kNonConsumable = 2,
    kAutoRenewableSubscription = 3,
    kNonRenewableSubscription = 4,
    kFreeSubscription = 5
} Consumable;

/**
 * This class represents an item in the App Store.
 * Every PurchasableVirtualItem with PurchaseType of PurchaseWithMarket has an instance of this class which is a
 * representation of the same currency pack as an item on the App Store.
 */
@interface MarketItem : NSObject{
    NSString* productId;
    Consumable      consumable;
    double          price;
    
    NSDecimalNumber *marketPrice;
    NSLocale        *marketLocale;
    NSString        *marketTitle;
    NSString        *marketDescription;
}

@property (nonatomic, retain) NSString* productId;
@property Consumable      consumable;
@property double          price;
@property (nonatomic, retain) NSDecimalNumber *marketPrice;
@property (nonatomic, retain) NSLocale        *marketLocale;
@property (nonatomic, retain) NSString        *marketTitle;
@property (nonatomic, retain) NSString        *marketDescription;

/** 
 * Constructor
 *
 * oProductId - the Id of the current item in the App Store.
 * oConsumable - the type of the current item in the App Store.
 * oPrice - the actual $$ cost of the current item in the App Store.
 */
- (id)initWithProductId:(NSString*)oProductId andConsumable:(Consumable)oConsumable andPrice:(double)oPrice;

/** Constructor
 *
 * Generates an instance of VirtualCategory from an NSDictionary.
 * dict - a NSDictionary representation of the wanted VirtualCategory.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 * Converts the current VirtualCategory to an NSDictionary.
 */
- (NSDictionary*)toDictionary;

/**
 * Retrieves price of Market Item with its currency symbol
 *
 * return: price
 */
- (NSString*)priceWithCurrencySymbol;


@end
