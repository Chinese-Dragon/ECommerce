//
//  AppUserManager.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUserManager : NSObject

- (NSString *)getApiKey;
- (NSString *)getUserName;
- (NSString *)getUserEmail;
- (NSString *)getMobile;
- (NSString *)getUserId;
- (void)setUserName: (NSString *)username;
- (void)setUserEmail: (NSString *)email;

- (void)saveUserData: (NSDictionary *)json;
- (void)restore;
- (void)reset;

+(id)sharedManager;
@end
