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

#import "KeyValueStorage.h"
#import "KeyValDatabase.h"
#import "StoreEncryptor.h"
#import "StorageManager.h"

@implementation KeyValueStorage

- (NSString*)getValueForKey:(NSString*)key {
    NSString* val = [[[StorageManager getInstance] kvDatabase] getValForKey:[StoreEncryptor encryptString:key]];
    if (val && [val length]>0){
        return [StoreEncryptor decryptToString:val];
    }
    
    return NULL;
}

- (void)setValue:(NSString*)val forKey:(NSString*)key {
    [[[StorageManager getInstance] kvDatabase] setVal:[StoreEncryptor encryptString:val] forKey:[StoreEncryptor encryptString:key]];
}

- (void)deleteValueForKey:(NSString*)key {
    [[[StorageManager getInstance] kvDatabase] deleteKeyValWithKey:[StoreEncryptor encryptString:key]];
}

@end
