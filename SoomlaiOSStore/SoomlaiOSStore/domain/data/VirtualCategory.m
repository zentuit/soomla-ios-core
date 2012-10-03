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

@implementation VirtualCategory

@synthesize Id, name, title, imgFilePath;

- (id)initWithName:(NSString*)oName andId:(int)oId andTitle:(NSString*)oTitle andImgFilePath:(NSString*)oImgFilePath{
    
    self = [super init];
    if (self) {
        self.name = oName;
        self.Id = oId;
        self.title = oTitle;
        self.imgFilePath = oImgFilePath;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:JSON_CATEGORY_NAME];
        NSNumber* numId = [dict objectForKey:JSON_CATEGORY_ID];
        self.Id = [numId intValue];
        self.title = [dict objectForKey:JSON_CATEGORY_TITLE];
        self.imgFilePath = [dict objectForKey:JSON_CATEGORY_IMAGEFILEPATH];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, JSON_CATEGORY_NAME,
            [NSNumber numberWithInt:self.Id], JSON_CATEGORY_ID,
            self.title, JSON_CATEGORY_TITLE,
            self.imgFilePath, JSON_CATEGORY_IMAGEFILEPATH,
            nil];
}

@end
