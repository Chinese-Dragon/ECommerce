//
//  SignupVC.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "SignupVC.h"
#import "NSString+NSString_Extension.h"
#import "UIViewController+UIVC_Extension.h"
#import "APIClient.h"
#import "SVProgressHUD.h"
#import "AppUserManager.h"


@interface SignupVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextfield;

@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *confirmPassword;

- (BOOL)validateInputs;
@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
}

// validate input on client side	need a better way
- (BOOL)validateInputs {
	self.phoneNumber = self.phoneTextField.text.stringByStrippingWhitespace;
	self.email = self.emailTextField.text.stringByStrippingWhitespace;
	self.username = self.usernameTextField.text.stringByStrippingWhitespace;
	self.password = self.passwordTextField.text.stringByStrippingWhitespace;
	self.confirmPassword = self.confirmPasswordTextfield.text.stringByStrippingWhitespace;
	
	if (self.phoneNumber.isBlank) {
		[self showWarningMessage:@"Phone Number cannot be empty"
				inViewController:self];
		return NO;
	}
	
	if (self.email.isBlank) {
		[self showWarningMessage:@"Email cannot be empty"
				inViewController:self];
		return NO;
	}
	
	if (self.username.isBlank) {
		[self showWarningMessage:@"Username cannot be empty"
				inViewController:self];
		return NO;
	}
	
	if (self.password.isBlank || self.confirmPassword.isBlank) {
		[self showWarningMessage:@"Password cannot be empty"
				inViewController:self];
		return NO;
	}
	
	// check password equal not using == which only check for address
	if (![self.password isEqualToString:self.confirmPassword]) {
		[self showWarningMessage:@"Passwords does not match"
				inViewController:self];
		return NO;
	}
	
	return YES;
}

- (void)setupUI {
	self.signupButton.layer.cornerRadius = 5.0;
	self.signupButton.clipsToBounds = YES;
}

- (IBAction)backToRoot:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)signupAction:(UIButton *)sender {
	[self signup];
}

- (void)signup {
	// resign keyboard
	[self.view endEditing:YES];
	
	if ([self validateInputs]) {
		NSLog(@"ready to call signup service");
		
		[SVProgressHUD showWithStatus:@"Signing Up"];
		// try to call signup service
		[APIClient.shareInstance
		 signupWithName:self.username
		 email:self.email
		 phone:self.phoneNumber
		 password:self.password
		 completionHandler:^(NSString *errorMsg) {
			
			[SVProgressHUD dismiss];
			if (errorMsg == nil) {
				// request login
				[SVProgressHUD showWithStatus:@"Signing In"];
				[APIClient.shareInstance
				 loginWithPhone:self.phoneNumber
				 password:self.password
				 completionHandler:^(NSDictionary *jsonDict, NSString *errorMsg) {
					 [SVProgressHUD dismiss];
					 if (errorMsg == nil) {
						 NSLog(@"%@", jsonDict);
						 // save current user data to singleton
						 [[AppUserManager sharedManager] saveUserData:jsonDict];
						 
						 UIViewController *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeTabBarVC"];
						
						 [self presentViewController:targetVC animated:YES completion:nil];
						 
						 [self showSuccessMessage:@"Successfully Loggedin"
								 inViewController:targetVC];
					 } else {
						 [self showErrorMessage:errorMsg
							   inViewController:self];
						 NSLog(@"%@", errorMsg);
					 }
				 }];
			} else {
				[self showErrorMessage:errorMsg
					  inViewController:self];
				NSLog(@"%@", errorMsg);
			}
		}];
		// get response, handle show error if anything goes wrong
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.phoneTextField) {
		[self.phoneTextField becomeFirstResponder];
	} else if (textField == self.emailTextField) {
		[self.usernameTextField becomeFirstResponder];
	} else if (textField == self.usernameTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else if (textField == self.passwordTextField) {
		[self.confirmPasswordTextfield becomeFirstResponder];
	} else if (textField == self.confirmPasswordTextfield) {
		[self signup];
	}
	
	return YES;
}

@end
