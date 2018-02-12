//
//  OrderCell.h
//  ECommerce
//
//  Created by Mark on 2/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderQuantity;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

+ (NSString *)indentifier;
@end
