//
//  MyTabBarController.m
//  ECommerce
//
//  Created by Mark on 2/10/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "MyTabBarController.h"
#import "UIViewController+UIVC_Extension.h"
#import "UIColor+Style.h"

@interface MyTabBarController ()

- (void)initialSetup;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"Tabbarcontroller's view is loaded");
	[self initialSetup];
}

// MARK: - do initialSetup since this is the first point after we logged in
- (void)initialSetup {
	// force all the childrenviewcontroller's view to load because we need to setup observer in cartVC to listen for change addToCart notification
	for (UIViewController *vc in self.childViewControllers) {
		[vc.contents loadViewIfNeeded];
	}
	
	// setup bar tint
	[self.tabBar setBarTintColor:[UIColor barColor]];
}
@end
