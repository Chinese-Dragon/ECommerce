//
//  ProductOrderCell.m
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ProductOrderCell.h"
#import "PKYStepper.h"

@interface ProductOrderCell()

@property (weak, nonatomic) IBOutlet UIView *ProdctOrderCellShadow;
@property (weak, nonatomic) IBOutlet UIView *ProductOrderView;

@end

@implementation ProductOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
	// setup shadow and radius
	// Initialization code
	self.ProductOrderView.layer.cornerRadius = 10.0;
	self.ProductOrderView.clipsToBounds = YES;
	self.ProductOrderView.layer.masksToBounds = YES;
	
	// configure shadowView
	self.ProdctOrderCellShadow.layer.cornerRadius = 10.0;
	self.ProdctOrderCellShadow.layer.shadowColor = [UIColor.grayColor CGColor];
	self.ProdctOrderCellShadow.layer.shadowOffset = CGSizeMake(1.0, 1.0);
	self.ProdctOrderCellShadow.layer.shadowRadius = 10.0;
	self.ProdctOrderCellShadow.layer.shadowOpacity = 0.2;
	
	// setup stepper UI
	[self.changeQuantityStepper setHidesDecrementWhenMinimum:YES];
	[self.changeQuantityStepper setHidesIncrementWhenMaximum:YES];
	[self.changeQuantityStepper setMinimum:1.0];
	
	// setup stepper callback
	self.changeQuantityStepper.incrementCallback = ^(PKYStepper *stepper, float newValue) {
		stepper.countLabel.text = [[NSNumber numberWithFloat:newValue] stringValue];
		[self.delegate didIncreaseProductOrderQuantityForCell:self withNewValue:newValue];
	};
	self.changeQuantityStepper.decrementCallback = ^(PKYStepper *stepper, float newValue) {
		stepper.countLabel.text = [[NSNumber numberWithFloat:newValue] stringValue];
		[self.delegate didDecreaseProductOrderQuantityForCell:self withNewValue:newValue];
	};
	
	[self.changeQuantityStepper setup];
}


- (void)stepperIncrease: (PKYStepper *)stepper newValue:(float)value {
	
}

- (void)stepperDecrease: (PKYStepper *)stepper newValue:(float)value {
	
}
- (IBAction)deleteProduct:(UIButton *)sender {
	[self.delegate didDeleteProductOrderForCell:self];
}

+ (NSString *)identifier {
	return @"ProductOrderCell";
}
@end
