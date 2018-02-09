//
//  Product.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface Product : JSONModel

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger *quantity;
@property (nonatomic) NSInteger *price;
@property (nonatomic) NSString *productDescription;
@property (nonatomic) NSURL *productImage;
@end
