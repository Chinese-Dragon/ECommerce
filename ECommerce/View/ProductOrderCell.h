//
//  ProductOrderCell.h
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductOrderCellDelegate.h"

@class PKYStepper;
@interface ProductOrderCell : UITableViewCell

@property (weak) id <ProductOrderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productTotalQuantity;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;

@property (weak, nonatomic) IBOutlet PKYStepper *changeQuantityStepper;

+ (NSString *)identifier;
@end
