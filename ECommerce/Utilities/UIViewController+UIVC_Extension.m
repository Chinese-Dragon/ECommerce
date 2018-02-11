//
//  UIViewController+UIVC_Extension.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "UIViewController+UIVC_Extension.h"
#import "RMessage.h"
#import "RMessageView.h"

@implementation UIViewController (UIVC_Extension)

- (UIViewController *)contents {
	if ([self isKindOfClass:[UINavigationController class]]) {
		
		return ((UINavigationController *)self).visibleViewController;
	} else {
		return self;
	}
}

- (void)showErrorMessage:(NSString *)message
		inViewController:(UIViewController *)viewcontroller {

	[RMessage showNotificationInViewController:viewcontroller
										 title:(@"Some went wrong")
									  subtitle:message type:RMessageTypeError customTypeName:nil
									  duration:2.0
									  callback:nil];
}

- (void)showSuccessMessage:(NSString *)message
  inViewController:(UIViewController *)viewcontroller {
	
	[RMessage showNotificationInViewController:viewcontroller
										 title:@"Success"
									  subtitle:message
										  type:RMessageTypeSuccess
								customTypeName:nil
									  duration:2.0
									  callback:nil];
}

- (void)showWarningMessage:(NSString *)message
  inViewController:(UIViewController *)viewcontroller{
	
	[RMessage showNotificationInViewController:viewcontroller
										 title:@"Attention"
									  subtitle:message
										  type:RMessageTypeWarning
								customTypeName:nil
									  duration:2.0 callback:nil];
}

@end
