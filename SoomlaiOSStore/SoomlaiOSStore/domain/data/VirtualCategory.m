//
//  VirtualCategory.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCategory.h"
#import "JSONConsts.h"

@implementation VirtualCategory

@synthesize Id, name;

- (id)initWithName:(NSString*)oName andId:(int)oId{
    
    self = [super init];
    if (self) {
        self.name = oName;
        self.Id = oId;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:JSON_CATEGORY_NAME];
        NSNumber* numId = [dict objectForKey:JSON_CATEGORY_ID];
        self.Id = [numId intValue];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.name, JSON_CATEGORY_NAME,
            [NSNumber numberWithInt:self.Id], JSON_CATEGORY_ID,
            nil];
}

@end
