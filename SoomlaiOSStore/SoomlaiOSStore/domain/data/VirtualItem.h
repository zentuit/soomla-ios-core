//
//  VirtualItem.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/16/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualItem : NSObject {
    NSString* name;
    NSString* description;
    NSString* imgFilePath;
    NSString* itemId;
}

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* description;
@property (retain, nonatomic) NSString* imgFilePath;
@property (retain, nonatomic) NSString* itemId;

- (id)init;
- (id)initWithName:(NSString*)name andDescription:(NSString*)description
     andImgFilePath:(NSString*)imgFilePath andItemId:(NSString*)itemId;
- (id)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@end
