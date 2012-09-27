//
//  StorefrontController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StorefrontViewController;

@interface StorefrontJS : NSObject <UIWebViewDelegate>{
    @private
    StorefrontViewController* sfViewController;
}

@property (nonatomic, retain) StorefrontViewController* sfViewController;

- (id)initWithStorefrontViewController:(StorefrontViewController*)sfvc;
- (void)updateContentInJS;
@end
