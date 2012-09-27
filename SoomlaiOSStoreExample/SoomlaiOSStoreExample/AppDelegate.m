//
//  AppDelegate.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "AppDelegate.h"
#import "StoreController.h"
#import "MuffinRushAssets.h"
#import "JSONKit.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"muffinRushTheme" ofType:@"json"];
//    NSString *json = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
//    
//    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:[json objectFromJSONString]];
//    [d setObject:[NSArray arrayWithObject:@"HAHAHAAH"] forKey:@"AAA"];
//    NSString* j = [d JSONString];
    
    [[StoreController getInstance] initializeWithStoreAssets:[[MuffinRushAssets alloc] init]];
    
//    [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
