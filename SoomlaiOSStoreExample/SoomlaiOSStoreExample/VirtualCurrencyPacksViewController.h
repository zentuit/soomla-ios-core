//
//  VirtualCurrencyPacksViewController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 11/1/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualCurrencyPacksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    @private
    UILabel* currencyBalance;
    UITableViewController* table;
}

@property (nonatomic, retain) IBOutlet UILabel* currencyBalance;
@property (nonatomic, retain) IBOutlet UITableViewController* table;

- (IBAction)back:(id)sender;

@end
