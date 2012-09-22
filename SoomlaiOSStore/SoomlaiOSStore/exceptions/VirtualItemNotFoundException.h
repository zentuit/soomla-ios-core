//
//  VirtualItemNotFoundException.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualItemNotFoundException : NSException

- (id)initWithLookupField:(NSString*)lookupField andLookupValue:(NSString*)lookupVal;

@end
