//
//  CouponListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponListVC.h"
#import "TLTableView.h"
#import "CouponCell.h"

@interface CouponListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <CouponModel *>*coupons;

@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UILabel *promptLbl;

@end

@implementation CouponListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)startLoadData {

    [self initPlaceHolderView];
    
    [self initTableView];
    
    [self requestCouponPrompt];

    [self requestCouponList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.rowHeight = 100;
    
    [self.view addSubview:self.tableView];
    
}

- (void)initPlaceHolderView {
    
    NSString *prompt = _statusType == CouponStatusTypeUse ? @"您目前没有优惠券": @"您目前没有失效优惠券";
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];

    if (_statusType == CouponStatusTypeUse) {
    
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        
        topView.tag = 1200;
        
        topView.backgroundColor = kWhiteColor;
        
        [self.placeHolderView addSubview:topView];
        
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
    
        iconIV.tag = 1201;
    
        iconIV.image = kImage(@"提示");
    
        [topView addSubview:iconIV];
        
        UILabel *promptLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:12];
        
        promptLbl.numberOfLines = 0;
        
        promptLbl.frame = CGRectMake(40, 0, kScreenWidth - 40, 60);
        
        [topView addSubview:promptLbl];
        
        self.promptLbl = promptLbl;
    }
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60 + 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无优惠券");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:prompt textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    
}

#pragma mark - Data
- (void)requestCouponList {
    
    BaseWeakSelf;
    
    NSString *status = self.statusType == CouponStatusTypeUse ? @"0": @"12";
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.showView = self.view;
    helper.code = @"623147";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"status"] = status;
    
    [helper modelClass:[CouponModel class]];
    
    helper.tableView = self.tableView;
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.coupons = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.coupons = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

//优惠券提示
- (void)requestCouponPrompt {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623917";
    
    http.parameters[@"key"] = @"couponRule";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = responseObject[@"data"][@"cvalue"];
        
        CGFloat height = ([promptStr componentsSeparatedByString:@"\n"].count+1)*20;

        [self.promptLbl labelWithTextString:promptStr lineSpace:5];
        
        self.promptLbl.height = height;

        UIView *bgView = [self.placeHolderView viewWithTag:1200];
        
        bgView.height = height;
        
        UIImageView *iconIV = [bgView viewWithTag:1201];
        
        iconIV.centerY = bgView.height/2.0;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.coupons.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *couponCellID = @"CouponCellID";
    
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellID];
    
    if (!cell) {
        
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponCellID];
        
    }
    
    cell.coupon = self.coupons[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_couponBlock) {
        
        CouponModel *coupon = self.coupons[indexPath.row];
        
        _couponBlock(coupon);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
