//
//  MyQuotaVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyQuotaVC.h"

#import "UIView+Custom.h"

#import "MyQuotaView.h"

#import "QuotaModel.h"

#import "SelectMoneyVC.h"
#import "TabbarViewController.h"

@interface MyQuotaVC ()

@property (nonatomic, strong) MyQuotaView *quotaView;

@property (nonatomic, strong) UIButton *quotaBtn;

@property (nonatomic, strong) QuotaModel *quota;

@end

@implementation MyQuotaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的额度";
    
    [self initQuotaView];
    
    [self requestQuota];
}

#pragma mark - Init
- (void)initQuotaView {

    self.quotaView = [[MyQuotaView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    
    self.quotaView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:self.quotaView];
    
    CGFloat quotaBtnH = 45;
    
    self.quotaBtn = [UIButton buttonWithTitle:@"签约" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15, self.quotaView.yy + 44, kScreenWidth - 30, quotaBtnH);
        
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.quotaBtn];
}

#pragma mark - Data

- (void)requestQuota {
    
    //--//
    //刷新额度
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.quota = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        NSInteger flag = [self.quota.flag integerValue];
        
        NSString *title = @"";
        
        switch (flag) {
            case 0:
            {
                
                title = @"申请额度";
                
            }break;
                
            case 1:
            {
                title = @"签约";
                
            }break;
                
            case 2:
            {
                title = @"重新申请额度";
                
            }break;
                
            default:
                break;
        }
        
        [self.quotaBtn setTitle:title forState:UIControlStateNormal];
        
        self.quotaView.quotaModel = self.quota;

    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickUseQuota:(UIButton *)sender {
    //根据额度状态进行不同的跳转
    NSInteger flag = [self.quota.flag integerValue];
    
    switch (flag) {
        case 0:
        {
            TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
            
            tabbarVC.currentIndex = 0;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }break;
            
        case 1:
        {
            [self requestGood];

        }break;
            
        case 2:
        {
            TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
            
            tabbarVC.currentIndex = 0;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }break;
            
        default:
            break;
    }
    
}

- (void)requestGood {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623013";
    
    http.parameters[@"userId"] = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {
    
        if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
            
            SelectMoneyVC *moneyVC = [SelectMoneyVC new];
            
            moneyVC.title = @"额度使用";
            
            moneyVC.selectType = SelectGoodTypeSign;
            
            [self.navigationController pushViewController:moneyVC animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
