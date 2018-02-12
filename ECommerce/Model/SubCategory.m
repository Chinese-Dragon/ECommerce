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
	NSDictionary *mapping = @{@"categoryId": @"Id",
							  @"name": @"SubCatagoryName",
							  @"categoryDescription": @"SubCatagoryDiscription",
							  @"image": @"CatagoryImage"
							  };
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
