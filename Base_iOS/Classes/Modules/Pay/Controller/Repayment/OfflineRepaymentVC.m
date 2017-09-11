//
//  OfflineRepaymentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OfflineRepaymentVC.h"
#import "DetailWebView.h"

@interface OfflineRepaymentVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic,strong) TLTextField *amountTF;

@property (nonatomic, strong) DetailWebView *detailWebView;

@property (nonatomic, copy) NSString *repayOfflineAccount;      //打款账号

@end

@implementation OfflineRepaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    //获取打款账号
    [self requestRepayOfflineAccount];
}

#pragma mark - Init

- (void)initSubviews {
    
    //滚动
    [self initScrollView];
    //头部
    [self initHeaderView];

}

- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    
    [self.scrollView addSubview:self.headerView];
    
    //还款金额
    self.amountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 44) leftTitle:@"还款金额" titleWidth:100 placeholder:@""];
    
    self.amountTF.textColor = [UIColor textColor];
    
    self.amountTF.backgroundColor = kWhiteColor;
    
    self.amountTF.text = [self.order.totalAmount convertToSimpleRealMoney];

    self.amountTF.enabled = NO;
    
    [self.headerView addSubview:self.amountTF];
    
}

- (void)initWebview {
    
    BaseWeakSelf;
    
    //账号信息
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, self.headerView.yy, kScreenWidth, 100)];
    
    [self.detailWebView loadWebWithString:_repayOfflineAccount];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        weakSelf.detailWebView.height = height;
        
        weakSelf.detailWebView.webView.height = height;
      
        [weakSelf initBottomButton];

    };
    
    [self.scrollView addSubview:weakSelf.detailWebView];
    
}

- (void)initBottomButton {
    
    UIButton *repayBtn = [UIButton buttonWithTitle:@"我已打款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    repayBtn.frame = CGRectMake(15, self.detailWebView.yy + 40, kScreenWidth - 30, 45);
    
    [repayBtn addTarget:self action:@selector(repayment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:repayBtn];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, repayBtn.yy + 40);

}

#pragma mark - Setting
- (void)setRepayOfflineAccount:(NSString *)repayOfflineAccount {
    
    _repayOfflineAccount = repayOfflineAccount;
    
    //打款指引
    [self initWebview];
}

#pragma mark - Events
//还款
- (void)repayment {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623072";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"payType"] = @"4";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"打款成功, 我们将会对您的申请进行审核"];
        
        if (self.paySucces) {
            self.paySucces();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data
- (void)requestRepayOfflineAccount {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805917";
    
    http.parameters[@"ckey"] = @"repayOfflineAccount";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.repayOfflineAccount = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
