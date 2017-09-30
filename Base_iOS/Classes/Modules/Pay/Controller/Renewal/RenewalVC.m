//
//  RenewalVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/5.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalVC.h"
#import "OnlineRenewalVC.h"
#import "OfflineRenewalVC.h"

#import "SelectView.h"

@interface RenewalVC ()

@property (nonatomic, strong) SelectView *selectView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation RenewalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"实时续期";
    
    [self initSelectView];
    
    [self addSubViewController];
}

#pragma mark - Init

- (void)initSelectView {
    
    BaseWeakSelf;
    
    _titles = @[@"实时续期", @"线下续期"];
    
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
            
            OnlineRenewalVC *childVC = [[OnlineRenewalVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
            childVC.order = self.order;

            childVC.paySucces = ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            };
            
            [self addChildViewController:childVC];
            
            [_selectView.scrollView addSubview:childVC.view];
            
        } else if (i == 1) {
            
            OfflineRenewalVC *childVC = [[OfflineRenewalVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
            
            childVC.order = self.order;

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
