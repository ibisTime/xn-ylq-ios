//
//  ManualAuditVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ManualAuditVC.h"
#import "TabbarViewController.h"
#import "UIView+Custom.h"

@interface ManualAuditVC ()

@end

@implementation ManualAuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {

    NSArray *imgArr = @[@"期望额度", @"select", @"系统审核灰"];
    
    NSArray *titleArr = @[@"期望额度", @"资料认证", @"系统审核"];
    
    for (int i = 0; i < 3; i++) {

        CGFloat imgViewW = 21;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        
        iv.frame = CGRectMake(kWidth(100), kHeight(40) + i*(21 + kHeight(65)), imgViewW, imgViewW);
        
        iv.layer.cornerRadius = imgViewW/2.0;
        
        iv.clipsToBounds = YES;
        
        [self.view addSubview:iv];
        
        UILabel *textLbl = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:15.0];
        
        textLbl.frame = CGRectMake(iv.xx + kWidth(20), kHeight(42) + i*(21 + kHeight(65)), 70, 16);
        
        [self.view addSubview:textLbl];
        
        if (i != 2) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(iv.centerX, iv.yy, 1, kHeight(65))];
            
            UIColor *color = i == 0 ? kAppCustomMainColor : [UIColor colorWithHexString:@"#cccccc"];
            
            [self.view addSubview:lineView];

            [lineView drawDashLine:3 lineSpacing:2 lineColor:color];
            
        }
    }
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"耐心等待" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, kHeight(300), kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitBtn];
}

#pragma mark - Events
- (void)clickCommit {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)back {

    TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
    
    tabbarVC.currentIndex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
