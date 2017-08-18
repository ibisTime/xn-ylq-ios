//
//  LoanOrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanOrderVC.h"

#import "LoanOrderListVC.h"

#import "LoanSegmentView.h"

@interface LoanOrderVC ()<LoanSegmentViewDelegate>

@property (nonatomic, strong) LoanOrderListVC *willLoanVC;        //待放款

@property (nonatomic, strong) LoanOrderListVC *didLoanVC;         //生效中

@property (nonatomic, strong) LoanOrderListVC *didRepaymentVC;    //已还款

@property (nonatomic, strong) LoanOrderListVC *overdueVC;         //已逾期

@property (nonatomic,strong) NSMutableArray *isAdd;

@property (nonatomic, strong) LoanSegmentView *segmentView;

@property (nonatomic,strong) UIScrollView *switchSV;

@end

@implementation LoanOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"借款记录";
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];
    
    [self initTopView];
    
    [self initScrollView];
}

#pragma mark - Init
- (void)initTopView {

    LoanSegmentView *segmentView =  [[LoanSegmentView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"待放款",@"生效中",@"已还款",@"已逾期"];
    
    self.isAdd = [@[@1, @0, @0, @0] mutableCopy];
    
    self.segmentView = segmentView;
}

- (void)initScrollView {

    UIScrollView *switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentView.yy + 0.5, kScreenWidth, kScreenHeight - 64 - self.segmentView.yy)];
    switchSV.pagingEnabled = YES;
    switchSV.contentSize = CGSizeMake(kScreenWidth * 3, switchSV.height);
    switchSV.scrollEnabled = NO;

    [self.view addSubview:switchSV];
    self.switchSV = switchSV;
    
    //
    [self addChildViewController:self.willLoanVC];
}

- (LoanOrderListVC *)willLoanVC {

    if (!_willLoanVC) {
        
        _willLoanVC = [[LoanOrderListVC alloc] init];
        _willLoanVC.status = LoanOrderStatusWillLoan;
        _willLoanVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.switchSV.height);
        
        [self.switchSV addSubview:_willLoanVC.view];
    }
    
    return _willLoanVC;
}

- (LoanOrderListVC *)didLoanVC {

    if (!_didLoanVC) {
        
        _didLoanVC = [[LoanOrderListVC alloc] init];
        _didLoanVC.status = LoanOrderStatusDidLoan;
        _didLoanVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.switchSV.height);
        
        [self.switchSV addSubview:_didLoanVC.view];
    }
    
    return _didLoanVC;
}

- (LoanOrderListVC *)didRepaymentVC {

    if (!_didRepaymentVC) {
        
        _didRepaymentVC = [[LoanOrderListVC alloc] init];
        _didRepaymentVC.status = LoanOrderStatusDidRepayment;
        _didRepaymentVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, self.switchSV.height);
        
        [self.switchSV addSubview:_didRepaymentVC.view];
    }
    return _didRepaymentVC;
}

- (LoanOrderListVC *)overdueVC {

    if (!_overdueVC) {
        
        _overdueVC = [[LoanOrderListVC alloc] init];
        _overdueVC.status = LoanOrderStatusDidOverdue;
        _overdueVC.view.frame = CGRectMake(3*kScreenWidth, 0, kScreenWidth, self.switchSV.height);
        
        [self.switchSV addSubview:_overdueVC.view];
    }
    
    return _overdueVC;
}

- (BOOL)segmentSwitch:(NSInteger)idx {
    
    [self.switchSV setContentOffset:CGPointMake(idx*kScreenWidth, 0) animated:YES];
    
    if (idx == 0) {
        
        
    } else if( idx == 1) {
        
        if ([self.isAdd[1] isEqual:@0]) {
            
            [self addChildViewController:self.didLoanVC];
            [self.switchSV addSubview:self.didLoanVC.view];
            
        } else {
            
            self.isAdd[1] = @1;
        }
        
    } else if(idx == 2) {
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.didRepaymentVC];
            [self.switchSV addSubview:self.didRepaymentVC.view];
            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
    } else {
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.overdueVC];
            [self.switchSV addSubview:self.overdueVC.view];
            
            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
    }
    
    return YES;
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
