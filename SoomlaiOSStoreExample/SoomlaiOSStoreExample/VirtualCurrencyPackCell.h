//
//  VirtualCurrencyPackCell.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 11/1/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualCurrencyPackCell : UITableViewCell{
    UIImageView* icon;
    UILabel* title;
    UILabel* description;
    UILabel* price;
}


@property (nonatomic, retain) IBOutlet UIImageView* icon;
@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* description;
@property (nonatomic, retain) IBOutlet UILabel* price;

@end
