//
//  RenewalListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalListVC.h"

#import "RenewalModel.h"
#import "RenewalListCell.h"

#import "RenewalDetailVC.h"

@interface RenewalListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,strong) NSMutableArray <RenewalModel *>*renewals;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation RenewalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"续期列表";
    
    [self initPlaceHolderView];
    
    [self initTableView];
    
    [self requestRenewalList];

}

#pragma mark - Init
- (void)initTableView {
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 100;
    
    self.tableView = tableView;
    tableView.placeHolderView = self.placeHolderView;
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"您还没有续期记录" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

#pragma mark - Data
- (void)requestRenewalList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"623090";
    helper.parameters[@"borrowCode"] = self.code;
    
    helper.isDeliverCompanyCode = NO;
    
    helper.tableView = self.tableView;
    [helper modelClass:[RenewalModel class]];
    
    //-----//
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.renewals = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.renewals = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.renewals.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *renewalListCellID = @"RenewalListCellID";
    
    RenewalListCell *cell = [tableView dequeueReusableCellWithIdentifier:renewalListCellID];
    
    if (!cell) {
        
        cell = [[RenewalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:renewalListCellID];
        
    }
    
    cell.renewal = self.renewals[indexPath.section];
    
    return cell;
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RenewalDetailVC *vc = [[RenewalDetailVC alloc] init];
    
    vc.renewal = self.renewals[indexPath.section];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //50
    return 0.1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
