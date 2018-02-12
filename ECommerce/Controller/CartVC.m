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
#import <PayPalMobile.h>
#import <PayPalConfiguration.h>
#import <PayPalPaymentViewController.h>
#import "APIClient.h"
#import "UIViewController+UIVC_Extension.h"
#import "SVProgressHUD.h"

@interface CartVC () <UITableViewDelegate, UITableViewDataSource, ProductOrderCellDelegate, PayPalPaymentDelegate> {
	NSInteger totalOrderPrice;
	float shippingCost;
	float tax;
}

@property (weak, nonatomic) IBOutlet UILabel *estimateShipping;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@property (strong,nonatomic) NSMutableArray<ProductOrder *> *productOrders;
@property (strong, nonatomic) PayPalConfiguration *paypalConfig;

- (void)setupNotification;
- (void)receiveProductOrderNotification: (NSNotification *)notification;
- (void)setupUI;
- (void)updatePrice;
- (void)updateProductOrderWith: (ProductOrder *)productOrder quantityIncreased:(BOOL)isIncreased;
- (void)finishDeletingForRowAt: (NSIndexPath *)indexPath;
- (void)finishMakingOrders;
- (void)initialSetup;
- (void)configurePaypal;

- (void)enableUIComponenets;
- (void)disenableUIComponenets;
@end

@implementation CartVC

//
- (void)dealloc {
	NSLog(@"Dealloc cartVC");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"CartVC's view is loaded");
	[self initialSetup];
	
	[self setupUI];
	
	// setup addToCartnotification observer
	[self setupNotification];
}

- (void)initialSetup {
	// initial setup
	totalOrderPrice = 0;
	shippingCost = 5.75; // NOTE: Hardcoded
	tax = 0.0;
	self.productOrders = [NSMutableArray array];
	
	[self configurePaypal];
}

- (void)configurePaypal {
	self.paypalConfig = [[PayPalConfiguration alloc] init];
	self.paypalConfig.acceptCreditCards = YES;
	self.paypalConfig.merchantName = @"RJT";
	self.paypalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/useragreement-full"];
	self.paypalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/privacy-full"];
	self.paypalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
	self.paypalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
	
	NSLog(@"Paypal SDK: %@", [PayPalMobile libraryVersion]);
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
	
	// show payment detail if hidden
	if (self.tableview.tableFooterView.isHidden) {
		[self enableUIComponenets];
	}
	
	[self updatePrice];
}

- (void)updatePrice {
	// update subtotal price label
	float newTotal = [[NSNumber numberWithInteger:totalOrderPrice] floatValue];
	self.totalPriceLabel.text = [NSString stringWithFormat:@"$ %.2f", newTotal];
	
	// update tax 7%
	tax = totalOrderPrice * 0.07;
	self.taxLabel.text = [NSString stringWithFormat:@"$ %.2f",tax];
	
	// update shpping cost
	self.estimateShipping.text = [NSString stringWithFormat:@"$ %.2f",shippingCost];
	
	// update total price label
	float orderTotal = (totalOrderPrice * 1.0) + tax + shippingCost;
	self.orderTotalLabel.text = [NSString stringWithFormat:@"$ %.2f",orderTotal];
}

- (void)enableUIComponenets {
	[self.tableview.tableFooterView setHidden:NO];
	
	// enable checkout button
	[self.checkoutButton setEnabled:YES];
	[self.checkoutButton setBackgroundColor:[UIColor barColor]];
	[self.checkoutButton setUserInteractionEnabled:YES];
}

- (void)disenableUIComponenets {
	self.navigationController.tabBarItem.badgeValue = nil;
	// hide payment detail
	[self.tableview.tableFooterView setHidden:YES];
	
	// disable checkout button
	// enable checkout button
	[self.checkoutButton setEnabled:NO];
	[self.checkoutButton setBackgroundColor:[UIColor lightGrayColor]];
	[self.checkoutButton setUserInteractionEnabled:NO];
}

- (IBAction)checkOut:(UIButton *)sender {
	// convert shopping carts to paypal items array
	NSMutableArray<PayPalItem *> *paypalItems = [NSMutableArray array];
	for (ProductOrder *productOrder in self.productOrders) {
		PayPalItem *item = [PayPalItem itemWithName:productOrder.product.name
									   withQuantity:productOrder.orderedQuantity.integerValue
										  withPrice:[NSDecimalNumber decimalNumberWithDecimal:productOrder.orderedTotoalPrice.decimalValue]
									   withCurrency:@"USD"
											withSku:nil];
		[paypalItems addObject:item];
	}
	
	// setup payment detail
	NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:[paypalItems copy]];
	NSDecimalNumber *shipping = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",shippingCost]];
	NSDecimalNumber *taxCost = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",tax]];
	
	PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
																			   withShipping:shipping
																					withTax:taxCost];
	// total cost
	NSDecimalNumber *totalCost = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:taxCost];
	
	// setup payment
	PayPalPayment *payment = [[PayPalPayment alloc] init];
	payment.amount = totalCost;
	payment.currencyCode = @"USD";
	payment.shortDescription = @"My Payment";
	payment.items = paypalItems;
	payment.paymentDetails = paymentDetails;
	
	// HARDCODED
	payment.shippingAddress = [PayPalShippingAddress shippingAddressWithRecipientName:@"Mark" withLine1:@"2056 Wessel Ct" withLine2:nil withCity:@"St Charles" withState:@"IL" withPostalCode:@"60174" withCountryCode:@"+1"];

	if (payment.processable) {
		// setup PaypalPaymanetVC
		PayPalPaymentViewController *paymentVC = [[PayPalPaymentViewController alloc] initWithPayment:payment
																						configuration:self.paypalConfig
																							 delegate:self];
		[self presentViewController:paymentVC animated:YES completion:nil];
	} else {
		NSLog(@"Something went wrong when setting up payment");
	}
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
		[self disenableUIComponenets];
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

- (void)finishMakingOrders {
	// clean up datasouce
	[self.productOrders removeAllObjects];
	
	// clean up central manager productOrder dict
	[AppUserManager.sharedManager.productOrdersDict removeAllObjects];
	
	// reload table
	[self.tableview reloadData];
	
	// disable UI components
	[self disenableUIComponenets];
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

// MARK: - Paypal Delegate Methods
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
	NSLog(@"Payment process is cancelled");
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
	NSLog(@"Payment is finished");
	NSLog(@"Payment info %@", [completedPayment description]);
	
	// [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to your server for verification and fulfillment
	[SVProgressHUD showWithStatus:@"Making orders..."];
	[APIClient.shareInstance makeOrderForProductOrders:self.productOrders completionHandler:^(NSMutableArray<NSString *> *orderIds, NSString *errorMsg) {
		[SVProgressHUD dismiss];
		[self dismissViewControllerAnimated:YES completion:nil];
		
		if (errorMsg == nil) {
			if (orderIds.count == self.productOrders.count) {
				// successuly make order
				[self finishMakingOrders];
				
				//
				[self showSuccessMessage:@"Your Orders Will be on the way soon !" inViewController:self];
				
				// TODO: Nav to order VC
			}
		} else {
			[self showErrorMessage:errorMsg inViewController:self];
			// display error
		}
	}];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController willCompletePayment:(PayPalPayment *)completedPayment completionBlock:(PayPalPaymentDelegateCompletionBlock)completionBlock {
	NSLog(@"Payment is about to finished");
	completionBlock();
}

@end
