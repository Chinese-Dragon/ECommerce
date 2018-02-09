//
//  Product.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc]
			initWithModelToJSONDictionary:
			@{
			  @"productId": @"Id",
			  @"name": @"ProductName",
			  @"quantity": @"Quantity",
			  @"price": @"Prize",
			  @"productDescription": @"Discription",
			  @"productImage": @"Image"
			  }];
}

- (void)setPrice:(NSNumber *)price {
	float usdValue = [price floatValue] * 0.16;
	_price = [NSNumber numberWithFloat:usdValue];
}
@end
