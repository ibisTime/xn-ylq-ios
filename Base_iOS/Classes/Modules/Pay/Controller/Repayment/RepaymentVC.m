//
//  RepaymentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RepaymentVC.h"

#import "SelectView.h"

#import "OnlineRepaymentVC.h"
#import "OfflineRepaymentVC.h"

@interface RepaymentVC ()

@property (nonatomic, strong) SelectView *selectView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation RepaymentVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"实时还款";
    
    [self initSelectView];
    
    [self addSubViewController];
}

#pragma mark - Init

- (void)initSelectView {
    
    BaseWeakSelf;
    
    _titles = @[@"实时还款", @"线下还款"];
    
    _selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:_titles];
    
    _selectView.selectBlock = ^(NSInteger index) {
        
        weakSelf.title = weakSelf.titles[index];
    };
    
    [_selectView setLinePropertyWithLineColor:kAppCustomMainColor lineSize:CGSizeMake(kScreenWidth/2.0, 2)];
    
    [self.view addSubview:_selectView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        
        if (i == 0) {
            
            OnlineRepaymentVC *childVC = [[OnlineRepaymentVC alloc] init];
            
            childVC.order = self.order;

            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight -40);
            
            childVC.paySucces = ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            };
            
            [self addChildViewController:childVC];
            
            [_selectView.scrollView addSubview:childVC.view];
            
        } else if (i == 1) {
            
            OfflineRepaymentVC *childVC = [[OfflineRepaymentVC alloc] init];
            
            childVC.order = self.order;

            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight -40);
            
            childVC.paySucces = ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            };
            
            [self addChildViewController:childVC];
            
            [_selectView.scrollView addSubview:childVC.view];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
