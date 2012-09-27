//
//  SoomlaViewController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/23/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "StorefrontViewController.h"
#import "StoreController.h"
#import "StorefrontJS.h"

@interface StorefrontViewController ()

@end

@implementation StorefrontViewController

@synthesize storeWebview, pendingMessages, jsUIReady, storefrontJS;

- (void)viewDidLoad
{
    [super viewDidLoad];

    pendingMessages = [[NSMutableArray alloc] init];
    jsUIReady = NO;
    
    self.storefrontJS = [[StorefrontJS alloc] initWithStorefrontViewController:self];
    
    [[StoreController getInstance] storeOpening];
    
    storeWebview = [[UIWebView alloc] initWithFrame:self.view.frame];
    storeWebview.delegate = self.storefrontJS;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"store" ofType:@"html" inDirectory:@"soomla_ui"]];
    [storeWebview loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)closingStore:(NSNotification*)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    BOOL isLandscapeRight = (UIInterfaceOrientationLandscapeRight == toInterfaceOrientation);
    return isLandscapeRight;
}

- (void)loadWebView{
    [self.view addSubview:storeWebview];
    [self.view bringSubviewToFront:storeWebview];
}

- (void)sendToJSWithAction:(NSString*)action andData:(NSString*)data{
    NSString* urlToLoad = [NSString stringWithFormat:@"SoomlaJS.%@(%@)", action, data];
    
    if (!jsUIReady){
        [pendingMessages addObject:urlToLoad];
    }
    else{
        NSLog(@"sending message to JS: %@", urlToLoad);
        
        [storeWebview stringByEvaluatingJavaScriptFromString:urlToLoad];
        
        while (pendingMessages.count > 0) {
            NSString* tmpPendingUrl = [pendingMessages objectAtIndex:0];
            [pendingMessages removeObjectAtIndex:0];

            NSLog(@"sending message to JS: %@", tmpPendingUrl);
            [storeWebview stringByEvaluatingJavaScriptFromString:tmpPendingUrl];
        }
    }
}

- (void)closeStore{
    [[StoreController getInstance] storeClosing];
    [storeWebview removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self removeFromParentViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
