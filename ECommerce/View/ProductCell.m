//
//  ProductCell.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell()

@property (weak, nonatomic) IBOutlet UIView *productShadowView;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@end

@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.productView.layer.cornerRadius = 10.0;
	self.productView.clipsToBounds = YES;
	self.productView.layer.masksToBounds = YES;
	
	// configure shadowView
	self.productShadowView.layer.cornerRadius = 10.0;
	self.productShadowView.layer.shadowColor = [UIColor.grayColor CGColor];
	self.productShadowView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	self.productShadowView.layer.shadowRadius = 10.0;
	self.productShadowView.layer.shadowOpacity = 0.2;
}

+ (NSString *)identifier {
	return @"ProductCell";
}

- (IBAction)addToCart:(UIButton *)sender {
	[self.delegte didAddToCart:self];
}

@end
