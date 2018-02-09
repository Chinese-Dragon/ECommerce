//
//  SubCategory.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "SubCategory.h"

@implementation SubCategory

+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{			@"categoryId": @"Id",
			@"name": @"SubCatagoryName",
			@"categoryDescription": @"SubCatagoryDiscription",
			@"image": @"CatagoryImage"
	}];
}

@end
