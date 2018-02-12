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
NSString *makeOrderUrl = @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/orders.php?";
NSString *orderHistoryUrl = @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/order_history.php?";
NSString *orderStatusUrl = @"https://rjtmobile.com/ansari/shopingcart/ios_ssl/order_track.php?";

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
// &item_id=    316    &item_names=     Mac-Book    &item_quantity=   1    &final_price=    70000     &mobile=    4243866571 &api_key=      ae64f53d3fd8da113d7c733a090dd8cc     &user_id=     1121
- (NSURL *)getMakeOrderUrlWithItemId:(NSString *)itemId itemName:(NSString *)name orderedQuantity:(NSString *)quantity finalPrice:(NSString *)price {
	AppUserManager *manager = [AppUserManager sharedManager];
	[manager restore];
	if ([manager getApiKey] != nil) {
		NSString *phone = [manager getMobile];
		NSString *key = [manager getApiKey];
		NSString *userId = [manager getUserId];
		
		NSString *urlStr = [NSString stringWithFormat:@"%@&item_id=%@&item_names=%@&item_quantity=%@&final_price=%@&mobile=%@&api_key=%@&user_id=%@",makeOrderUrl, itemId, name, quantity, price, phone, key, userId];
		NSString *remSpa = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSURL *url = [NSURL URLWithString:remSpa];
		return url;
	}
	return nil;
}
// &mobile=   4243866571    &api_key=   ae64f53d3fd8da113d7c733a090dd8cc   &user_id=  1121
- (NSURL *)getOrderHistoryUrl {
	AppUserManager *manager = [AppUserManager sharedManager];
	[manager restore];
	if ([manager getApiKey] != nil) {
		NSString *phone = [manager getMobile];
		NSString *key = [manager getApiKey];
		NSString *userId = [manager getUserId];
		
		NSString *urlStr = [NSString stringWithFormat:@"%@&mobile=%@&api_key=%@&user_id=%@",orderHistoryUrl, phone, key, userId];
		NSString *remSpa = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];

		NSURL *url = [NSURL URLWithString:remSpa];
		return url;
	}
	return nil;
}

//- (NSURL *)getStatusUrlForOrderId:(NSString *)orderId {
//	AppUserManager *manager = [AppUserManager sharedManager];
//	[manager restore];
//
//}

@end
