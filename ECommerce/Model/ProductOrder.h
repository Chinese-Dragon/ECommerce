//
//  ProductOrder.h
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;

@interface ProductOrder : NSObject

@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) NSNumber* orderedQuantity;
@property (strong, nonatomic) NSNumber* orderedTotoalPrice;

-(id)initWithProduct: (Product *)product
	 orderedQuantity:(NSNumber *)quantity
   orderedTotalPrice:(NSNumber *)price;

@end
