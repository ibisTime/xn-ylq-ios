//
//  OverdueTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OverdueTableView.h"
#import "LoanOrderDetailCell.h"

@interface OverdueTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) UIImageView *statusIV;   //状态图标

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation OverdueTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = kBackgroundColor;
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self adjustsContentInsets];

        [self initHeaderView];
        
    }
    return self;
}

- (void)initHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
    
    headerView.backgroundColor = kWhiteColor;
    
    CGFloat centerX = kScreenWidth /2.0;
    
    UIImageView *statusIV = [[UIImageView alloc] init];
    
    statusIV.frame = CGRectMake(kScreenWidth - 80, 0, 80, 100);
    
    [headerView addSubview:statusIV];
    
    self.statusIV = statusIV;

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
    if (order.stageBatch >0) {
        self.titleArr = @[@"签约时间", @"借款单号",@"借款金额",@"已打款金额",@"已还款金额", @"剩余还款金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"逾期天数", @"快速信审费", @"账户管理费", @"服务费",@"利息" , @"优惠券减免", @"逾期金额",@"分期次数"];
        
    }else{
         self.titleArr = @[@"签约时间", @"借款单号", @"金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"逾期天数", @"快速信审费", @"账户管理费", @"服务费",@"利息", @"优惠券减免", @"逾期金额"];
    }
   
    
    //签约时间
    NSString *signDate = [_order.signDatetime convertDate];
    STRING_NIL_NULL(signDate);
    
    //合同编号
    NSString *code = _order.code;
    STRING_NIL_NULL(code);
    
    //借款金额
    NSString *borrow = [_order.borrowAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(borrow);
    
    //实际打款金额
    NSString *getAmount = [_order.realGetAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(getAmount);
    
    //已还款金额
    NSString *realHk = [_order.realHkAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(realHk);
    //金额
    NSString *amount = [_order.totalAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(amount);
    
    //期限
    NSString *duration = [NSString stringWithFormat:@"%ld天", _order.duration];
    STRING_NIL_NULL(duration);
    
    //打款日
    NSString *fkDate = [_order.fkDatetime convertDate];
    STRING_NIL_NULL(fkDate);
    
    //计息日
    NSString *jxDate = [_order.jxDatetime convertDate];
    STRING_NIL_NULL(jxDate);
    
    //约定还款日
    NSString *hkDate = [_order.hkDatetime convertDate];
    STRING_NIL_NULL(hkDate);
    
    //逾期天数
    NSString *yqDays = [NSString stringWithFormat:@"%ld", _order.yqDays];
    STRING_NIL_NULL(yqDays);
    
    //快速信审费
    NSString *xsAmount = [_order.xsAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(xsAmount);
    
    //账户管理费
    NSString *glAmount = [_order.glAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(glAmount);
    
    //利息
    NSString *lxAmount = [_order.fwAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(lxAmount);
    
    //服务费
    NSString *fwAmount = [_order.lxAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(fwAmount);
    
    //优惠券减免
    NSString *couponAmount = [_order.yhAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(couponAmount);
    
    //逾期金额
    NSString *fxAmount = [_order.yqlxAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(fxAmount);
    
    //到期还款额
    NSString *totalAmount = [_order.totalAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(totalAmount);

    //续期次数
    NSString *renewalNum = [NSString stringWithFormat:@"%@次", _order.stageBatch];
    STRING_NIL_NULL(renewalNum);
    
    self.contentArr = @[signDate, code,borrow,getAmount,realHk,amount, duration, fkDate, jxDate, hkDate, yqDays, xsAmount, glAmount, lxAmount, fwAmount, couponAmount, fxAmount, renewalNum];
    
    self.statusIV.image = kImage(_order.imageStr);

    self.quotaLbl.text = [_order.totalAmount convertToSimpleRealMoney];
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
    
    
    if (self.order.stageBatch > 0) {

        cell.rightLabel.textColor =  indexPath.row == self.titleArr.count-1 ? kAppCustomMainColor:kTextColor ;
    }else{
        cell.rightLabel.textColor =  indexPath.row == self.titleArr.count ? kAppCustomMainColor:kTextColor ;
    }

    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.row == 1) {
//        
//        if (_detailBlock) {
//            
//            _detailBlock(OrderDetailTypeLoanContract);
//            
//        }
//        
//    }else
    if (self.order.stageBatch > 0) {
        if (indexPath.row == self.titleArr.count - 1) {
            
//            if (_detailBlock) {
//
//                _detailBlock(OrderDetailTypeRenewal);
//            }
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
