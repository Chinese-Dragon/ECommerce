//
//  AccountVC.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "AccountVC.h"
#import "AppUserManager.h"
#import "UIColor+Style.h"

@interface AccountVC ()

- (void)destroyToRoot;
- (void)setupUI;
@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
}

- (void)setupUI {
	UIColor *color = [UIColor barColor];
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.barTintColor = color;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (IBAction)logout:(UIButton *)sender {
	// clear current User Data
	[AppUserManager.sharedManager reset];
	 
	[self destroyToRoot];
}

- (void)destroyToRoot {
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	UIViewController *root = [window rootViewController];
	UINavigationController *mainNav = (UINavigationController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"mainNav"];
	
	mainNav.view.frame = root.view.frame;
	[mainNav.view layoutIfNeeded];
	
	[UIView transitionWithView:window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		window.rootViewController = mainNav;
	} completion:^(BOOL finished) {
		// pop all VC on the current stack and release memory
		[root dismissViewControllerAnimated:true completion:nil];
	}];
}

@end
