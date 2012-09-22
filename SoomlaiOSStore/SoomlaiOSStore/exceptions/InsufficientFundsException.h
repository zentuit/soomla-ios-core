//
//  InsufficientFundsException.h
//  SoomlaStore
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsufficientFundsException : NSException

- (id)initWithItemId:(NSString*)itemId;

@end
