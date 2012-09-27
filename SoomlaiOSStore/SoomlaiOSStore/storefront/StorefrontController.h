//
//  StorefrontController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StorefrontViewController;

@interface StorefrontController : NSObject{
    StorefrontViewController* sfViewController;
}

@property (nonatomic, retain) StorefrontViewController* sfViewController;

+ (StorefrontController*)getInstance;

- (void)openStoreWithParentViewController:(UIViewController *)viewController andStorefrontInfoJSON:(NSString*)storefrontJSON;


@end
