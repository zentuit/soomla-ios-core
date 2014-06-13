//
//  SoomlaEventHandling.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Reward;

// Events
#define EVENT_BP_REWARD_GIVEN                   @"bp_reward_given"


#define DICT_ELEMENT_REWARD                     @"reward"
#define DICT_ELEMENT_IS_BADGE                   @"isBadge"


@interface SoomlaEventHandling : NSObject

+ (void)postRewardGiven:(Reward *)reward;

@end
