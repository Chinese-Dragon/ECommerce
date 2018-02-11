//
//  ResetPasswordVC.m
//  ECommerce
//
//  Created by Mark on 2/9/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "ResetPasswordVC.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "UIViewController+UIVC_Extension.h"
#import "NSString+NSString_Extension.h"
#import "APIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ResetPasswordVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PasswordTextField;
@property (strong, nonatomic) NSString *passwordNew;
-(void)resetPassword;
@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)dismiss:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetPassword {
	self.passwordNew = [self.PasswordTextField.text stringByStrippingWhitespace];
	if ([self.passwordNew isBlank]) {
		[self showWarningMessage:@"New Password Cannot be empty" inViewController:self];
	} else {
		// call service
		[APIClient.shareInstance resetPasswordWithPhone:self.phoneNumber oldPassword:self.oldPassword newPassword:self.passwordNew completionHandler:^(NSString *errorMsg) {
			if (errorMsg == nil) {
				[self dismissViewControllerAnimated:YES completion:nil];
			} else {
				[self showErrorMessage:errorMsg inViewController:self];
			}
		}];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self resetPassword];
	return YES;
}
@end
