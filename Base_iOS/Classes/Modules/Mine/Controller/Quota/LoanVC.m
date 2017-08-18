//
//  LoanVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanVC.h"

#import "LoanView.h"
#import "LoanModel.h"

#import "LoanOrderVC.h"

@interface LoanVC ()

@property (nonatomic, strong) LoanView *loanView;

@property (nonatomic, strong) LoanModel *loanModel;

@end

@implementation LoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"放款中";
    
    [self initLoanView];
}

- (void)initLoanView {

    BaseWeakSelf;
    
    self.loanView = [[LoanView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    self.loanView.loanModel = self.loanModel;
    
    self.loanView.loanBlock = ^{
    
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        LoanOrderVC *orderVC = [LoanOrderVC new];
        
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
    
    [self.view addSubview:self.loanView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
