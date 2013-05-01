//
//  VirtualGoodsViewController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 10/31/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualGoodsViewController.h"
#import "MuffinRushAssets.h"
#import "StoreInfo.h"
#import "VirtualGood.h"
#import "VirtualGoodCell.h"
#import "StoreController.h"
#import "EventHandling.h"
#import "StoreInventory.h"
#import "InsufficientFundsException.h"
#import "PurchaseWithVirtualItem.h"

@interface VirtualGoodsViewController () {
    NSDictionary* images;
}

@end

@implementation VirtualGoodsViewController

@synthesize currencyBalance, table;

- (void)viewDidLoad
{
    [[StoreController getInstance] storeOpening];
    
    images = [NSDictionary dictionaryWithObjectsAndKeys:
	      @"chocolate_cake.png", CHOCO_CAKE_GOOD_ITEM_ID,
	      @"pavlova.png", PAVLOVA_GOOD_ITEM_ID,
	      @"cream_cup.png", CREAM_CUP_GOOD_ITEM_ID,
	      @"fruit_cake.png", FRUIT_CAKE_GOOD_ITEM_ID,
	      nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(curBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
    
    int balance = [StoreInventory getItemBalance:MUFFINS_CURRENCY_ITEM_ID];
    currencyBalance.text = [NSString stringWithFormat:@"%d", balance];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSING_STORE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)curBalanceChanged:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    currencyBalance.text = [NSString stringWithFormat:@"%d", [(NSNumber*)[userInfo objectForKey:@"balance"] intValue]];
}

- (void)goodBalanceChanged:(NSNotification*)notification{
    [table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    VirtualGood* good = [[[StoreInfo getInstance] virtualGoods] objectAtIndex:indexPath.row];
    
    @try {
        [good buy];
    }
    @catch (InsufficientFundsException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insufficient funds"
                                                        message:@"You don't have enough muffins to purchase this item."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

        [alert show];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[StoreInfo getInstance] virtualGoods] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    VirtualGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VirtualGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    VirtualGood* good = [[[StoreInfo getInstance] virtualGoods] objectAtIndex:indexPath.row];
    cell.title.text = good.name;
    cell.description.text = good.description;

    cell.price.text = [NSString stringWithFormat:@"%d", ((PurchaseWithVirtualItem*)good.purchaseType).amount];
    cell.icon.image = [UIImage imageNamed:[images objectForKey:good.itemId]];
    int balance = [StoreInventory getItemBalance:good.itemId];
    cell.balance.text = [NSString stringWithFormat:@"%d", balance];
    
    return cell;
}

@end
