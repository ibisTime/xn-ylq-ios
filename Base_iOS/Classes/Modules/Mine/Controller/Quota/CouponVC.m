//
//  CouponVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponVC.h"

#import "CouponListVC.h"
#import "HTMLStrVC.h"

#import "SelectView.h"

@interface CouponVC ()

@property (nonatomic, strong) SelectView *selectView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation CouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"优惠券";
    
    [UIBarButtonItem addRightItemWithTitle:@"说明" frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(couponRemark)];

    [self initSelectView];

    [self addSubViewController];

}

- (void)initSelectView {
    
    _titles = @[@"可使用", @"不可使用"];
    
    _selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) itemTitles:_titles];
    
    [_selectView setLinePropertyWithLineColor:kAppCustomMainColor lineSize:CGSizeMake(kScreenWidth/2.0, 2)];
    
    [self.view addSubview:_selectView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        
        CouponListVC *childVC = [[CouponListVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kScreenHeight - 64 - 40);
        
        childVC.statusType = i;
        
        [self addChildViewController:childVC];
        
        [_selectView.scrollView addSubview:childVC.view];
        
        [childVC startLoadData];
        
    }
}

#pragma mark - Events
- (void)couponRemark {
    
    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeCouponExplain;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
