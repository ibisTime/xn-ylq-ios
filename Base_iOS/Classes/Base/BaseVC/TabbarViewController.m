//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import "TLUserLoginVC.h"
#import "CustomTabBar.h"

@interface TabbarViewController () <UITabBarControllerDelegate, TabBarDelegate>


@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, strong) CustomTabBar *customTabbar;


@end

@implementation TabbarViewController

// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
    
    return _msgLabel;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configOpenSetting];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - Init
- (void)configTabBar {
    
    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // 创建子控制器
    [self createSubControllers];
//
//    //初始化TabBar
    [self initTabBar];
    
    //退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    
}

//配置开关
- (void)configOpenSetting {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805917";
    http.parameters[@"ckey"] = @"iosShowFlag";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *showFlag = responseObject[@"data"][@"cvalue"];
        
        //对比本地版本和后台版本，当前版本为0
        
        if ([showFlag isEqualToString:@"0"]) {
            
            [ApiConfig config].runMode = RunModeDis;
            
            [AppConfig config].runEnv = RunEnvDev;
        }
        
        //重新登录
        if([TLUser user].isLogin) {
            
            //初始化用户信息
            [[TLUser user] initUserData];
            
            [[TLUser user] reLogin];
            
        };
        
        [self configTabBar];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
    if (![vcName hasSuffix:@"VC"]) {
        vcName = [NSString stringWithFormat:@"%@VC", vcName];
    }
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.navigationItem.titleView = [UILabel labelWithTitle:title];
    
    vc.tabBarItem = tabBarItem;
    
    TabBarModel *item = [TabBarModel new];
    
    item.selectedImgUrl = imgSelected;
    item.unSelectedImgUrl = imgNormal;
    item.title = title;
    
    [self.tabBarItems addObject:item];
    
    return nav;
}


- (void)createSubControllers {
    
    switch ([ApiConfig config].runMode) {
        case RunModeDis:
        {
            NSArray *titles = @[@"借钱", @"认证", @"我的"];
            
            NSArray *normalImages = @[@"loan", @"auth", @"mine"];
            
            NSArray *selectImages = @[@"loan_select", @"auth_select", @"mine_select"];
            
            NSArray *vcNames = @[@"Home", @"Auth", @"Mine"];
            
            self.tabBarItems = [NSMutableArray array];
            
            // 借款
            NavigationController *healthManageNav = [self createNavWithTitle:titles[0] imgNormal:normalImages[0] imgSelected:selectImages[0] vcName:vcNames[0]];
            
            // 认证
            NavigationController *healthCircleNav = [self createNavWithTitle:titles[1] imgNormal:normalImages[1] imgSelected:selectImages[1] vcName:vcNames[1]];
            
            // 我的
            NavigationController *nearbyNav = [self createNavWithTitle:titles[2] imgNormal:normalImages[2] imgSelected:selectImages[2] vcName:vcNames[2]];
            
            self.viewControllers = @[healthManageNav, healthCircleNav, nearbyNav];
            
        }break;
            
        case RunModeReview:
        {
            NSArray *titles = @[@"商城", @"购物车", @"我的"];
            
            NSArray *normalImages = @[@"health_mall", @"health_manage", @"mine"];
            
            NSArray *selectImages = @[@"health_mall_select", @"health_manage_select", @"mine_select"];
            
            NSArray *vcNames = @[@"HealthMall", @"ZHShoppingCart", @"BaseMine"];
            
            self.tabBarItems = [NSMutableArray array];
            
            // 商城
            NavigationController *healthMallNav = [self createNavWithTitle:titles[0] imgNormal:normalImages[0] imgSelected:selectImages[0] vcName:vcNames[0]];
            
            //购物车
            NavigationController *shopCartNav = [self createNavWithTitle:titles[1] imgNormal:normalImages[1] imgSelected:selectImages[1] vcName:vcNames[1]];
            
            // 我的
            NavigationController *mineNav = [self createNavWithTitle:titles[2] imgNormal:normalImages[2] imgSelected:selectImages[2] vcName:vcNames[2]];
            
            self.viewControllers = @[healthMallNav, shopCartNav, mineNav];
            
        }break;
            
        default:
            break;
    }
}

- (void)initTabBar {
    
    //替换系统tabbar
    CustomTabBar *tabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.translucent = NO;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor orangeColor];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    tabBar.itemNum = self.tabBarItems.count;

    [tabBar layoutSubviews];
    
    tabBar.tabBarItems = self.tabBarItems.copy;

    self.customTabbar = tabBar;
    
}

#pragma mark - Events

- (void)userLogout {
    
//    self.tabBar.items[3].badgeValue =  nil;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {
    
    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    self.selectedIndex = _currentIndex;

    self.customTabbar.selectedIdx = _currentIndex;
    
}

#pragma mark - TabbarDelegate
- (BOOL)didSelected:(NSInteger)idx tabBar:(UITabBar *)tabBar {
    
    switch ([ApiConfig config].runMode) {
        case RunModeDis:
        {
            if (idx == 2 && ![TLUser user].isLogin) {

                TLUserLoginVC *loginVC = [TLUserLoginVC new];

                NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];

                [self presentViewController:nav animated:YES completion:nil];

                return NO;
            }

        }break;

        case RunModeReview:
        {
            if ((idx == 1 || idx == 2) && ![TLUser user].isLogin) {

                TLUserLoginVC *loginVC = [TLUserLoginVC new];

                NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];

                [self presentViewController:nav animated:YES completion:nil];

                return NO;
            }

        }break;

        default:
            break;
    }
    
    //
    self.selectedIndex = idx;
    
    return YES;
    
}



@end
