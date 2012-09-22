//
//  VirtualItemNotFoundException.m
//  SoomlaStore
//
//  Created by Refael Dakar on 9/20/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualItemNotFoundException.h"

@implementation VirtualItemNotFoundException

- (id)initWithLookupField:(NSString*)lookupField andLookupValue:(NSString*)lookupVal{
    NSString* reason = [[[@"Virtual item was not found when searching with " stringByAppendingString:lookupField] stringByAppendingString:@"="] stringByAppendingString: lookupVal];
    self = [super initWithName:@"VirtualItemNotFoundException" reason:reason userInfo:nil];
    if (self){
        
    }
    
    return self;
}

@end
