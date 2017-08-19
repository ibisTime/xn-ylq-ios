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
//#import "SignContractVC.h"

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
    
    self.quotaBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15, self.quotaView.yy + 44, kScreenWidth - 30, quotaBtnH);
    
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.quotaBtn];
}

#pragma mark - Data

- (void)requestQuota {
    
    //--//
    //刷新额度
    TLNetworking *http = [TLNetworking new];
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.quota = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.quotaView.quotaModel = self.quota;
        
        NSString *title = self.quota.validDays > 0 ? @"使用额度": @"重新申请额度";
        
        [self.quotaBtn setTitle:title forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickUseQuota:(UIButton *)sender {
    
    [self requestGood];
    
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
