//
//  ProductListVC.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ProductListVC.h"
#import "SubCategory.h"
#import "APIClient.h"
#import <SVProgressHUD.h>
#import "Product.h"
#import "ProductCell.h"
#import <UIImageView+WebCache.h>
#import "UIViewController+UIVC_Extension.h"
@interface ProductListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray<Product*> *products;
- (void)getProductList;
- (void)setupUI;
@end

@implementation ProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.products = [NSMutableArray array];
	
	[self setupUI];
	if (self.subCategory != nil) {
		self.navigationItem.title = self.subCategory.name;
		[self getProductList];
	}
}

- (void)setupUI {
	self.tableview.rowHeight = UITableViewAutomaticDimension;
	self.tableview.estimatedRowHeight = 350;
}

- (void)getProductList {
	[SVProgressHUD showWithStatus:@"Fetching..."];
	[APIClient.shareInstance fetchProductListWithSubcategoryId:self.subCategory.categoryId completionHandler:^(NSMutableArray<Product *> *productList, NSString *error) {
		[SVProgressHUD dismiss];
		if (error != nil) {
			[self showErrorMessage:error inViewController:self];
		} else {
			// success
			self.products = productList;
			[self.tableview reloadData];
		}
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCell.identifier forIndexPath:indexPath];
	
	Product *currentProduct = self.products[indexPath.row];
	[cell.productImage sd_setImageWithURL:currentProduct.productImage placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
	cell.productDescription.text = currentProduct.productDescription;
	cell.productName.text = currentProduct.name;
	cell.quantity.text = [currentProduct.quantity stringValue];
	cell.productPrice.text = [currentProduct.price stringValue];
	
	return cell;
}

@end



