//
//  AppUserManager.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductOrder;
@interface AppUserManager : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString *, ProductOrder *> *productOrdersDict;

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

+(AppUserManager *)sharedManager;
@end
