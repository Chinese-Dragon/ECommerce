//
//  Order.m
//  ECommerce
//
//  Created by Mark on 2/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (JSONKeyMapper*)keyMapper {
	NSDictionary *mapping = @{@"orderID": @"OrderID",
							  @"itemName": @"ItemName",
							  @"itemQuantity": @"ItemQuantity",
							  @"itemFinalPrice": @"FinalPrice",
							  @"status": @"OrderStatus"
							  };
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
