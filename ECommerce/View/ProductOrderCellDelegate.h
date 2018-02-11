//
//  ProductOrderCellDelegate.h
//  ECommerce
//
//  Created by Mark on 2/10/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductOrderCell.h"

@class ProductOrderCell;

@protocol ProductOrderCellDelegate <NSObject>

- (void)didDeleteProductOrderForCell: (ProductOrderCell *)cell;

- (void)didIncreaseProductOrderQuantityForCell: (ProductOrderCell *)cell
							 withNewValue: (float) newValue;

- (void)didDecreaseProductOrderQuantityForCell: (ProductOrderCell *)cell
								  withNewValue: (float) newValue;
@end
