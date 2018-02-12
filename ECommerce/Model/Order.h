//
//  Order.h
//  ECommerce
//
//  Created by Mark on 2/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Order : JSONModel
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *itemQuantity;
@property (strong, nonatomic) NSNumber *itemFinalPrice;
@property (strong, nonatomic) NSString *status;
@end
