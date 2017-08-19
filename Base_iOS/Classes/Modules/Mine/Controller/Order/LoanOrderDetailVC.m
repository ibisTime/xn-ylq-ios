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

@interface LoanOrderDetailVC ()

@property (nonatomic, strong) TLTableView *tableView;

@end

@implementation LoanOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.order) {
        
        [self initSubviews];

    } else {
    
        [self requestOrder];
    }
    
}

#pragma mark - Init
- (void)initSubviews {

    NSInteger status = [self.order.status integerValue];
    
    switch (status) {
        case 0:
        {
            self.title = @"待放款详情";
            
            WillLoanTableView *tableView = [[WillLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
            
        }break;
            
        case 1:
        {
            self.title = @"生效中详情";

            DidLoanTableView *tableView = [[DidLoanTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
            [UIBarButtonItem addRightItemWithTitle:@"还款" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(repayment)];
            
        }break;
           
        case 3:
        {
            self.title = @"已还款详情";

            DidRepaymentTableView *tableView = [[DidRepaymentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
        }break;
            
        case 2:
        {
            self.title = @"已逾期详情";

            OverdueTableView *tableView = [[OverdueTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
            
            tableView.order = self.order;
            
            [self.view addSubview:tableView];
            
            [UIBarButtonItem addRightItemWithTitle:@"还款" frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(repayment)];

            
        }break;
            
        default:
            break;
    }
}

#pragma mark - Events
- (void)repayment {

    RepaymentVC *repaymentVC = [RepaymentVC new];
    
    repaymentVC.order = self.order;
    
    repaymentVC.paySucces = ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    
    [self.navigationController pushViewController:repaymentVC animated:YES];
}

#pragma mark - Data
- (void)requestOrder {

    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.code = @"623086";
    http.parameters[@"code"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
