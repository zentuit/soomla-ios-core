

#import "ObscuredNSUserDefaults.h"
#import "UIDevice-IdentifierAddition.h"
#import "StoreConfig.h"
#import <CommonCrypto/CommonCryptor.h>
#import "FBEncryptorAES.h"

@interface ObscuredNSUserDefaults (Private)
+ (NSString*)key;
@end

@implementation ObscuredNSUserDefaults

+ (NSString*)key
{
//    NSLog(@"%@", SOOM_SEC);
    return [SOOM_SEC stringByAppendingString:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    NSString* val = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    if (!val) {
        return NO;
    }
    val = [FBEncryptorAES decryptBase64String:val
                                    keyString:[ObscuredNSUserDefaults key]];
    return [val isEqualToString:@"YES"];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    NSString* val = value ? @"YES" : @"NO";
    val = [FBEncryptorAES encryptBase64String:val
                                    keyString:[ObscuredNSUserDefaults key]
                                separateLines:NO];
    [[NSUserDefaults standardUserDefaults] setValue:val forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)stringForKey:(NSString *)defaultName {
    NSString* val = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    if (!val) {
        return @"";
    }
    return [FBEncryptorAES decryptBase64String:val
                                     keyString:[ObscuredNSUserDefaults key]];
}

+ (void)setString:(NSString*)value forKey:(NSString *)defaultName {
    NSString* val = [FBEncryptorAES encryptBase64String:value
                                    keyString:[ObscuredNSUserDefaults key]
                                separateLines:NO];
    [[NSUserDefaults standardUserDefaults] setValue:val forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
