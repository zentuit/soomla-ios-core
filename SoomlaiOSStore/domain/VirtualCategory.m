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

#import "VirtualCategory.h"
#import "JSONConsts.h"
#import "VirtualGood.h"
#import "StoreInfo.h"

@implementation VirtualCategory

@synthesize name, goods;


- (id)initWithName:(NSString*)oName andGoods:(NSArray*)oGoods{
    
    self = [super init];
    if (self) {
        self.name = oName;
        self.goods = oGoods;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:JSON_CATEGORY_NAME];
        
        NSMutableArray* tmpGoods = [NSMutableArray array];
        NSArray* goodsArr = [dict objectForKey:JSON_CATEGORY_GOODSITEMIDS];
        for(NSString* goodItemId in goodsArr) {
            VirtualGood* good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
            [tmpGoods addObject:good];
        }
        self.goods = tmpGoods;
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    NSMutableArray* arr = [NSMutableArray array];
    for(VirtualGood* good in self.goods) {
        [arr addObject:good.itemId];
    }
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, JSON_CATEGORY_NAME,
            arr, JSON_CATEGORY_GOODSITEMIDS,
            nil];
}

@end
