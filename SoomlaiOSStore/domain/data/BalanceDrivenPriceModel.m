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

#import "BalanceDrivenPriceModel.h"
#import "JSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"

@implementation BalanceDrivenPriceModel

@synthesize currencyValuePerBalance;

- (id)initWithCurrencyValuePerBalance:(NSArray*)oCurrencyValuePerBalance{
    self = [super init];
    if (self){
        self.currencyValuePerBalance = oCurrencyValuePerBalance;
        self.type = @"balance";
    }
    
    return self;
}

- (NSDictionary*)getCurrentPriceForVirtualGood:(VirtualGood*)virtualGood{
    int balance = [[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:virtualGood];
    
    // if the balance is bigger than the size of the array, return the last value in the array.
    if (balance >= [self.currencyValuePerBalance count]){
        return [self.currencyValuePerBalance objectAtIndex:([self.currencyValuePerBalance count] - 1)];
    }
    
    return [self.currencyValuePerBalance objectAtIndex:balance];
}

- (NSDictionary*)toDictionary{
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    [toReturn setValue:currencyValuePerBalance forKey:JSON_GOOD_PRICE_MODEL_VALUES];
    
    return toReturn;
}

+ (BalanceDrivenPriceModel*)modelWithNSDictionary:(NSDictionary*)dict{
    return [[BalanceDrivenPriceModel alloc] initWithCurrencyValuePerBalance:[dict valueForKey:JSON_GOOD_PRICE_MODEL_VALUES]];
}

@end
