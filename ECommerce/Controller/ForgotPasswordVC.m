//
//  ForgotPasswordVC.m
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "UIViewController+UIVC_Extension.h"
#import "NSString+NSString_Extension.h"
#import "APIClient.h"
#import "ResetPasswordVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface ForgotPasswordVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneNumber;
@property (strong, nonatomic) NSString *phone;

- (void)forgotPasswordService;
@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)dismiss:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)forgotPasswordService {
	self.phone = [self.phoneNumber.text stringByStrippingWhitespace];
	if (![self.phone isBlank]) {
		[SVProgressHUD show];
		
		// make forgot password call
		[APIClient.shareInstance forgotPasswordWithPhone:self.phone completonHandler:^(NSString *oldPassword, NSString *errorMsg) {
			[SVProgressHUD dismiss];
			
			if (errorMsg != nil) {
				[self showWarningMessage:errorMsg inViewController:self];
			} else {
				// find targetVC
				ResetPasswordVC *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
				
				// configure
				targetVC.phoneNumber = self.phone;
				targetVC.oldPassword = oldPassword;
				
				// nav
				[self.navigationController pushViewController:targetVC animated:YES];
			}
		}];
	} else {
		[self showWarningMessage:@"Phone Number can not be empty" inViewController:self];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self forgotPasswordService];
	return YES;
}

@end
