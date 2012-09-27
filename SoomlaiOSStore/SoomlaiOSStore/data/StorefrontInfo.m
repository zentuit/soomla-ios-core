//
//  StorefrontInfo.m
//  SoomlaiOSStore
//
//  Created by Refael Dakar on 9/24/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StorefrontInfo.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "JSONKit.h"

@implementation StorefrontInfo

@synthesize storefrontJson, orientationLandscape;

+ (StorefrontInfo*)getInstance{
    static StorefrontInfo* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StorefrontInfo alloc ] init];
        }
    }
    
    return _instance;
}

- (void)initializeWithJSON:(NSString*)sfJSON{
    if (sfJSON.length == 0){
        NSLog(@"The given storefront JSON can't be null or empty !");
        return;
    }
    
    if (![self initializeFromDB]){
        self.storefrontJson = sfJSON;
        
        NSDictionary* sfDict = [self.storefrontJson objectFromJSONString];
        //TODO: check that this value is parsed
        self.orientationLandscape = [(NSNumber*)[[sfDict objectForKey:@"theme"] objectForKey:@"isOrientationLandscape"] boolValue];
    }
}

- (BOOL)initializeFromDB{
    NSString* sfJSON = [[[StorageManager getInstance] database] getStorefrontInfo];
    if (sfJSON == NULL || sfJSON.length == 0){
        NSLog(@"storefront json is not in DB yet");
        return NO;
    }
    
    self.storefrontJson = sfJSON;
    
    NSDictionary* sfDict = [sfJSON objectFromJSONString];
    
    //TODO: check that this value is parsed
    self.orientationLandscape = [(NSNumber*)[[sfDict objectForKey:@"theme"] objectForKey:@"isOrientationLandscape"] boolValue];
    
    return YES;
}

- (NSDictionary*)toDictionary{
    return [self.storefrontJson objectFromJSONString];
}


@end
