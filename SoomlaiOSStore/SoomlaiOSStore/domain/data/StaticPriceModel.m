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

#import "StaticPriceModel.h"
#import "JSONConsts.h"

@implementation StaticPriceModel

@synthesize currencyValue;

- (id)initWithCurrencyValue:(NSDictionary*)oCurrencyValue{
    self = [super init];
    if (self){
        self.currencyValue = oCurrencyValue;
        type = @"static";
    }
    
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    return self.currencyValue;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    [toReturn setValue:currencyValue forKey:JSON_GOOD_PRICE_MODEL_VALUES];
    
    return toReturn;
}

+ (StaticPriceModel*)modelWithNSDictionary:(NSDictionary*)dict{
    return [[StaticPriceModel alloc] initWithCurrencyValue:[dict valueForKey:JSON_GOOD_PRICE_MODEL_VALUES]];
}

@end
