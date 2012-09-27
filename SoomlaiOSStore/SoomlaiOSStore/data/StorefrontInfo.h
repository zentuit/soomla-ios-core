//
//  StorefrontInfo.h
//  SoomlaiOSStore
//
//  Created by Refael Dakar on 9/24/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorefrontInfo : NSObject{
    @private
    BOOL orientationLandscape;
    @public
    NSString* storefrontJson;
}

@property (nonatomic, retain) NSString* storefrontJson;
@property BOOL orientationLandscape;

+ (StorefrontInfo*)getInstance;

- (void)initializeWithJSON:(NSString*)sfJSON;
- (BOOL)initializeFromDB;
- (NSDictionary*)toDictionary;

@end
