//
//  ViewController.h
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UILabel* titleLabel;
    UIImageView* logoImageView;
    UIView* leftView;
    UIView* rightView;
    UIImageView* rightBg;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView* logoImageView;
@property (nonatomic, retain) IBOutlet UIImageView* rightBg;
@property (nonatomic, retain) IBOutlet UIView* leftView;
@property (nonatomic, retain) IBOutlet UIView* rightView;

@end
