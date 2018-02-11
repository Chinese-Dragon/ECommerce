//
//  CartVC.m
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "CartVC.h"
#import "ProductOrder.h"
#import "ProductOrderCell.h"
#import "Constants.h"
#import "AppUserManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Product.h"
#import <PKYStepper/PKYStepper.h>
#import "UIColor+Style.h"

@interface CartVC () <UITableViewDelegate, UITableViewDataSource, ProductOrderCellDelegate> {
	NSInteger totalOrderPrice;
}
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSMutableArray<ProductOrder *> *productOrders;

- (void)setupNotification;
- (void)receiveProductOrderNotification: (NSNotification *)notification;
- (void)setupUI;
- (void)updatePrice;
- (void)updateProductOrderWith: (ProductOrder *)productOrder quantityIncreased:(BOOL)isIncreased;
- (void)finishDeletingForRowAt: (NSIndexPath *)indexPath;
@end

@implementation CartVC

//
- (void)dealloc {
	NSLog(@"Dealloc cartVC");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	totalOrderPrice = 0;
	NSLog(@"CartVC's view is loaded");
	
	self.productOrders = [NSMutableArray array];
	[self setupUI];
	
	// setup addToCartnotification observer
	[self setupNotification];
}

- (void)setupUI {
	self.tableview.rowHeight = UITableViewAutomaticDimension;
	self.tableview.estimatedRowHeight = 150;
	
	UIColor *color = [UIColor barColor];
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.barTintColor = color;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

// Add this instance of CartVC as an observer of the TestNotification.
// We tell the notification center to inform us of "AddToCartNotification"
// notifications using the receiveTestNotification: selector. By
// specifying object:nil, we tell the notification center that we are not
// interested in who posted the notification. If you provided an actual
// object rather than nil, the notification center will only notify you
// when the notification was posted by that particular object.
- (void)setupNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveProductOrderNotification:) name:addToCartNotification object:nil];
}

- (void)receiveProductOrderNotification: (NSNotification *)notification {
	NSLog(@"%@", [notification description]);
	
	if ([notification.name isEqualToString:addToCartNotification]) {
		// get the payload, product Id
		NSDictionary *payload = notification.userInfo;
		NSString *productId = (NSString *)[payload valueForKey:addToCartPayloadKey];
		
		//used it as key to find corresponding new productOrder from the productOrder array in AppUser singleton
		ProductOrder *newProductOrder =  [AppUserManager.sharedManager.productOrdersDict valueForKey:productId];
		
		// add to current productOrders
		[self.productOrders addObject:newProductOrder];
		
		// update totalPrice property
		totalOrderPrice += [newProductOrder.orderedTotoalPrice integerValue];
		
		// update ui
		[self finishReceivingNotifiation];
	}
}

- (void)finishReceivingNotifiation {
	// find latestAddeditem indexPapth
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.productOrders.count - 1 inSection:0];
	
	// reload tableview new row
	[self.tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	// increase badge number
	self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat: @"%ld", (long)self.productOrders.count];
	
	[self updatePrice];
}

- (void)updatePrice {
	// update total price label
	NSString *newTotalStr = [[NSNumber numberWithInteger:totalOrderPrice] stringValue];
	self.totalPriceLabel.text = [NSString stringWithFormat:@"$ %@", newTotalStr];
}

- (IBAction)checkOut:(UIButton *)sender {
	// TODO: Check out
}

- (void)updateProductOrderWith:(ProductOrder *)productOrder quantityIncreased:(BOOL)isIncreased {
	NSInteger singleItemPrice = [productOrder.product.price integerValue];
	NSInteger newQuantity;
	
	if (isIncreased) {
		// add one more item price to the total
		totalOrderPrice += singleItemPrice;
		newQuantity = [productOrder.orderedQuantity integerValue] + 1;
		
	} else {
		totalOrderPrice -= singleItemPrice;
		newQuantity = [productOrder.orderedQuantity integerValue] - 1;
	}
	
	// change productOrder quantity
	productOrder.orderedQuantity = [NSNumber numberWithInteger:newQuantity];
	NSLog(@"New ProductOrder Quantity %@", [productOrder.orderedQuantity stringValue]);
	
	// change productOrder price
	productOrder.orderedTotoalPrice = [NSNumber numberWithInteger:(newQuantity * singleItemPrice)];
	NSLog(@"New ProductOrder Total Price %@", [productOrder.orderedTotoalPrice stringValue]);
	
	// update total price label + individual price
	[self updatePrice];
}

- (void)finishDeletingForRowAt:(NSIndexPath *)indexPath {
	// reload tableview at path
	// show animation since user in on this screen
	[self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	
	// decrease badge number
	if (self.productOrders.count != 0) {
		self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat: @"%ld", (long)self.productOrders.count];
	} else {
		self.navigationController.tabBarItem.badgeValue = nil;
	}
	
	// update price
	[self updatePrice];
	
	
	// NOTE: FOR TESTING
	// check central
	// check totalprice property
	// check datasource array
	NSLog(@"Number of ProductOrder in Central Manager %ld", (long)AppUserManager.sharedManager.productOrdersDict.count);
	NSLog(@"Number of items in datasource %ld", (long)self.productOrders.count);
	NSLog(@"Total Price %ld", (long)totalOrderPrice);
}

// MARK: - Tableview delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.productOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductOrderCell *cell = [tableView dequeueReusableCellWithIdentifier: ProductOrderCell.identifier forIndexPath:indexPath];
	
	ProductOrder *currentProductOrder = self.productOrders[indexPath.row];
	Product *currentProduct = currentProductOrder.product;
	
	// configure cell
	cell.delegate = self;
	[cell.productImage sd_setImageWithURL: currentProduct.productImage
						 placeholderImage:[UIImage imageNamed:@"image_place_holder"]];
	cell.productName.text = currentProduct.name;
	cell.productTotalQuantity.text = [currentProduct.quantity stringValue];
	cell.productPrice.text = [currentProduct.price stringValue];
	cell.productDescription.text = currentProduct.productDescription;
	
	// confugrue cell stepper
	[cell.changeQuantityStepper setValue:currentProductOrder.orderedQuantity.floatValue];
	[cell.changeQuantityStepper setMaximum: currentProduct.quantity.floatValue];
	cell.changeQuantityStepper.countLabel.text = [currentProductOrder.orderedQuantity stringValue];
	
	return cell;
}

// MARK: - productOrder Cell delegate
- (void)didDeleteProductOrderForCell:(ProductOrderCell *)cell {
	NSLog(@"didDeleteProduct");
	// find indexpath
	NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
	
	// find productOrder
	ProductOrder *productOrder = self.productOrders[indexPath.row];
	
	// delete from data source
	[self.productOrders removeObjectAtIndex:indexPath.row];
	
	// delete from central APPUserManger dictionary
	[AppUserManager.sharedManager.productOrdersDict removeObjectForKey:productOrder.product.productId];
	
	// update totalprice property
	totalOrderPrice -= [productOrder.orderedTotoalPrice integerValue];
	
	// update UI
	[self finishDeletingForRowAt:indexPath];
}

- (void)didIncreaseProductOrderQuantityForCell:(ProductOrderCell *)cell withNewValue:(float)newValue {
	NSLog(@"%.2f",newValue);
	// find the product
	NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
	ProductOrder *productOrder = self.productOrders[indexPath.row];
	
	[self updateProductOrderWith:productOrder quantityIncreased:YES];
}

- (void)didDecreaseProductOrderQuantityForCell:(ProductOrderCell *)cell withNewValue:(float)newValue {
	NSLog(@"%.2f",newValue);
	// find the product
	NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
	ProductOrder *productOrder = self.productOrders[indexPath.row];
	
	[self updateProductOrderWith:productOrder quantityIncreased:NO];
}

@end
