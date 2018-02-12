//
//  EndpointHelper.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndpointHelper : NSObject

+ (id)shareInstance;

- (NSURL *)getForgotPassUrlWithNumber: (NSString *)phone;

- (NSURL *)getResetPassUrlWithNumber: (NSString *)phone
									password:(NSString *)password
									newPassword:(NSString *)newPassword;

- (NSURL *)getUserRegistrationUrlWithName: (NSString *)name
								 phone:(NSString *)phone
								 email:(NSString *)email
								 password:(NSString *)password;

- (NSURL *)getLoginUrlWithNumber: (NSString *)phone
					  password:(NSString *)password;

- (NSURL *)getCategoryUrl;

- (NSURL *)getSubCategoryUrlWithId: (NSString *)Id;
- (NSURL *)getProductListUrlWithId: (NSString *)Id;

- (NSURL *)getMakeOrderUrlWithItemId: (NSString *)itemId
							itemName:(NSString *)name
					 orderedQuantity: (NSString *)quantity
						  finalPrice: (NSString *)price;

- (NSURL *)getOrderHistoryUrl;

- (NSURL *)getStatusUrlForOrderId: (NSString *)orderId;

@end
