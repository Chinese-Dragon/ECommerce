//
//  UIViewController+UIVC_Extension.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIVC_Extension)

- (void)showSuccessMessage:(NSString *)message
		 inViewController:(UIViewController *)viewcontroller;

- (void)showErrorMessage:(NSString *)message
	   inViewController:(UIViewController *)viewcontroller;

- (void)showWarningMessage:(NSString *)message
		 inViewController:(UIViewController *)viewcontroller;

- (UIViewController *)contents;
@end
