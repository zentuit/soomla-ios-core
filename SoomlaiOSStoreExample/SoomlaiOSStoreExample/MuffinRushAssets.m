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

#import "MuffinRushAssets.h"
#import "VirtualCategory.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "VirtualCurrencyPack.h"
#import "StaticPriceModel.h"

NSString* const MUFFIN_CURRENCY_ITEM_ID      = @"currency_muffin";
NSString* const TENMUFF_PACK_PRODUCT_ID      = @"";
NSString* const FIFTYMUFF_PACK_PRODUCT_ID    = @"";
NSString* const FORTYMUFF_PACK_PRODUCT_ID    = @"com.soomla.SoomlaiOSStoreExampleDevice.test_product_one";
NSString* const THOUSANDMUFF_PACK_PRODUCT_ID = @"com.soomla.SoomlaiOSStoreExampleDevice.second_test";

@implementation MuffinRushAssets

VirtualCategory* GENERAL_CATEGORY;
VirtualCurrency* MUFFIN_CURRENCY;
VirtualGood*     MUFFINCAKE_GOOD;
VirtualGood*     PAVLOVA_GOOD;
VirtualGood*     CHOCLATECAKE_GOOD;
VirtualGood*     CREAMCUP_GOOD;
VirtualCurrencyPack* TENMUFF_PACK;
VirtualCurrencyPack* FIFTYMUFF_PACK;
VirtualCurrencyPack* FORTYMUFF_PACK;
VirtualCurrencyPack* THOUSANDMUFF_PACK;
+ (void)initialize{
    
    /** Virtual Categories **/
    // The muffin rush theme doesn't support categories, so we just put everything under a general category.
    
    GENERAL_CATEGORY = [[VirtualCategory alloc] initWithName:@"General"
                                                       andId:0
                                                    andTitle:@"GENERAL"
                                              andImgFilePath:@""];
    
    /** Virtual Currencies **/
    
    MUFFIN_CURRENCY = [[VirtualCurrency alloc] initWithName:@"Muffins"
                                             andDescription:@""
                                             andImgFilePath:@"themes/muffinRush/img/muffin.png"
                                                  andItemId:MUFFIN_CURRENCY_ITEM_ID];
    
    
    /** Virtual Goods **/
    
    NSDictionary* MUFFINCAKE_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithInt:225], MUFFIN_CURRENCY_ITEM_ID,
                                      nil];
    MUFFINCAKE_GOOD = [[VirtualGood alloc] initWithName:@"Fruit Cake"
                                         andDescription:@"Customers buy a double portion on each purchase of this cake"
                                         andImgFilePath:@"themes/muffinRush/img/items/fruit_cake.png"
                                              andItemId:@"fruit_cake"
                                          andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:MUFFINCAKE_PRICE]
                                            andCategory:GENERAL_CATEGORY
                                         andEquipStatus:NO];
    
    NSDictionary* PAVLOVA_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithInt:175], MUFFIN_CURRENCY_ITEM_ID,
                                      nil];
    PAVLOVA_GOOD = [[VirtualGood alloc] initWithName:@"Pavlova"
                                         andDescription:@"Gives customers a sugar rush and they call their friends"
                                         andImgFilePath:@"themes/muffinRush/img/items/pavlova.png"
                                              andItemId:@"pavlova"
                                          andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:PAVLOVA_PRICE]
                                            andCategory:GENERAL_CATEGORY
                                         andEquipStatus:NO];
    
    NSDictionary* CHOCLATECAKE_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithInt:250], MUFFIN_CURRENCY_ITEM_ID,
                                   nil];
    CHOCLATECAKE_GOOD = [[VirtualGood alloc] initWithName:@"Chocolate Cake"
                                      andDescription:@"A classic cake to maximize customer satisfaction"
                                      andImgFilePath:@"themes/muffinRush/img/items/chocolate_cake.png"
                                           andItemId:@"chocolate_cake"
                                       andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:CHOCLATECAKE_PRICE]
                                         andCategory:GENERAL_CATEGORY
                                      andEquipStatus:NO];
    

    NSDictionary* CREAMCUP_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:50], MUFFIN_CURRENCY_ITEM_ID,
                                        nil];
    CREAMCUP_GOOD = [[VirtualGood alloc] initWithName:@"Cream Cup"
                                           andDescription:@"Increase bakery reputation with this original pastry"
                                           andImgFilePath:@"themes/muffinRush/img/items/cream_cup.png"
                                                andItemId:@"cream_cup"
                                            andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:CREAMCUP_PRICE]
                                              andCategory:GENERAL_CATEGORY
                                           andEquipStatus:NO];
    
    
    /** Virtual Currency Pack **/
    
    TENMUFF_PACK = [[VirtualCurrencyPack alloc] initWithName:@"10 Muffins"
                                              andDescription:@" (refund test)"
                                              andImgFilePath:@"themes/muffinRush/img/currencyPacks/muffins01.png"
                                                   andItemId:@"muffins_10"
                                                    andPrice:0.99
                                                andProductId:TENMUFF_PACK_PRODUCT_ID
                                           andCurrencyAmount:10
                                                 andCurrency:MUFFIN_CURRENCY
                                                 andCategory:GENERAL_CATEGORY];
    FIFTYMUFF_PACK = [[VirtualCurrencyPack alloc] initWithName:@"50 Muffins"
                                                andDescription:@" (canceled test)"
                                                andImgFilePath:@"themes/muffinRush/img/currencyPacks/muffins02.png"
                                                     andItemId:@"muffins_50"
                                                      andPrice:1.99
                                                  andProductId:FIFTYMUFF_PACK_PRODUCT_ID
                                             andCurrencyAmount:50 andCurrency:MUFFIN_CURRENCY
                                                   andCategory:GENERAL_CATEGORY];
    FORTYMUFF_PACK = [[VirtualCurrencyPack alloc] initWithName:@"400 Muffins"
                                                andDescription:@"ONLY THIS WORKS IN THIS EXAMPLE (purchase test)"
                                                andImgFilePath:@"themes/muffinRush/img/currencyPacks/muffins03.png"
                                                     andItemId:@"muffins_400"
                                                      andPrice:4.99
                                                  andProductId:FORTYMUFF_PACK_PRODUCT_ID
                                             andCurrencyAmount:400
                                                   andCurrency:MUFFIN_CURRENCY
                                                   andCategory:GENERAL_CATEGORY];
    THOUSANDMUFF_PACK = [[VirtualCurrencyPack alloc] initWithName:@"1000 Muffins"
                                                   andDescription:@" (item_unavailable test)"
                                                   andImgFilePath:@"themes/muffinRush/img/currencyPacks/muffins04.png"
                                                        andItemId:@"muffins_1000"
                                                         andPrice:8.99
                                                     andProductId:THOUSANDMUFF_PACK_PRODUCT_ID
                                                andCurrencyAmount:1000
                                                      andCurrency:MUFFIN_CURRENCY
                                                      andCategory:GENERAL_CATEGORY];
    
}

- (NSArray*)virtualCurrencies{
    return @[MUFFIN_CURRENCY];
}

- (NSArray*)virtualGoods{
    return @[MUFFINCAKE_GOOD, PAVLOVA_GOOD, CHOCLATECAKE_GOOD, CREAMCUP_GOOD];
}

- (NSArray*)virtualCurrencyPacks{
    return @[TENMUFF_PACK, FIFTYMUFF_PACK, FORTYMUFF_PACK, THOUSANDMUFF_PACK];
}

- (NSArray*)virtualCategories{
    return @[GENERAL_CATEGORY];
}

@end
