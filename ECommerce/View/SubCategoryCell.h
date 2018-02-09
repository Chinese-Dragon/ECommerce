//
//  CategoryCell.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIImageView *subCateoryImage;

+ (NSString *)identifier;

@end
