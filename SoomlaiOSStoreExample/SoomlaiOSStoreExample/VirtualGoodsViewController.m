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

#define KEY_GOOD    @"GOOD"
#define KEY_THUMB   @"THUMB"

@interface VirtualGoodsViewController () {
    NSArray* goods;
}

@end

@implementation VirtualGoodsViewController

@synthesize currencyBalance, table;

- (void)viewDidLoad
{
    [StoreInventory addAmount:1000 toCurrency:MUFFINS_CURRENCY_ITEM_ID];
    [[StoreController getInstance] storeOpening];
    
    goods = [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] goodWithItemId:CHOCO_CAKE_GOOD_ITEM_ID], KEY_GOOD,
              @"chocolate_cake.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] goodWithItemId:PAVLOVA_GOOD_ITEM_ID], KEY_GOOD,
              @"pavlova.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] goodWithItemId:CREAM_CUP_GOOD_ITEM_ID], KEY_GOOD,
              @"cream_cup.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] goodWithItemId:FRUIT_CAKE_GOOD_ITEM_ID], KEY_GOOD,
              @"fruit_cake.png", KEY_THUMB,
              nil],
             nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodPurchased:) name:EVENT_VIRTUAL_GOOD_PURCHASED object:nil];
    
    int balance = [StoreInventory getCurrencyBalance:MUFFINS_CURRENCY_ITEM_ID];
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

- (void)goodPurchased:(NSNotification*)notification{
    int cbalance = [StoreInventory getCurrencyBalance:MUFFINS_CURRENCY_ITEM_ID];
    currencyBalance.text = [NSString stringWithFormat:@"%d", cbalance];

    [table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    NSDictionary *item = [goods objectAtIndex:indexPath.row];
    VirtualGood* good = [item objectForKey:KEY_GOOD];
    
    @try {
        [[StoreController getInstance] buyVirtualGood:good.itemId];
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
    return [goods count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    VirtualGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VirtualGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    NSDictionary *item = [goods objectAtIndex:indexPath.row];
    VirtualGood* good = [item objectForKey:KEY_GOOD];
    cell.title.text = good.name;
    cell.description.text = good.description;
    NSDictionary* currencyValues = good.currencyValues;
    cell.price.text = [(NSNumber*)[currencyValues objectForKey:MUFFINS_CURRENCY_ITEM_ID] stringValue];
    cell.icon.image = [UIImage imageNamed:[item objectForKey:KEY_THUMB]];
    int balance = [StoreInventory getGoodBalance:good.itemId];
    cell.balance.text = [NSString stringWithFormat:@"%d", balance];
    
    return cell;
}

@end
