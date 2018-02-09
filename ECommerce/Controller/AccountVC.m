//
//  AccountVC.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "AccountVC.h"
#import "AppUserManager.h"

@interface AccountVC ()

- (void)destroyToRoot;

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
