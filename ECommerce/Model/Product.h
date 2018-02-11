//
//  Product.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Product : JSONModel

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *quantity;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString <Optional> *productDescription;
@property (nonatomic) NSURL <Optional> *productImage;

@property (nonatomic) BOOL isAdded;
@end
