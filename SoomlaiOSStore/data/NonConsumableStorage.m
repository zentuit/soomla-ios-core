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

#import "NonConsumableStorage.h"
#import "AppStoreItem.h"
#import "StorageManager.h"
#import "StoreDatabase.h"
#import "StoreEncryptor.h"
#import "NonConsumableItem.h"

@implementation NonConsumableStorage


- (BOOL)nonConsumableExists:(NonConsumableItem*)appStoreItem{
    NSString* productId = [StoreEncryptor encryptString:appStoreItem.appStoreItem.productId];
    return [[[StorageManager getInstance] database] getAppStoreNonConsumableExists:productId];
}

- (void)add:(NonConsumableItem*)appStoreItem{
    NSString* productId = [StoreEncryptor encryptString:appStoreItem.appStoreItem.productId];
    [[[StorageManager getInstance] database] setAppStoreNonConsumable:productId purchased:true];
}

- (void)remove:(NonConsumableItem*)appStoreItem{
    NSString* productId = [StoreEncryptor encryptString:appStoreItem.appStoreItem.productId];
    [[[StorageManager getInstance] database] setAppStoreNonConsumable:productId purchased:false];
}


@end
