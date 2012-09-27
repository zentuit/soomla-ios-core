//
//  VirtualGood.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualGood.h"
#import "JSONConsts.h"
#import "PriceModel.h"
#import "VirtualCategory.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"

@implementation VirtualGood

@synthesize priceModel, category;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId andPriceModel:(PriceModel*)oPriceModel
       andCategory:(VirtualCategory*)oCategory{
    
    self = [super initWithName:oName andDescription:oDescription andImgFilePath:oImgFilePath andItemId:oItemId];
    if (self){
        self.priceModel = oPriceModel;
        self.category = oCategory;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super initWithDictionary:dict];
    if (self) {
        self.priceModel = [PriceModel priceModelWithNSDictionary:[dict objectForKey:JSON_GOOD_PRICE_MODEL]];
        int categoryId = [[dict objectForKey:JSON_CURRENCYPACK_CATEGORY_ID] intValue];
        @try {
            if (categoryId > -1){
                self.category = [[StoreInfo getInstance] categoryWithId:categoryId];
            }
        }
        @catch (VirtualItemNotFoundException *exception) {
            NSLog(@"Can't find category with id: %d", categoryId);
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[self.priceModel toDictionary] forKey:JSON_GOOD_PRICE_MODEL];
    [toReturn setValue:[NSNumber numberWithInt:self.category.Id] forKey:JSON_CURRENCYPACK_CATEGORY_ID];
    
    return toReturn;
}

- (NSDictionary*)currencyValues{
    return [priceModel getCurrentPriceForVirtualGood:self];
}

@end
