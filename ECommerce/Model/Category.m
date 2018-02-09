//
//  Category.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "Category.h"

@implementation Category

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
			@"categoryId": @"Id",
			@"name": @"CatagoryName",
			@"categoryDescription": @"CatagoryDiscription",
			@"image": @"CatagoryImage"
	}];
}

@end
