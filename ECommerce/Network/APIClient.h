//
//  APIClient.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Category;
@class SubCategory;
@class Product;

typedef void (^SignupResultHandler)(NSString *);
typedef void (^LoginResultHandler)(NSDictionary *, NSString *);
typedef void (^FetchCategoriesResultHandler) (NSMutableArray<Category *> *, NSString *);
typedef void (^FetchSubCategoriesResultHandler) (NSMutableArray<SubCategory *> *, NSString *);
typedef void (^FetchProductsResultHandler) (NSMutableArray<Product *> *, NSString *);
typedef void (^ForgotPassewordResultHandler) (NSString *, NSString *);
typedef void (^ResetPasswordResultHandler) (NSString *);

@interface APIClient : NSObject

+ (id)shareInstance;

- (void)signupWithName: (NSString *)name
				 email:(NSString *)email
				 phone:(NSString *)phone
			  password:(NSString *)password
	 completionHandler:(SignupResultHandler)completion;

- (void)loginWithPhone: (NSString *)phone
			  password:(NSString *)password
	 completionHandler:(LoginResultHandler)completion;

- (void)fetchCategoryListWithCompletionHandler: (FetchCategoriesResultHandler)completion;

- (void)fetchSubcategoryListWithId: (NSString *)categoryId
				 completionHandler: (FetchSubCategoriesResultHandler)completion;

- (void)fetchProductListWithSubcategoryId: (NSString *)subCategoryId
						completionHandler: (FetchProductsResultHandler)completion;

- (void)resetPasswordWithPhone: (NSString *)phoneNumber
				   oldPassword: (NSString *)oldPass
				   newPassword: (NSString *)newPass
			 completionHandler: (ResetPasswordResultHandler)completion;

- (void)forgotPasswordWithPhone: (NSString *)phoneNumber
			   completonHandler: (ForgotPassewordResultHandler)completion;

@end
