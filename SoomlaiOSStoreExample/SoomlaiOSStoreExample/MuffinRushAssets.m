#import "MuffinRushAssets.h"
#import "VirtualCategory.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "VirtualCurrencyPack.h"
#import "StaticPriceModel.h"
#import "BalanceDrivenPriceModel.h"
#import "NonConsumableItem.h"


NSString* const MUFFINS_CURRENCY_ITEM_ID = @"currency_muffin";

NSString* const FRUIT_CAKE_GOOD_ITEM_ID = @"fruit_cake";
NSString* const PAVLOVA_GOOD_ITEM_ID = @"pavlova";
NSString* const CHOCO_CAKE_GOOD_ITEM_ID = @"chocolate_cake";
NSString* const CREAM_CUP_GOOD_ITEM_ID = @"cream_cup";

NSString* const _10_MUFFINS_PACK_ITEM_ID = @"muffins_10";
NSString* const _50_MUFFINS_PACK_ITEM_ID = @"muffins_50";
NSString* const _400_MUFFINS_PACK_ITEM_ID = @"muffins_400";
NSString* const _1000_MUFFINS_PACK_ITEM_ID = @"muffins_1000";

NSString* const _10_MUFFINS_PACK_PRODUCT_ID = @"muffins_10";
NSString* const _50_MUFFINS_PACK_PRODUCT_ID = @"muffins_50";
NSString* const _400_MUFFINS_PACK_PRODUCT_ID = @"muffins_400";
NSString* const _1000_MUFFINS_PACK_PRODUCT_ID = @"com.soomla.SoomlaiOSExample.second_test";

NSString* const NO_ADDS_NONCONS_PRODUCT_ID = @"no_ads";

@implementation MuffinRushAssets

VirtualCategory* GENERAL_CATEGORY;

VirtualCurrency* MUFFINS_CURRENCY;

VirtualGood* FRUIT_CAKE_GOOD;
VirtualGood* PAVLOVA_GOOD;
VirtualGood* CHOCO_CAKE_GOOD;
VirtualGood* CREAM_CUP_GOOD;

VirtualCurrencyPack* _10_MUFFINS_PACK;
VirtualCurrencyPack* _50_MUFFINS_PACK;
VirtualCurrencyPack* _400_MUFFINS_PACK;
VirtualCurrencyPack* _1000_MUFFINS_PACK;

NonConsumableItem* NO_ADDS_NON_CONS;

+ (void)initialize{

    /** Virtual Categories **/
    GENERAL_CATEGORY = [[VirtualCategory alloc] initWithName:@"General" andId:1 andEquippingModel:kNone];
    

    /** Virtual Currencies **/
    MUFFINS_CURRENCY = [[VirtualCurrency alloc] initWithName:@"Muffins" andDescription:@"" andItemId:MUFFINS_CURRENCY_ITEM_ID];
    

    /** Virtual Goods **/
    NSDictionary* FRUIT_CAKE_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
				    [NSNumber numberWithInt:220], MUFFINS_CURRENCY_ITEM_ID,
                                      nil];
    NSArray* prices = [NSArray arrayWithObjects:FRUIT_CAKE_PRICE, nil];
    FRUIT_CAKE_GOOD = [[VirtualGood alloc] initWithName:@"Fruit Cake" andDescription:@"Customers buy a double portion on each purchase of this cake" andItemId:FRUIT_CAKE_GOOD_ITEM_ID andPriceModel:[[BalanceDrivenPriceModel alloc]
          initWithCurrencyValuePerBalance:prices] andCategory:GENERAL_CATEGORY];
    
    NSDictionary* PAVLOVA_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:175], MUFFINS_CURRENCY_ITEM_ID,
                                      nil];
    PAVLOVA_GOOD = [[VirtualGood alloc] initWithName:@"Pavlova" andDescription:@"Gives customers a sugar rush and they call their friends" andItemId:PAVLOVA_GOOD_ITEM_ID andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:PAVLOVA_PRICE] andCategory:GENERAL_CATEGORY];
    
    NSDictionary* CHOCO_CAKE_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:250], MUFFINS_CURRENCY_ITEM_ID,
                                      nil];
    CHOCO_CAKE_GOOD = [[VirtualGood alloc] initWithName:@"Choco-Cake" andDescription:@"A classic cake to maximize customer satisfaction" andItemId:CHOCO_CAKE_GOOD_ITEM_ID andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:CHOCO_CAKE_PRICE] andCategory:GENERAL_CATEGORY];
    
    NSDictionary* CREAM_CUP_PRICE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:50], MUFFINS_CURRENCY_ITEM_ID,
                                      nil];
    CREAM_CUP_GOOD = [[VirtualGood alloc] initWithName:@"Cream Cup" andDescription:@"Increase bakery reputation with this original pastry" andItemId:CREAM_CUP_GOOD_ITEM_ID andPriceModel:[[StaticPriceModel alloc] initWithCurrencyValue:CREAM_CUP_PRICE] andCategory:GENERAL_CATEGORY];
    

    /** Virtual Currency Pack **/
    _10_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"10 Muffins" andDescription:@"" andItemId:_10_MUFFINS_PACK_ITEM_ID andPrice:0.99 andProductId:_10_MUFFINS_PACK_PRODUCT_ID andCurrencyAmount:10 andCurrency:MUFFINS_CURRENCY];
    _50_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"50 Muffins" andDescription:@"" andItemId:_50_MUFFINS_PACK_ITEM_ID andPrice:1.99 andProductId:_50_MUFFINS_PACK_PRODUCT_ID andCurrencyAmount:50 andCurrency:MUFFINS_CURRENCY];
    _400_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"400 Muffins" andDescription:@"" andItemId:_400_MUFFINS_PACK_ITEM_ID andPrice:4.99 andProductId:_400_MUFFINS_PACK_PRODUCT_ID andCurrencyAmount:400 andCurrency:MUFFINS_CURRENCY];
    _1000_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"1000 Muffins" andDescription:@"" andItemId:_1000_MUFFINS_PACK_ITEM_ID andPrice:8.99 andProductId:_1000_MUFFINS_PACK_PRODUCT_ID andCurrencyAmount:1000 andCurrency:MUFFINS_CURRENCY];
    
    NO_ADDS_NON_CONS = [[NonConsumableItem alloc] initWithName:@"No Ads" andDescription:@"" andItemId:@"no_ads" andPrice:1.99 andProductId:NO_ADDS_NONCONS_PRODUCT_ID];
    
}

- (int)getVersion {
    return 0;
}

- (NSArray*)virtualCurrencies{
    return @[MUFFINS_CURRENCY];
}

- (NSArray*)virtualGoods{
    return @[FRUIT_CAKE_GOOD, PAVLOVA_GOOD, CHOCO_CAKE_GOOD, CREAM_CUP_GOOD];
}

- (NSArray*)virtualCurrencyPacks{
    return @[_10_MUFFINS_PACK, _50_MUFFINS_PACK, _400_MUFFINS_PACK, _1000_MUFFINS_PACK];
}

- (NSArray*)virtualCategories{
    return @[GENERAL_CATEGORY];
}

- (NSArray*)nonConsumableItems{
    return @[NO_ADDS_NON_CONS];
}

@end