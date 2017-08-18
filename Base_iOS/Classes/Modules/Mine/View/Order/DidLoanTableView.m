//
//  DidLoanTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "DidLoanTableView.h"
#import "LoanOrderDetailCell.h"

@interface DidLoanTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation DidLoanTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = kBackgroundColor;
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self initHeaderView];
        
    }
    return self;
}

- (void)initHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
    
    headerView.backgroundColor = kWhiteColor;
    
    CGFloat centerX = kScreenWidth /2.0;
    
    UIImageView *statusIV = [[UIImageView alloc] initWithImage:kImage(@"生效中")];
    
    statusIV.frame = CGRectMake(kScreenWidth - 80, 0, 80, 100);
    
    [headerView addSubview:statusIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"金额(元)" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, 30, kWidth(150), 16);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.centerX = centerX;
    
    [headerView addSubview:textLbl];
    
    self.quotaLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:32];
    
    self.quotaLbl.frame = CGRectMake(0, textLbl.yy + 20, kScreenWidth, 32);
    
    self.quotaLbl.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:self.quotaLbl];
    
    self.tableHeaderView = headerView;
    
    self.tableFooterView = [UIView new];
}

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    self.titleArr = @[@"签约时间", @"合同编号", @"金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"快速信审费", @"账户管理费", @"利息", @"优惠券减免", @"到期还款额"];

    //签约时间
    NSString *signDate = [_order.signDatetime convertDate];
    //合同编号
    NSString *code = _order.code;
    //金额
    NSString *amount = [_order.amount convertToSimpleRealMoney];
    //期限
    NSString *duration = [NSString stringWithFormat:@"%ld", _order.duration];
    //打款日
    NSString *fkDate = [_order.fkDatetime convertDate];
    //计息日
    NSString *jxDate = [_order.jxDatetime convertDate];
    //约定还款日
    NSString *hkDate = [_order.hkDatetime convertDate];
    //快速信审费
    NSString *xsAmount = [_order.xsAmount convertToSimpleRealMoney];
    //账户管理费
    NSString *glAmount = [_order.glAmount convertToSimpleRealMoney];
    //利息
    NSString *lxAmount = [_order.lxAmount convertToSimpleRealMoney];
    //优惠券减免
    NSString *couponAmount = [_order.yhAmount convertToSimpleRealMoney];
    //到期还款额
    NSString *totalAmount = [_order.totalAmount convertToSimpleRealMoney];
    
    self.contentArr = @[signDate, code, amount, duration, fkDate, jxDate, hkDate, xsAmount, glAmount, lxAmount, couponAmount, totalAmount];

    self.quotaLbl.text = [_order.amount convertToSimpleRealMoney];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *loanOrderDetailCellID = @"LoanOrderDetailCellID";
    LoanOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:loanOrderDetailCellID];
    if (!cell) {
        
        cell = [[LoanOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loanOrderDetailCellID];
        
    }
    
    cell.titleLbl.text = self.titleArr[indexPath.row];
    
    cell.rightLabel.text = self.contentArr[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

@end
