//
//  SubCategoryVC.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "SubCategoryVC.h"
#import "Category.h"
#import "APIClient.h"
#import <SVProgressHUD.h>
#import "SubCategory.h"
#import "UIViewController+UIVC_Extension.h"
#import "SubCategoryCell.h"
#import <UIImageView+WebCache.h>
#import <CarbonKit.h>
#import "ProductListVC.h"

@interface SubCategoryVC () <UITableViewDelegate, UITableViewDataSource> {
	CarbonSwipeRefresh *refresh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray<SubCategory *> *subCategories;

- (void)fetchSubCategoryList;
- (void)setupUI;

@end

@implementation SubCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
	if (self.currentCategory != nil) {
		[SVProgressHUD show];
		[self fetchSubCategoryList];
	}
}

- (void)setupUI {
	self.tableview.rowHeight = UITableViewAutomaticDimension;
	self.tableview.estimatedRowHeight = 70;
	
	refresh = [[CarbonSwipeRefresh alloc] initWithScrollView:self.tableview];
	[refresh setColors:@[
						 [UIColor blueColor],
						 [UIColor redColor],
						 [UIColor orangeColor],
						 [UIColor greenColor]]
	 ]; // default tintColor
	
	// If your ViewController extends to UIViewController
	// else see below
	[self.view addSubview:refresh];
	
	[refresh addTarget:self action:@selector(fetchSubCategoryList) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchSubCategoryList {
	[APIClient.shareInstance fetchSubcategoryListWithId:self.currentCategory.categoryId completionHandler:^(NSMutableArray<SubCategory *> *categories, NSString *errorMsg) {
		[SVProgressHUD dismiss];
		[refresh endRefreshing];
		
		if (errorMsg == nil) {
			self.subCategories = categories;
			[self.tableview reloadData];
		} else {
			[self showErrorMessage:errorMsg inViewController:self];
		}
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.subCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier: SubCategoryCell.identifier forIndexPath:indexPath];
	
	SubCategory *current = self.subCategories[indexPath.row];
	cell.name.text = current.name;
	cell.des.text = current.categoryDescription;
	[cell.subCateoryImage sd_setImageWithURL:current.image placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductListVC *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductListVC"];
	
	// configure target
	targetVC.subCategory = self.subCategories[indexPath.row];
	
	[self.navigationController pushViewController:targetVC animated:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
