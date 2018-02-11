//
//  ProductOrder.m
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ProductOrder.h"
#import "Product.h"

@implementation ProductOrder

-(id)initWithProduct: (Product *)product
	 orderedQuantity:(NSNumber *)quantity
   orderedTotalPrice:(NSNumber *)price {
	
	self = [super init];
	if(self) {
		_product = product;
		_orderedQuantity = quantity;
		_orderedTotoalPrice = price;
	}
	return self;
}

@end
