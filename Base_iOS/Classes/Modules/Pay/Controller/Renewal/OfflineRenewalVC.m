//
//  OfflineRenewalVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/5.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OfflineRenewalVC.h"
#import "DetailWebView.h"

@interface OfflineRenewalVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) TLTextField *originDateTF;    //起始时间
@property (nonatomic, strong) TLTextField *endDateTF;       //结束时间
@property (nonatomic, strong) TLTextField *amountTF;        //续期金额

@property (nonatomic, strong) DetailWebView *detailWebView;

@property (nonatomic, copy) NSString *repayOfflineAccount;      //打款账号
@property (nonatomic, strong) UILabel *promptLbl;           //提示

@end

@implementation OfflineRenewalVC

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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 197)];
    
    [self.scrollView addSubview:self.headerView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    
    UILabel *textLbl = [UILabel labelWithFrame:CGRectMake(15, 0, kScreenWidth, 32) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(14) textColor:kTextColor2];
    
    textLbl.text = @"本次续期";
    
    [topView addSubview:textLbl];
    
    [self.headerView addSubview:topView];
    
    //起始时间
    TLTextField *originDateTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, topView.yy, kScreenWidth, 44) leftTitle:@"起点日期" titleWidth:145 placeholder:@""];
    
    originDateTF.textColor = [UIColor textColor];
    
    originDateTF.enabled = NO;
    
    [self.headerView addSubview:originDateTF];
    
    self.originDateTF = originDateTF;
    
    //结束时间
    TLTextField *endDateTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, originDateTF.yy + 1, kScreenWidth, 44) leftTitle:@"续期后还款日期" titleWidth:145 placeholder:@""];
    
    endDateTF.textColor = [UIColor textColor];
    
    endDateTF.enabled = NO;
    
    [self.headerView addSubview:endDateTF];
    self.endDateTF = endDateTF;
    
    //续期金额
    self.amountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, endDateTF.yy + 1, kScreenWidth, 44) leftTitle:@"续期金额" titleWidth:145 placeholder:@""];
    
    self.amountTF.textColor = [UIColor textColor];
    
    self.amountTF.enabled = NO;
    
    [self.headerView addSubview:self.amountTF];
    
    //提示
    self.promptLbl = [UILabel labelWithFrame:CGRectMake(15, self.amountTF.yy, kScreenWidth - 30, 30) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13.0) textColor:kThemeColor];
    
    [self.headerView addSubview:self.promptLbl];
}

- (void)initWebview {
    
    BaseWeakSelf;
    
    //账号信息
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, self.headerView.yy, kScreenWidth, 100)];
    
    [self.detailWebView loadWebWithString:_repayOfflineAccount];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        weakSelf.detailWebView.height = height;
        
        weakSelf.detailWebView.webView.height = height;
        //底部按钮
        [weakSelf initBottomButton];
    };
    
    [self.scrollView addSubview:weakSelf.detailWebView];
    
}

- (void)initBottomButton {
    
    UIButton *renewalBtn = [UIButton buttonWithTitle:@"我已打款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    renewalBtn.frame = CGRectMake(15, self.detailWebView.yy + 40, kScreenWidth - 30, 45);
    
    [renewalBtn addTarget:self action:@selector(renewal) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:renewalBtn];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, renewalBtn.yy + 40);

}

#pragma mark - Setting
- (void)setRepayOfflineAccount:(NSString *)repayOfflineAccount {

    _repayOfflineAccount = repayOfflineAccount;
    
    //打款指引
    [self initWebview];
}

- (void)setOrder:(OrderModel *)order {

    _order = order;
    
    self.originDateTF.text = [_order.renewalStartDate convertDate];
    
    self.endDateTF.text = [_order.renewalEndDate convertDate];
    
    self.amountTF.text = [NSString stringWithFormat:@"%@元", [_order.renewalAmount convertToSimpleRealMoney]];
    
    //逾期利息
    NSString *yqAmount = [_order.yqlxAmount convertToSimpleRealMoney];
    
    //续期利息
    NSString *xqAmount = [@([_order.renewalAmount longLongValue] - [_order.yqlxAmount longLongValue]) convertToSimpleRealMoney];
    
    self.promptLbl.text = [NSString stringWithFormat:@"续期金额 = 续期利息(%@元) + 逾期利息(%@元)", xqAmount, yqAmount];
}

#pragma mark - Events
//续期
- (void)renewal {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623078";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"payType"] = @"4";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"打款成功, 我们将会对您的申请进行审核"];
        
        if (_paySucces) {
            
            _paySucces();
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
