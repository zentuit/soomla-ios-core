//
//  EncryptionTransformer.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/17/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionTransformer : NSValueTransformer{
}

/**
 * Returns the key used for encrypting / decrypting values during transformation.
 */
- (NSString*)key;

@end