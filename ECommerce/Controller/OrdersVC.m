//
//  OrdersVC.m
//  ECommerce
//
//  Created by Mark on 2/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "OrdersVC.h"
#import "UIColor+Style.h"
#import "APIClient.h"
#import "Constants.h"
#import "Order.h"
#import "OrderCell.h"
#import "UIViewController+UIVC_Extension.h"
#import "SVProgressHUD.h"

@interface OrdersVC () <UITableViewDelegate, UITableViewDataSource> {
	NSDictionary *orderStatusDict;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray<Order *> *orders;
- (void)setupUI;
- (void)fetchOrders;

@end

@implementation OrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.orders = [NSMutableArray array];
	orderStatusDict = @{@"1": @"Order Confirm",
						@"2": @"Order Dispatch",
						@"3": @"Order On the Way",
						@"4": @"Order Delivered"
						};
	[self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self fetchOrders];
}

- (void)setupUI {
	self.tableview.rowHeight = UITableViewAutomaticDimension;
	self.tableview.estimatedRowHeight = 160;
	
	UIColor *color = [UIColor barColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.barTintColor = color;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)fetchOrders {
	[SVProgressHUD showWithStatus:@"Fetching Orders..."];
	[APIClient.shareInstance fetchOrderHistory:^(NSMutableArray<Order *> *newOrders, NSString *errorMsg) {
		[SVProgressHUD dismiss];
		
		if (errorMsg == nil) {
			self.orders = newOrders;
			[self.tableview reloadData];
		} else {
			[self showErrorMessage:errorMsg inViewController:self];
		}
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCell.indentifier forIndexPath:indexPath];

	// configure cell
	Order *currentOrder = self.orders[indexPath.row];
	cell.orderId.text = currentOrder.orderID;
	if ([currentOrder.itemQuantity integerValue] > 1) {
		cell.orderQuantity.text = [NSString stringWithFormat:@"%@ Items", currentOrder.itemQuantity.stringValue];
	} else {
		cell.orderQuantity.text = [NSString stringWithFormat:@"%@ Item", currentOrder.itemQuantity.stringValue];
	}
	cell.productName.text = currentOrder.itemName;
	cell.orderStatus.text = [orderStatusDict valueForKey:currentOrder.status];
	
	return cell;
}

@end
