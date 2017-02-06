//
//  OYTabBarController.m
//  QuickOrangeLive
//
//  Created by Orange Yu on 2017/1/23.
//  Copyright © 2017年 Orange Yu. All rights reserved.
//

#import "OYTabBarController.h"
#import "OYNavigationController.h"

@interface OYTabBarController ()

@end

@implementation OYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIViewController *homeVc = [self setUpTabBarVcWithClassName:@"OYHomeController" andTitle:@"首页" andImageName:@"home"];
    UIViewController *categoryVc = [self setUpTabBarVcWithClassName:@"OYCategoryController" andTitle:@"分类" andImageName:@"category"];
    UIViewController *subcriptionVc = [self setUpTabBarVcWithClassName:@"OYSubscriptionController" andTitle:@"订阅" andImageName:@"subscription"];
    self.viewControllers = @[homeVc,categoryVc,subcriptionVc];
}

- (UIViewController *)setUpTabBarVcWithClassName:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    Class cls = NSClassFromString(className);
    UIViewController *vc = [[cls alloc]init];
    
    vc.tabBarItem.title = title;
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]]];
    vc.navigationItem.title = title;
    
    return [[OYNavigationController alloc]initWithRootViewController:vc];
}

@end
