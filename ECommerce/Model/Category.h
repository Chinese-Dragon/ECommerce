//
//  Category.h
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Category : JSONModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString <Optional> *categoryDescription;
@property (nonatomic) NSURL <Optional> *image;

@end
