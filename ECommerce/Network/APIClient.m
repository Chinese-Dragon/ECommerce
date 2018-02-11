//
//  APIClient.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking/AFNetworking.h"
#import "EndpointHelper.h"
#import "NSString+NSString_Extension.h"
#import "Category.h"
#import "SubCategory.h"
#import "Product.h"

@implementation APIClient

+ (id)shareInstance {
	static APIClient *shareInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shareInstance = [[self alloc] init];
	});
	return shareInstance;
}

- (void)signupWithName:(NSString *)name
				 email:(NSString *)email
				 phone:(NSString *)phone
			  password:(NSString *)password
	 completionHandler:(SignupResultHandler) completion {
	
	// configure AFHTTPSessionManager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	NSURL *url = [[EndpointHelper shareInstance ] getUserRegistrationUrlWithName:name
																		   phone:phone
																		   email:email
																		password:password];
	
	[manager POST:url.absoluteString
	   parameters:nil
		 progress:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			  
			  NSString *responseMessage = [[NSString alloc] initWithData:(NSData *)responseObject encoding: NSUTF8StringEncoding];
			  NSLog(@"Reponse String is %@", responseMessage);
			  
			  // return error nil only if reponse is "successfully registered"
			  // TODO: CANNOT DETECT SUCCESSULLY REGISTERED RESPONSE, TWO STRING CAN NOT BE EQUAL!!!!@
			  if ([[responseMessage stringByStrippingWhitespace] isEqual: @"successfully registered"]) {
				  completion(nil);
			  } else {
				  // else return error msg
				  completion(responseMessage);
			  }
			  
		  }
		  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			  NSLog(@"Reponse Failture is %@", error);
			  completion(error.localizedDescription);
		  }];
}

-(void)loginWithPhone:(NSString *)phone
			 password:(NSString *)password
	completionHandler:(LoginResultHandler)completion {
	
	// configure AFHTTPSession Manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	NSURL *url = [[EndpointHelper shareInstance]
				  getLoginUrlWithNumber:phone
				  password:password];
	
	[manager GET:url.absoluteString
	  parameters:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 NSLog(@"%@", responseObject);
			 
			 // if return is not a json array then it's not success, we need to get the msg
			 if (![responseObject isKindOfClass:[NSArray class]]) {
				 NSDictionary *jsonDict = responseObject;
				 if (jsonDict == nil) {
					 completion(nil, @"Backend guy did not return anything");
				 } else if ([((NSArray *)jsonDict[@"msg"]).firstObject isKindOfClass:[NSString class]]){
					 // Too much attemps,try in the second 5 second msg
					 NSString *msg = ((NSArray *)jsonDict[@"msg"]).firstObject;
					 completion(nil, msg);
				 } else {
					 // error loginin, show how many attempts
					 NSString *attemptsLeft = ((NSArray *)jsonDict[@"msg"]).firstObject;
					 completion(nil, [NSString stringWithFormat:@"Wrong password, %@ attemps left", attemptsLeft]);
				 }
			 } else {
				 // return error nil only if reponse msg is "success"
				 // we have jsonArray, check message
				 NSDictionary *jsonDict = ((NSArray *)responseObject).firstObject;
				 NSString *msg = jsonDict[@"msg"];
				 if ([msg isEqualToString:@"success"]) {
					 completion(jsonDict, nil);
				 } else{
					 completion(nil, msg);
				 }
			 }
			 
		 }
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 completion(nil, @"Too many attempts, try again in 5 mins");
		 }];
}

- (void)fetchCategoryListWithCompletionHandler:(FetchCategoriesResultHandler)completion {
	// configure AFHTTPSession Manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	// get URL
	NSURL *url = [EndpointHelper.shareInstance getCategoryUrl];
	
	// make request
	[manager GET:url.absoluteString
	  parameters:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 // NOTE: parse resonse should not be here. this way iolates SOLID principle,need abstraction
			 if ([responseObject isKindOfClass: [NSDictionary class]]) {
				 NSDictionary *json = responseObject;
				 NSArray *jsonArray = [json valueForKey:@"Category"];
				 // all good start parsing
				 NSMutableArray<Category *> *categoryList = [NSMutableArray array];
				 for (id jsonObj in jsonArray) {
					 NSLog(@"%@", [jsonObj description]);
					 Category *newCategory = [[Category alloc] initWithDictionary:jsonObj error:nil];
					 [categoryList addObject:newCategory];
				 }
				 
				 completion(categoryList, nil);
			 }
		 }
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 NSLog(@"%@", error.localizedDescription);
			 completion(nil, [error localizedDescription]);
		 }];
}

- (void)fetchSubcategoryListWithId:(NSString *)categoryId completionHandler:(FetchSubCategoriesResultHandler)completion {
	// configure AFHTTPSession Manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	// get url
	NSURL *url = [EndpointHelper.shareInstance getSubCategoryUrlWithId:categoryId];
	
	// make request
	[manager GET:url.absoluteString
	  parameters:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 // NOTE: parse resonse should not be here. this way iolates SOLID principle,need abstraction
			 if ([responseObject isKindOfClass: [NSDictionary class]]) {
				 NSDictionary *json = responseObject;
				 NSArray *jsonArray = [json valueForKey:@"SubCategory"];
				 
				 // all good start parsing
				 NSMutableArray<SubCategory *> *categoryList = [NSMutableArray array];
				 for (id jsonObj in jsonArray) {
					 NSLog(@"%@", [jsonObj description]);
					 SubCategory *newCategory = [[SubCategory alloc] initWithDictionary:jsonObj error:nil];
					 [categoryList addObject:newCategory];
				 }
				 
				 completion(categoryList, nil);
			 }
		 }
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 NSLog(@"%@", error.localizedDescription);
			 completion(nil, [error localizedDescription]);
		 }];
}

- (void)fetchProductListWithSubcategoryId:(NSString *)subCategoryId completionHandler:(FetchProductsResultHandler)completion {
	// configure AFHTTPSession manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	// get url
	NSURL *url = [EndpointHelper.shareInstance getProductListUrlWithId:subCategoryId];
	
	// make request
	[manager GET:url.absoluteString
	  parameters:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 // NOTE: parse resonse should not be here. this way iolates SOLID principle,need abstraction
			 if ([responseObject isKindOfClass: [NSDictionary class]]) {
				 NSDictionary *json = responseObject;
				 NSArray *jsonArray = [json valueForKey:@"Product"];
				 
				 // all good start parsing
				 NSMutableArray<Product *> *productList = [NSMutableArray array];
				 for (id jsonObj in jsonArray) {
					 NSLog(@"%@", [jsonObj description]);
					 Product *newProduct = [[Product alloc] initWithDictionary:jsonObj error:nil];
					 [productList addObject:newProduct];
				 }
				 
				 completion(productList, nil);
			 }
		 }
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 NSLog(@"%@", error.localizedDescription);
			 completion(nil, [error localizedDescription]);
		 }];
}

- (void)resetPasswordWithPhone:(NSString *)phoneNumber oldPassword:(NSString *)oldPass newPassword:(NSString *)newPass completionHandler:(ResetPasswordResultHandler)completion {
	
	// configure AFHTTPSession manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	// get url
	NSURL *url = [EndpointHelper.shareInstance getResetPassUrlWithNumber:phoneNumber password:oldPass newPassword:newPass];
	
	[manager POST:url.absoluteString
	   parameters:nil progress:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			  if ([responseObject isKindOfClass: [NSDictionary class]]) {
				  NSDictionary *jsonDict = responseObject;
				  NSArray *responseArray = [jsonDict valueForKey:@"msg"];
				  NSString *msg = [((NSString *)responseArray.firstObject) stringByStrippingWhitespace];
				  if ([msg isEqualToString:@"password reset successfully"]) {
					  completion(nil);
				  } else {
					  completion(msg);
				  }
			  } else {
				  completion(@"Invalid Response");
			  }
		  }
		  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			  NSLog(@"%@", error.localizedDescription);
			  completion([error localizedDescription]);
		  }];
}

- (void)forgotPasswordWithPhone:(NSString *)phoneNumber
			   completonHandler:(ForgotPassewordResultHandler)completion {
	// configure AFHTTPSession manager
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
	
	// get url
	NSURL *url = [EndpointHelper.shareInstance getForgotPassUrlWithNumber:phoneNumber];
	
	//
	[manager GET:url.absoluteString
	  parameters:nil
		progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 if ([responseObject isKindOfClass: [NSArray class]]) {
				 // sucess response
				 NSDictionary *jsonDict = ((NSArray *)responseObject).firstObject;
				 NSString *oldPass = [jsonDict valueForKey:@"UserPassword"];
				 completion(oldPass, nil);
			 } else {
				 // error
				 NSDictionary *jsonDict = responseObject;
				 NSArray *responseArray = [jsonDict valueForKey:@"msg"];
				 NSString *msg = [((NSString *)responseArray.firstObject) stringByStrippingWhitespace];
				 completion(nil, msg);
			 }
		 }
		 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 
		 }];
}

@end
