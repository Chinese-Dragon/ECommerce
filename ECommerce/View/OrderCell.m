//
//  OrderCell.m
//  ECommerce
//
//  Created by Mark on 2/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "OrderCell.h"
@interface OrderCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *orderView;

@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
	// setup shadow and radius
	// Initialization code
	self.orderView.layer.cornerRadius = 10.0;
	self.orderView.clipsToBounds = YES;
	self.orderView.layer.masksToBounds = YES;
	
	// configure shadowView
	self.shadowView.layer.cornerRadius = 10.0;
	self.shadowView.layer.shadowColor = [UIColor.grayColor CGColor];
	self.shadowView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	self.shadowView.layer.shadowRadius = 10.0;
	self.shadowView.layer.shadowOpacity = 0.2;
}

+ (NSString *)indentifier {
	return @"OrderCell";
}

@end
