//
//  LoanOrderDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanOrderDetailVC.h"

#import "WillLoanTableView.h"
#import "DidLoanTableView.h"
#import "DidRepaymentTableView.h"
#import "OverdueTableView.h"

#import "RepaymentVC.h"
#import "RenewalVC.h"
#import "RenewalListVC.h"
#import "ZHBankCardListVC.h"

@interface LoanOrderDetailVC ()

@property (nonatomic, strong) TLTableView *tableView;

@end

@implementation LoanOrderDetailVC

- (void)viewDidAppear:(BOOL)animated {

    if (!self.order) {
        
        [self requestOrder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.order) {
        
        [self initSubviews];
    }
    
}

#pragma mark - Init
- (void)initSubviews {

    BaseWeakSelf;
    
    NSInteger status = [self.order.status integerValue];
    
    switch (status) {
        case 0:
        {
            self.title = @"待审核详情";
            
            WillLoanTableView *tableView = [[WillLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
            
        }break;
            
        case 1:
        {
            self.title = @"待放款详情";
            
            WillLoanTableView *tableView = [[WillLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];

            
        }break;
          
        
        case 2:
        {
            self.title = @"审核不通过";
            
            WillLoanTableView *tableView = [[WillLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
            
        }break;
            
        case 3:
        {
            self.title = @"待还款详情";

            DidLoanTableView *tableView = [[DidLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 65)];
            
            tableView.order = self.order;
            
            tableView.renewalBlock = ^{
                
                RenewalListVC *renewalListVC = [RenewalListVC new];
                
                renewalListVC.code = weakSelf.order.code;

                [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
            };
            
            [self.view addSubview:tableView];
            
            //底部视图
            [self initBottomButton];
            
        }break;
           
        case 4:
        {
            self.title = @"已还款详情";

            DidRepaymentTableView *tableView = [[DidRepaymentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;

            tableView.renewalBlock = ^{
                
                RenewalListVC *renewalListVC = [RenewalListVC new];
                
                renewalListVC.code = weakSelf.order.code;
                
                [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
            };
            
            [self.view addSubview:tableView];
            
        }break;
            
        case 5:
        {
            self.title = @"已逾期详情";

            OverdueTableView *tableView = [[OverdueTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;
            
            tableView.renewalBlock = ^{
                
                RenewalListVC *renewalListVC = [RenewalListVC new];
                
                renewalListVC.code = weakSelf.order.code;
                
                [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
            };

            [self.view addSubview:tableView];
            
            //底部视图
            [self initBottomButton];
            
        }break;
            
        case 7:
        {
            BaseWeakSelf;
            
            self.title = @"打款失败";
            
            WillLoanTableView *tableView = [[WillLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
            
            tableView.order = self.order;
            
            tableView.commitBlock = ^{
                //重新提交
                [weakSelf clickResubmit];
            };
            
            [self.view addSubview:tableView];
            
            //弹窗
            [self alertFailureInfo];
            
        }break;
            
        default:
            break;
    }
}

- (void)initBottomButton {

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 65, kScreenWidth, 65)];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    
    lineView.backgroundColor = kLineColor;
    
    [bottomView addSubview:lineView];
    
    CGFloat btnW = (kScreenWidth - 3*15)/2.0;
    
    UIButton *repayBtn = [UIButton buttonWithTitle:@"还款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:10];
    
    repayBtn.frame = CGRectMake(15, 10, btnW, 45);
    
    [repayBtn addTarget:self action:@selector(clickRepay) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:repayBtn];
    
    UIButton *renewalBtn = [UIButton buttonWithTitle:@"续期" titleColor:kWhiteColor backgroundColor:kTextColor3 titleFont:18 cornerRadius:10];
    
    renewalBtn.frame = CGRectMake(kScreenWidth/2.0 + 5, 10, btnW, 45);
    
    [renewalBtn addTarget:self action:@selector(clickRenewal) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:renewalBtn];
}

#pragma mark - Events

- (void)clickRepay {

    RepaymentVC *repaymentVC = [RepaymentVC new];
    
    repaymentVC.order = self.order;
    
    [self.navigationController pushViewController:repaymentVC animated:YES];
}

- (void)clickRenewal {

    RenewalVC *renewalVC = [RenewalVC new];
    
    renewalVC.order = self.order;
    
    [self.navigationController pushViewController:renewalVC animated:YES];
}

- (void)clickResubmit {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623079";
    http.parameters[@"code"] = self.order.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"重新提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - Data
- (void)requestOrder {

    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.showView = self.view;
    http.code = @"623086";
    http.parameters[@"code"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Events
- (void)alertFailureInfo {
    
    [TLAlert alertWithTitle:@"提示" msg:@"打款失败, 请核对银行卡信息" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
       
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
