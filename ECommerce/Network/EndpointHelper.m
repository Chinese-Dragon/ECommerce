//
//  EndpointHelper.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "EndpointHelper.h"
#import "AppUserManager.h"

NSString *baseUrl =             @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/cust_category.php?";
NSString *baseRegistrationUrl = @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/shop_reg.php?";
NSString *baseLoginUrl =        @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/shop_login.php?";
NSString *resetPassUrl =        @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/shop_reset_pass.php?";
NSString *forgotPassUrl =        @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/shop_fogot_pass.php?";
NSString *productCategoryUrl =  @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/cust_category.php?";
NSString *productSubCategoryUrl =  @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/cust_sub_category.php?";
NSString *productListUrl =      @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/cust_product.php?";

@implementation EndpointHelper

+ (id)shareInstance {
	static EndpointHelper *shareInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shareInstance = [[self alloc] init];
	});
	return shareInstance;
}

- (NSURL *)getUserRegistrationUrlWithName:(NSString *)name
									phone:(NSString *)phone
									email:(NSString *)email
								 password:(NSString *)password {
	
	NSString *urlStr = [NSString stringWithFormat:@"%@name=%@&email=%@&mobile=%@&password=%@",baseRegistrationUrl,name,email,phone,password];
	NSString *remSpa = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSURL *url = [NSURL URLWithString:remSpa];
	return url;
}

- (NSURL *)getForgotPassUrlWithNumber: (NSString *)phone {
	NSString *urlStr = [NSString stringWithFormat:@"%@&mobile=%@",forgotPassUrl,phone];
	NSURL *url = [NSURL URLWithString:urlStr];
	return url;
}

- (NSURL *)getResetPassUrlWithNumber:(NSString *)phone
							password:(NSString *)password
						 newPassword:(NSString *)newPassword {
	
	NSString *urlStr = [NSString stringWithFormat:@"%@&mobile=%@&password=%@&newpassword=%@",resetPassUrl,phone,password,newPassword];
	NSURL *url = [NSURL URLWithString:urlStr];
	return url;
}

- (NSURL *)getLoginUrlWithNumber:(NSString *)phone
						password:(NSString *)password {
	
	NSString *urlStr = [NSString stringWithFormat:@"%@mobile=%@&password=%@",baseLoginUrl,phone,password];
	NSURL *url = [NSURL URLWithString:urlStr];
	return url;
}

- (NSURL *)getCategoryUrl {
	AppUserManager *manager = [AppUserManager sharedManager];
	[manager restore];
	if ([manager getApiKey] != nil) {
		NSString *key = [manager getApiKey];
		NSString *userId = [manager getUserId];
		NSString *urlStr = [NSString stringWithFormat:@"%@api_key=%@&user_id=%@",productCategoryUrl,key,userId];
		NSURL *url = [NSURL URLWithString:urlStr];
		return url;
	}
	return nil;
}

- (NSURL *)getSubCategoryUrlWithId:(NSString *)Id {
	AppUserManager *manager = [AppUserManager sharedManager];
	[manager restore];
	if ([manager getApiKey] != nil) {
		NSString *key = [manager getApiKey];
		NSString *userId = [manager getUserId];
		NSString *urlStr = [NSString stringWithFormat:@"%@Id=%@&api_key=%@&user_id=%@",productSubCategoryUrl,Id,key,userId];
		NSURL *url = [NSURL URLWithString:urlStr];
		return url;
	}
	return nil;
}

- (NSURL *)getProductListUrlWithId:(NSString *)Id {
	AppUserManager *manager = [AppUserManager sharedManager];
	[manager restore];
	if ([manager getApiKey] != nil) {
		NSString *key = [manager getApiKey];
		NSString *userId = [manager getUserId];
		NSString *urlStr = [NSString stringWithFormat:@"%@Id=%@&api_key=%@&user_id=%@",productListUrl,Id,key,userId];
		NSURL *url = [NSURL URLWithString:urlStr];
		return url;
	}
	return nil;
}

@end
