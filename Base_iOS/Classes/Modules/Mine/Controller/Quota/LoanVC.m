//
//  LoanVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanVC.h"

#import "LoanView.h"
#import "OrderModel.h"

#import "LoanOrderVC.h"

@interface LoanVC ()

@property (nonatomic, strong) LoanView *loanView;

@property (nonatomic, strong) OrderModel *orderModel;

@end

@implementation LoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"放款中";
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];
    
    [self initLoanView];
    
    //获取金额
    [self requestAmount];
}

- (void)initLoanView {

    BaseWeakSelf;
    
    self.loanView = [[LoanView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    self.loanView.loanBlock = ^{
        
        LoanOrderVC *orderVC = [LoanOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    
    [self.view addSubview:self.loanView];
}

#pragma mark - Data
- (void)requestAmount {

    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"623087";
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    helper.parameters[@"status"] = @"0";

    helper.isDeliverCompanyCode = NO;
    
    [helper modelClass:[OrderModel class]];
    
    //-----//
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.orderModel = objs[0];
        weakSelf.loanView.orderModel = weakSelf.orderModel;

        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)back {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
