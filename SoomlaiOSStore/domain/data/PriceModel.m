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

#import "PriceModel.h"
#import "JSONConsts.h"
#import "StaticPriceModel.h"
#import "BalanceDrivenPriceModel.h"

@implementation PriceModel

@synthesize type;

- (id)init{
    self = [super init];
    if ([self class] == [PriceModel class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.type, JSON_GOOD_PRICE_MODEL_TYPE,
            nil];
}

+ (PriceModel*)priceModelWithNSDictionary:(NSDictionary*)dict{
    NSString* type = [dict valueForKey:JSON_GOOD_PRICE_MODEL_TYPE];
    if ([type isEqualToString:@"static"]) {
        return [StaticPriceModel modelWithNSDictionary:dict];
    }
    else if ([type isEqualToString:@"balance"]) {
        return [BalanceDrivenPriceModel modelWithNSDictionary:dict];
    }
    
    return nil;
}

+ (NSDictionary*)dictionaryWithPriceModel:(PriceModel*)priceModel{
    return [priceModel toDictionary];
}


@end
