//
//  ProductCellDelegate.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCell.h"

@class ProductCell;

@protocol ProductCellDelegate <NSObject>

- (void)didAddToCart: (ProductCell *)cell;

@end
