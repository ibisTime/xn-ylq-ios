//
//  RenewalDetailTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalDetailTableView.h"
#import "LoanOrderDetailCell.h"

@interface RenewalDetailTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation RenewalDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = kBackgroundColor;
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        [self initHeaderView];
        
    }
    return self;
}

- (void)initHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
    
    headerView.backgroundColor = kWhiteColor;
    
    CGFloat centerX = kScreenWidth /2.0;
    
    UIImageView *statusIV = [[UIImageView alloc] initWithImage:kImage(@"待还款")];
    
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

- (void)setRenewal:(RenewalModel *)renewal {
    
    _renewal = renewal;
    
    self.titleArr = @[@"续期日", @"续期期限", @"续期起点", @"续期终点", @"快速信审费", @"账户管理费", @"利息", @"服务费", @"续期总费用"];
    
    //续期日
    NSString *renewalDate = [_renewal.createDatetime convertDate];
    STRING_NIL_NULL(renewalDate);
    
    //续期期限
    NSString *duration = [NSString stringWithFormat:@"%ld天", _renewal.step];
    STRING_NIL_NULL(duration);
    
    //续期起点
    NSString *oringinDate = [_renewal.startDate convertDate];
    STRING_NIL_NULL(oringinDate);
    
    //续期终点
    NSString *endDate = [_renewal.endDate convertDate];
    STRING_NIL_NULL(endDate);
    
    //快速信审费
    NSString *xsAmount = [_renewal.xsAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(xsAmount);
    
    //账户管理费
    NSString *glAmount = [_renewal.glAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(glAmount);
    
    //利息
    NSString *lxAmount = [_renewal.lxAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(lxAmount);
    
    //服务费
    NSString *fwAmount = [_renewal.fwAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(fwAmount);
    
    //续期总费用
    NSString *totalAmount = [_renewal.totalAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(totalAmount);
    
    self.contentArr = @[renewalDate, duration, oringinDate, endDate, xsAmount, glAmount, lxAmount, fwAmount, totalAmount];
    
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
    
    cell.rightLabel.textColor = indexPath.row == self.contentArr.count - 1 ? kAppCustomMainColor: kTextColor;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.titleArr.count - 1) {
        
        if (_renewalBlock) {
            
            _renewalBlock();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
