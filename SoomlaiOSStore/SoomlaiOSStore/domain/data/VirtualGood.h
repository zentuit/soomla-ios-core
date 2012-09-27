//
//  VirtualGood.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualItem.h"

@class PriceModel;
@class VirtualCategory;

@interface VirtualGood : VirtualItem{
    @private
    PriceModel* priceModel;
    VirtualCategory* category;
}

@property (retain, nonatomic) PriceModel* priceModel;
@property (retain, nonatomic) VirtualCategory* category;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId andPriceModel:(PriceModel*)oPriceModel
       andCategory:(VirtualCategory*)oCategory;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;
- (NSDictionary*)currencyValues;

@end
