//
//  ProductCell.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCellDelegate.h"

@interface ProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (weak) id <ProductCellDelegate> delegte; // type is anyobject which will conform to this protocal

+ (NSString *)identifier;

- (void)disable;
- (void)enable;
@end
