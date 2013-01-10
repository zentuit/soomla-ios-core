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

@interface VirtualCategory (Private)
-(NSString*) equippingModelEnumToString:(EquippingModel)emVal;
-(EquippingModel) equippingModelStringToEnum:(NSString*)emStr;
@end

@implementation VirtualCategory

@synthesize Id, name, equippingModel;

- (id)initWithName:(NSString*)oName andId:(int)oId andEquippingModel:(EquippingModel) oEquippingModel{
    
    self = [super init];
    if (self) {
        self.name = oName;
        self.Id = oId;
        self.equippingModel = oEquippingModel;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:JSON_CATEGORY_NAME];
        NSNumber* numId = [dict objectForKey:JSON_CATEGORY_ID];
        self.Id = [numId intValue];
        self.equippingModel = [self equippingModelStringToEnum:[dict objectForKey:JSON_CATEGORY_EQUIPPING]];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, JSON_CATEGORY_NAME,
            [NSNumber numberWithInt:self.Id], JSON_CATEGORY_ID,
            [self equippingModelEnumToString:equippingModel], JSON_CATEGORY_EQUIPPING,
            nil];
}

-(NSString*) equippingModelEnumToString:(EquippingModel)emVal
{
    NSArray *emArray = [[NSArray alloc] initWithObjects:EquippingModelArray];
    return [emArray objectAtIndex:emVal];
}

-(EquippingModel) equippingModelStringToEnum:(NSString*)emStr
{
    NSArray *emArray = [[NSArray alloc] initWithObjects:EquippingModelArray];
    NSUInteger n = [emArray indexOfObject:emStr];
    if(n < 1) n = kNone;
    return (EquippingModel) n;
}

@end
