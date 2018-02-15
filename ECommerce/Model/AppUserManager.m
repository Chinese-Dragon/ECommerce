//
//  AppUserManager.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "AppUserManager.h"
#import "ProductOrder.h"
@implementation AppUserManager
NSString *userDefaultKey = @"AppUserDefaultKey";

NSString *apiKey, *userName, *userId, *userEmail, *phone;


+ (AppUserManager *)sharedManager {
	static AppUserManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[self alloc] init];
	});
	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_productOrdersDict = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)saveUserData:(NSDictionary *)jsonDict {
	// parse json
	// TODO: Change parsing to .valueForKey
	
	NSString *appKey = [jsonDict valueForKey:@"AppApiKey "];
	NSString *email = [jsonDict valueForKey:@"UserEmail"];
	NSString *userId = [jsonDict valueForKey:@"UserID"];
	NSString *phone = [jsonDict valueForKey:@"UserMobile"];
	NSString *username = [jsonDict valueForKey:@"UserName"];
	
	NSDictionary *userDict = @{@"appKey": appKey,
							   @"userId":userId,
							   @"username":username,
							   @"email":email,
							   @"phone":phone
							   };
	
	[NSUserDefaults.standardUserDefaults setValue:userDict forKey:userDefaultKey];
}

- (void)restore {
	// after restore if fields are not existed then return nil
	NSDictionary *userDict = [NSUserDefaults.standardUserDefaults valueForKey:userDefaultKey];
	apiKey = [userDict valueForKey:@"appKey"];
	userName = [userDict valueForKey:@"username"];
	userId = [userDict valueForKey:@"userId"];
	userEmail = [userDict valueForKey:@"email"];
	phone = [userDict valueForKey:@"phone"];
}

- (void)reset {
	apiKey = nil;
	userName = nil;
	userId = nil;
	userEmail = nil;
	phone = nil;
	
	// remove userdefault value
	[NSUserDefaults.standardUserDefaults removeObjectForKey:userDefaultKey];
	
	// clean up the productorder Dict
	[self.productOrdersDict removeAllObjects];
}

// getters for iVars
- (NSString *)getApiKey {
	return apiKey;
}

- (NSString *)getUserName {
	return userName;
}

- (NSString *)getUserEmail {
	return userEmail;
}

- (NSString *)getMobile {
	return phone;
}

- (NSString *)getUserId {
	return userId;
}

// should not use this now
- (void)setUserName:(NSString *)username {
	userName = username;
}

- (void)setUserEmail:(NSString *)email {
	userEmail = email;
}

@end





