//
//  VirtualCurrencyPacksViewController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 11/1/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "VirtualCurrencyPacksViewController.h"
#import "MuffinRushAssets.h"
#import "StoreInfo.h"
#import "EventHandling.h"
#import "StoreInventory.h"
#import "StoreController.h"
#import "VirtualCurrencyPack.h"
#import "AppStoreItem.h"
#import "VirtualItemNotFoundException.h"
#import "VirtualCurrencyPackCell.h"

#define KEY_PACK    @"PACK"
#define KEY_THUMB   @"THUMB"

@interface VirtualCurrencyPacksViewController () {
    NSArray* packs;
}

@end

@implementation VirtualCurrencyPacksViewController

@synthesize currencyBalance, table;

- (void)viewDidLoad
{
    packs = [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] currencyPackWithProductId:_10_MUFFINS_PACK_PRODUCT_ID], KEY_PACK,
              @"muffins01.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] currencyPackWithProductId:_50_MUFFINS_PACK_PRODUCT_ID], KEY_PACK,
              @"muffins02.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] currencyPackWithProductId:_400_MUFFINS_PACK_PRODUCT_ID], KEY_PACK,
              @"muffins03.png", KEY_THUMB,
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              [[StoreInfo getInstance] currencyPackWithProductId:_1000_MUFFINS_PACK_PRODUCT_ID], KEY_PACK,
              @"muffins04.png", KEY_THUMB,
              nil],
             nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(curBalanceChanged:) name:EVENT_CHANGED_CURRENCY_BALANCE object:nil];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)curBalanceChanged:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    currencyBalance.text = [NSString stringWithFormat:@"%d", [(NSNumber*)[userInfo objectForKey:@"balance"] intValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    NSDictionary *item = [packs objectAtIndex:indexPath.row];
    VirtualCurrencyPack* pack = [item objectForKey:KEY_PACK];

    [[StoreController getInstance] buyAppStoreItemWithProcuctId:pack.appstoreItem.productId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [packs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    VirtualCurrencyPackCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VirtualCurrencyPackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    NSDictionary *item = [packs objectAtIndex:indexPath.row];
    VirtualCurrencyPack* pack = [item objectForKey:KEY_PACK];
    cell.title.text = pack.name;
    cell.description.text = pack.description;
    cell.price.text = [NSString stringWithFormat:@"%.02f", pack.price];
    cell.icon.image = [UIImage imageNamed:[item objectForKey:KEY_THUMB]];
    
    return cell;
}

@end
