//
//  CategoryVC.m
//  ECommerce
//
//  Created by Mark on 2/8/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "CategoryVC.h"
#import "Category.h"
#import "APIClient.h"
#import <SDWEbImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "UIViewController+UIVC_Extension.h"
#import "CarbonKit.h"
#import "SubCategoryVC.h"
#import "UIColor+Style.h"

@interface CategoryVC () <CarbonTabSwipeNavigationDelegate> {
	CarbonTabSwipeNavigation *swipeNav;
	UIColor *color;
}

@property (nonatomic, strong) NSMutableArray<Category *> *categories;
@property (nonatomic, strong) NSArray *swpeNavItems;
- (void)fetchCategoryList;
- (void)setupSwipeNavigation;
- (void)style;
- (void)setupUI;
@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"CategoryVC's view is loaded");
	[self setupUI];
	
	self.categories = [NSMutableArray array];
	
	// fetch data
	[self fetchCategoryList];
}

- (void)setupUI {
	color = [UIColor barColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.barTintColor = color;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)fetchCategoryList {
	[SVProgressHUD show];
	[APIClient.shareInstance
	 fetchCategoryListWithCompletionHandler:^(NSMutableArray<Category *>
											  *categories, NSString *error) {
		 [SVProgressHUD dismiss];
		 if (error!= nil) {
			 [self showErrorMessage:error inViewController:self];
		 } else {
			 self.categories = categories;
			 [self setupSwipeNavigation];
		 }
	}];
}

- (void)setupSwipeNavigation {
	NSMutableArray *items = [NSMutableArray array];
	for (Category *category in self.categories) {
		[items addObject:category.name];
	}
	self.swpeNavItems = (NSArray *)[items copy];
	swipeNav = [[CarbonTabSwipeNavigation alloc] initWithItems:self.swpeNavItems delegate:self];
	[swipeNav insertIntoRootViewController:self];
	
	// style
	[self style];
}

- (void)style {
	swipeNav.toolbar.translucent = NO;
	[swipeNav setIndicatorColor:color];
	[swipeNav setTabExtraWidth:30];
	
	// Custimize segmented control
	[swipeNav setNormalColor:[color colorWithAlphaComponent:0.6]
										font:[UIFont boldSystemFontOfSize:14]];
	[swipeNav setSelectedColor:color font:[UIFont boldSystemFontOfSize:14]];
}

// delegate
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
						 viewControllerAtIndex:(NSUInteger)index {
	if (self.categories.count == 0) {
		return nil;
	} else {
		Category *current = self.categories[index];
		
		// initialize a new subCategory VC
		SubCategoryVC *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoryVC"];
		
		// setup data
		targetVC.currentCategory = current;
		
		// return
		return targetVC;
	}
}

- (void)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation willMoveAtIndex:(NSUInteger)index {
	self.navigationItem.title = self.swpeNavItems[index];
}

@end

