//
//  ProductCell.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ProductCell.h"
#import "UIColor+Style.h"

@interface ProductCell()

@property (weak, nonatomic) IBOutlet UIView *productShadowView;
@property (weak, nonatomic) IBOutlet UIView *productView;

@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarSignLabel;

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
	
	// customize button
	self.addToCartButton.layer.cornerRadius = 10.0;
	self.addToCartButton.clipsToBounds = YES;
}

+ (NSString *)identifier {
	return @"ProductCell";
}

- (void)disable {
	[self setUserInteractionEnabled:NO];
	[self.addToCartButton setEnabled:NO];
	[self.addToCartButton setBackgroundColor:[UIColor grayColor]];
	[self.quantityLabel setEnabled:NO];
	[self.dollarSignLabel setEnabled:NO];
	[self.productImage setUserInteractionEnabled:NO];
	[self.productName setEnabled:NO];
	[self.productDescription setEnabled:NO];
	[self.quantity setEnabled:NO];
	[self.productPrice setEnabled:NO];
}

- (void)enable {
	[self setUserInteractionEnabled:YES];
	[self.addToCartButton setEnabled:YES];
	[self.addToCartButton setBackgroundColor:[UIColor barColor]];
	[self.quantityLabel setEnabled:YES];
	[self.dollarSignLabel setEnabled:YES];
	[self.productImage setUserInteractionEnabled:YES];
	[self.productName setEnabled:YES];
	[self.productDescription setEnabled:YES];
	[self.quantity setEnabled:YES];
	[self.productPrice setEnabled:YES];
}

- (IBAction)addToCart:(UIButton *)sender {
	[self.delegte didAddToCart:self];
}

@end
