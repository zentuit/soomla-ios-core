//
//  SoomlaEventHandling.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "SoomlaEventHandling.h"
#import "BadgeReward.h"


@implementation SoomlaEventHandling

+ (void)postRewardGiven:(Reward *)reward {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              reward, DICT_ELEMENT_REWARD,
                              [reward isKindOfClass:[BadgeReward class]], DICT_ELEMENT_IS_BADGE,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_REWARD_GIVEN object:self userInfo:userInfo];
}


@end
