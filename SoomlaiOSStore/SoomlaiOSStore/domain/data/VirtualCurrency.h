//
//  VirtualCurrency.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualItem.h"

@interface VirtualCurrency : VirtualItem{
    
}

- (id)initWithName:(NSString*)name andDescription:(NSString*)description
    andImgFilePath:(NSString*)imgFilePath andItemId:(NSString*)itemId;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@end
