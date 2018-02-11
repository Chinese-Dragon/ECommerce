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
#import "SVProgressHUD.h"
#import "Product.h"
#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+UIVC_Extension.h"
#import "AppUserManager.h"
#import "ProductOrder.h"
#import "Constants.h"
#import "AppUserManager.h"

@interface ProductListVC () <UITableViewDelegate, UITableViewDataSource, ProductCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray<Product*> *products;
- (void)getProductList;
- (void)setupUI;
- (void)configureProductsState;
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// reloadData to update the status of addedToCart items
	[self configureProductsState];
	[self.tableview reloadData];
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
			[self configureProductsState];
			[self.tableview reloadData];
		}
	}];
}
// MARK: - mark product is "added" if it is currently in the productOrderLists of AppUserManager
- (void)configureProductsState {
	NSMutableDictionary *productOrdersDict = AppUserManager.sharedManager.productOrdersDict;
	for (Product *product in self.products) {
		if ([productOrdersDict objectForKey:product.productId] != nil) {
			product.isAdded = YES;
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCell.identifier forIndexPath:indexPath];
	
	Product *currentProduct = self.products[indexPath.row];
	
	if (currentProduct.isAdded) {
		[cell disable];
	} else {
		[cell enable];
	}
	
	// configure cell
	[cell.productImage sd_setImageWithURL:currentProduct.productImage placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
	cell.productDescription.text = currentProduct.productDescription;
	cell.productName.text = currentProduct.name;
	cell.quantity.text = [currentProduct.quantity stringValue];
	cell.productPrice.text = [currentProduct.price stringValue];
	
	cell.delegte = self;
	
	return cell;
}

-(void)didAddToCart:(ProductCell *)cell {
	// find indexPath
	NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
	
	// get corresponding product
	Product *currentproduct = self.products[indexPath.row];
	
	// NOTE: Testing purpose
	NSLog(@"%@", currentproduct.name);
	
	// change state of product
	currentproduct.isAdded = YES;

	// construct a productOrder and add to AppUser Singleton
	ProductOrder *newProductOrder = [[ProductOrder alloc] initWithProduct:currentproduct orderedQuantity:[NSNumber numberWithInt:1] orderedTotalPrice:currentproduct.price];

	[AppUserManager.sharedManager.productOrdersDict setObject:newProductOrder forKey:currentproduct.productId];

	// Send addtoCart notification with product Id
	NSDictionary *payload = [NSDictionary dictionaryWithObject:currentproduct.productId forKey:addToCartPayloadKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:addToCartNotification object:nil userInfo:payload];
	
	// refresh current cell
	[self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end



