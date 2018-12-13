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
#import "LoanContractVC.h"
#import "HTMLStrVC.h"
#import "RenewalListVC.h"
#import "OnlineRepaymentVC.h"
@interface LoanOrderDetailVC ()

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, assign) BOOL  isChange;

@end

@implementation LoanOrderDetailVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (!self.order) {
//
//        [self requestOrder];
//    }
//    [self initSubviews];
    [self requestOrder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.order) {
         [self initSubviews];
    }
//    [self stage];
}

-(void)stage
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623075";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"stageRuleCode"] = @"SR2018112716314357157077";
    http.parameters[@"updater"] = @"test";
    http.parameters[@"remarkQUERY"] = @"申请分期";
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"分期成功");
    } failure:^(NSError *error) {
        
    }];


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
        case 8://宝付代付

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
            
            tableView.detailBlock = ^(OrderDetailType type) {
                
                if (type == OrderDetailTypeLoanContract) {
                    
                    LoanContractVC *contractVC = [LoanContractVC new];
                    
                    contractVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:contractVC animated:YES];
                    
                } else if (type == OrderDetailTypeRenewal) {
                    
                    RenewalListVC *renewalListVC = [RenewalListVC new];
                    
                    renewalListVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
                }
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

            tableView.detailBlock = ^(OrderDetailType type) {
                
                if (type == OrderDetailTypeLoanContract) {
                    
                    LoanContractVC *contractVC = [LoanContractVC new];
                    
                    contractVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:contractVC animated:YES];
                    
                } else if (type == OrderDetailTypeRenewal) {
                    
                    RenewalListVC *renewalListVC = [RenewalListVC new];
                    
                    renewalListVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
                }
            };
            
            [self.view addSubview:tableView];
            
        }break;
            
        case 5:
        {
            self.title = @"已逾期详情";

            OverdueTableView *tableView = [[OverdueTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 65)];
            
            tableView.order = self.order;
            
            tableView.detailBlock = ^(OrderDetailType type) {
                
                if (type == OrderDetailTypeLoanContract) {
                    
                    LoanContractVC *contractVC = [LoanContractVC new];
                    
                    contractVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:contractVC animated:YES];
                    
                } else if (type == OrderDetailTypeRenewal) {
                    
                    RenewalListVC *renewalListVC = [RenewalListVC new];
                    
                    renewalListVC.code = weakSelf.order.code;
                    
                    [weakSelf.navigationController pushViewController:renewalListVC animated:YES];
                }
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
    
    CGFloat btnW = (kScreenWidth - 2*15);
    
    UIButton *repayBtn = [UIButton buttonWithTitle:@"还款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:10];
    
    repayBtn.frame = CGRectMake(15, 10, btnW, 45);
    
    [repayBtn addTarget:self action:@selector(clickRepay) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:repayBtn];
//    UIButton *Renewal = [UIButton buttonWithTitle:@"分期" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:10];
//
//    Renewal.frame = CGRectMake(15*2+btnW, 10, btnW, 45);
//
//    [Renewal addTarget:self action:@selector(clickRenewal) forControlEvents:UIControlEventTouchUpInside];
//
//    [bottomView addSubview:Renewal];
    
   
}

#pragma mark - Events

- (void)clickRepay {
   
    //分期
    if ([self.order.isStage isEqualToString:@"1"]) {
//        [self clickRenewal];
        [TLAlert alertWithTitle:@"请确认还款信息是否正确" msg:[NSString stringWithFormat:@"期数: %@\n本金: %@\n利息: %@", self.order.info.remark, [self.order.info.mainAmount convertToSimpleRealMoney], [self.order.info.lxAmount convertToSimpleRealMoney]] confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            return ;
        } confirm:^(UIAlertAction *action) {
            
            OnlineRepaymentVC *pay = [OnlineRepaymentVC new];
//            HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//            htmlVC.type = HTMLTypePay;
            pay.renewalModel = self.order.info;
            [self.navigationController pushViewController:pay animated:YES];
        }];

    }else{
        //未分期
//
//        HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//        htmlVC.type = HTMLTypePay;
        RepaymentVC *repaymentVC = [RepaymentVC new];

        repaymentVC.order = self.order;
//
        [self.navigationController pushViewController:repaymentVC animated:YES];
    }
    
   
}

- (void)clickRenewal {

    RenewalListVC *ListVC = [RenewalListVC new];
    
    ListVC.code = self.order.code;
    
    [self.navigationController pushViewController:ListVC animated:YES];
}

- (void)clickResubmit {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623073";
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
    if (!self.order.code) {
        http.parameters[@"code"] = self.code;

    }else
    {
        http.parameters[@"code"] = self.order.code;

    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestFail {
    
    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.showView = self.view;
    http.code = @"623086";
    if (!self.order.code) {
        http.parameters[@"code"] = self.code;
        
    }else
    {
        http.parameters[@"code"] = self.order.code;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Events
- (void)alertFailureInfo {
    BaseWeakSelf;
    if (self.isChange == YES) {
        [self clickResubmit];
        return;
    }
    [TLAlert alertWithTitle:@"提示" msg:@"打款失败, 请核对银行卡信息" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
       
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        vc.addSuccess = ^{
            weakSelf.isChange = YES;

            [weakSelf requestFail];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
