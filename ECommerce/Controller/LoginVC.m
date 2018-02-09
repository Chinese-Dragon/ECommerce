//
//  ViewController.m
//  ECommerce
//
//  Created by Mark on 2/6/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "LoginVC.h"
#import "NSString+NSString_Extension.h"
#import "UIViewController+UIVC_Extension.h"
#import <SVProgressHUD.h>
#import "APIClient.h"
#import "AppUserManager.h"


@interface LoginVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@end

@implementation LoginVC

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (IBAction)forgetPassword:(UIButton *)sender {
	
}

- (IBAction)loginAction:(UIButton *)sender {
	[self login];
}

- (void)login {
	// regin first responseder
	[self.view endEditing:YES];
	
	if ([self validateInputs]) {
		// TODO: call login API
		NSLog(@"Read to call network service");
		
		[SVProgressHUD showWithStatus:@"Signing In"];
		[APIClient.shareInstance
		 loginWithPhone:self.phone
		 password:self.password
		 completionHandler:^(NSDictionary *jsonDict, NSString *errorMsg) {
			 [SVProgressHUD dismiss];
			 if (errorMsg == nil) {
				 NSLog(@"%@", jsonDict);
				 [[AppUserManager sharedManager] saveUserData:jsonDict];
				 
				 // present to main page
				 UIViewController *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabBarVC"];
				 [self presentViewController:targetVC animated:YES completion:nil];
				 [self showSuccessMessage:@"Successfully Loggedin" inViewController:targetVC];
			 } else {
				 [self showErrorMessage:errorMsg inViewController:self];
				 NSLog(@"%@", errorMsg);
			 }
		 }];
	}
}

- (BOOL)validateInputs {
	self.phone = self.phoneTextfield.text.stringByStrippingWhitespace;
	self.password = self.passwordTextfield.text.stringByStrippingWhitespace;
	
	if (self.phone.isBlank) {
		[self showWarningMessage:@"Phone number cannot be empty"
				inViewController:self];
		
		return NO;
	}
	
	if (self.password.isBlank) {
		[self showWarningMessage:@"Password cannot be empty"
				inViewController:self];
		
		return NO;
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// use equal to see if they are the same in address
	if (textField == self.phoneTextfield) {
		[self.passwordTextfield becomeFirstResponder];
	} else if (textField == self.passwordTextfield) {
		[self login];
	}
	
	return YES;
}

@end