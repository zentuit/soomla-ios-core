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
#define EVENT_BP_REWARD_TAKEN                   @"bp_reward_taken"


#define DICT_ELEMENT_REWARD                     @"reward"


@interface SoomlaEventHandling : NSObject

+ (void)postRewardGiven:(Reward *)reward;
+ (void)postRewardTaken:(Reward *)reward;

@end
