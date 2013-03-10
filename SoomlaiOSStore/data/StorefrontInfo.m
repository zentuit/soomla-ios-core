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
#import "KeyValDatabase.h"
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

- (void)initialize{
    
    if (![self initializeFromDB]){
        NSString* sfJSON = [self fetchThemeJsonFromFile];
        if (!sfJSON) {
            NSLog(@"Couldn't find storefront in the DB AND the filesystem. Something is totally wrong !");
            return;
        }
        self.storefrontJson = sfJSON;
        
        [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptString:sfJSON] forKey:[KeyValDatabase keyMetaStorefrontInfo]];
        
        NSDictionary* sfDict = [self.storefrontJson objectFromJSONString];
        //TODO: check that this value is parsed
        self.orientationLandscape = [((NSString*)[[sfDict objectForKey:@"template"] objectForKey:@"orientation"]) isEqualToString:@"landscape"];
    }
}

- (NSString*) fetchThemeJsonFromFile {
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"soomla/theme" ofType:@"json"];
    if (jsonPath)  {
        return [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSLog(@"Can't read JSON storefront file. Please add theme.json as a bundle resource.");
    return NULL;
}

- (BOOL)initializeFromDB{
    NSString* sfJSON = [[[StorageManager getInstance] kvDatabase] getValForKey:[KeyValDatabase keyMetaStorefrontInfo]];
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
