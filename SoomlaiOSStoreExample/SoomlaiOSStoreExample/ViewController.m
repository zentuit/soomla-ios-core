//
//  ViewController.m
//  SoomlaiOSStoreExample
//
//  Created by Refael Dakar on 9/22/12.
//  Copyright (c) 2012 SOOMLA. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StorefrontController.h"
#import "JSONKit.h"
#import "EventHandling.h"

@interface ViewController (){
    BOOL dragging;
    BOOL onDropZone;
}
@end

@implementation ViewController

@synthesize titleLabel, logoImageView, leftView, rightView, rightBg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [titleLabel setFont:[UIFont fontWithName:@"GoodDog" size:50]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closingStore:) name:EVENT_CLOSING_STORE object:nil];
    
    rightView.layer.cornerRadius = 7;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)closingStore:(NSNotification*)notification{
    [leftView addSubview:logoImageView];
    [leftView bringSubviewToFront:logoImageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        if ([self isPoint:touchPoint OnView:leftView]){
            dragging = YES;
            logoImageView.center = [[touches anyObject] locationInView:leftView];
            [self.view bringSubviewToFront:leftView];
            [self.view bringSubviewToFront:logoImageView];
        }
    }
}

- (BOOL)isPoint:(CGPoint)point OnView:(UIView*)view{
    return point.x > view.frame.origin.x &&
    point.x < view.frame.origin.x + view.frame.size.width &&
    point.y > view.frame.origin.y &&
    point.y < view.frame.origin.y + view.frame.size.height;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (dragging){
        logoImageView.center = [[touches anyObject] locationInView:leftView];
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];

        BOOL pointOnView = [self isPoint:touchPoint OnView:rightView];
        if (pointOnView && !onDropZone)
        {
            onDropZone = YES;
            [rightBg setImage:[UIImage imageNamed:@"right_bg_hover.png"]];
        }
        else if (!pointOnView && onDropZone){
            onDropZone = NO;
            [rightBg setImage:[UIImage imageNamed:@"right_bg.png"]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if ([self isPoint:touchPoint OnView:rightView])
    {
        [rightView addSubview:logoImageView];
        [rightView bringSubviewToFront:logoImageView];
        
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"muffinRushTheme" ofType:@"json"];
        NSString *json = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
        
        [[StorefrontController getInstance] openStoreWithParentViewController:self andStorefrontInfoJSON:json];
    }
    else{
        logoImageView.frame = CGRectMake(0,0,
                                       logoImageView.frame.size.width,
                                       logoImageView.frame.size.height);
    }
}

@end
