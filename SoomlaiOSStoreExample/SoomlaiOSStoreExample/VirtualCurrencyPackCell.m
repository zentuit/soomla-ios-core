//
//  VirtualCurrencyPackCell.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 11/1/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCurrencyPackCell.h"

@implementation VirtualCurrencyPackCell

@synthesize icon, title, description, price;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
