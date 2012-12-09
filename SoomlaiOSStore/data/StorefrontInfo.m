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

#import "StorefrontInfo.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "JSONKit.h"
#import "StoreEncryptor.h"

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
        
        [[[StorageManager getInstance] database] setStorefrontInfo:[StoreEncryptor encryptString:sfJSON]];
        
        NSDictionary* sfDict = [self.storefrontJson objectFromJSONString];
        //TODO: check that this value is parsed
        self.orientationLandscape = [((NSString*)[[sfDict objectForKey:@"template"] objectForKey:@"orientation"]) isEqualToString:@"landscape"];
    }
}

- (BOOL)initializeFromDB{
    NSString* sfJSON = [[[StorageManager getInstance] database] getStorefrontInfo];
    if (!sfJSON || [sfJSON isEqual:[NSNull null]] || sfJSON.length == 0){
        NSLog(@"storefront json is not in DB yet");
        return NO;
    }
    
    sfJSON = [StoreEncryptor decryptToString:sfJSON];
    
    self.storefrontJson = sfJSON;
    
    NSDictionary* sfDict = [sfJSON objectFromJSONString];
    
    //TODO: check that this value is parsed
    self.orientationLandscape = [((NSString*)[[sfDict objectForKey:@"template"] objectForKey:@"orientation"]) isEqualToString:@"landscape"];
    
    return YES;
}

- (NSDictionary*)toDictionary{
    return [self.storefrontJson objectFromJSONString];
}


@end
