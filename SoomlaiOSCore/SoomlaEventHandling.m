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

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_REWARD_GIVEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_REWARD_TAKEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_CUSTOM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_KEYVALUE_CHANGE object:nil];
}

+ (void)postRewardGiven:(NSString *)rewardId {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_REWARD: rewardId
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_REWARD_GIVEN object:self userInfo:userInfo];
}

+ (void)postRewardTaken:(NSString *)rewardId {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_REWARD: rewardId
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_REWARD_TAKEN object:self userInfo:userInfo];
}

+ (void)postCustomEventWithName:(NSString*)name andExtraInfo:(NSDictionary*)extra {
    NSDictionary* userInfo = @{
                               DICT_ELEMENT_NAME: name,
                               DICT_ELEMENT_EXTRA: extra
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CUSTOM object:self userInfo:userInfo];
}

+ (void)postKeyValueStorageChange:(NSString *)val forKey:(NSString*)key {
    NSDictionary* userInfo = @{
                               DICT_ELEMENT_KEY: key,
                               DICT_ELEMENT_VAL: val
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_KEYVALUE_CHANGE object:self userInfo:userInfo];
}

@end
