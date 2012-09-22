//
//  PriceModel.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VirtualGood;

@interface PriceModel : NSObject{
    @protected
    NSString* type;
}

@property (retain, nonatomic) NSString* type;

- (id)init;
- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood;
- (NSDictionary*)toDictionary;

+ (PriceModel*)priceModelWithNSDictionary:(NSDictionary*)dict;
+ (NSDictionary*)dictionaryWithPriceModel:(PriceModel*)priceModel;

@end
