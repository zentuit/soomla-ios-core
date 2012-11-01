//
//  VirtualGoodsViewController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 10/31/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualGoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    @private
    UILabel* currencyBalance;
    UITableView* table;
}

@property (nonatomic, retain) IBOutlet UILabel* currencyBalance;
@property (nonatomic, retain) IBOutlet UITableView* table;

- (IBAction)back:(id)sender;

@end
