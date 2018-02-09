//
//  CategoryCell.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "SubCategoryCell.h"

@interface SubCategoryCell()

@end

@implementation SubCategoryCell

+ (NSString *)identifier {
	return @"SubCategoryCell";
}

- (void)awakeFromNib {
	[super awakeFromNib];
	// customized
	_subCateoryImage.layer.cornerRadius = _subCateoryImage.frame.size.width / 2;
	_subCateoryImage.layer.masksToBounds = YES;
	_subCateoryImage.clipsToBounds = YES;
}

@end
