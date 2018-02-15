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
#import "SVProgressHUD.h"
#import "APIClient.h"
#import "AppUserManager.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginVC () <UITextFieldDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@end

@implementation LoginVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.fbLoginButton.delegate = self;
	self.fbLoginButton.readPermissions = @[@"public_profile"];
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

- (void)requestFBUserData {
	if ([FBSDKAccessToken currentAccessToken] != nil) {
		[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
		 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
			 if (!error) {
				 NSLog(@"fetched user:%@", result);
				 // get user id and name
				 
				 // make API call for web service
				 
				 
			 }
		 }];
	}
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
	if (error == nil) {
		// request user data
		[self requestFBUserData];
	} else {
		[self showErrorMessage:error.localizedDescription inViewController:self];
	}
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
	NSLog(@"Logged Out");
}

@end
