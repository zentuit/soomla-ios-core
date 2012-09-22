//
//  VirtualCategory.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualCategory : NSObject{
    NSString* name;
    int       Id;
}

@property (retain, nonatomic) NSString* name;
@property int Id;

- (id)initWithName:(NSString*)oName andId:(int)oId;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@end
