//
//  SoomlaViewController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StorefrontJS;

@interface StorefrontViewController : UIViewController{
    @private
    UIWebView* storeWebview;
    NSMutableArray* pendingMessages;
    @public
    BOOL jsUIReady;
    StorefrontJS* storefrontJS;
}

@property (nonatomic, retain) IBOutlet UIWebView* storeWebview;
@property (nonatomic, retain) NSMutableArray* pendingMessages;
@property (nonatomic, retain) StorefrontJS* storefrontJS;
@property BOOL jsUIReady;

- (void)loadWebView;
- (void)sendToJSWithAction:(NSString*)action andData:(NSString*)data;
- (void)closeStore;

@end
