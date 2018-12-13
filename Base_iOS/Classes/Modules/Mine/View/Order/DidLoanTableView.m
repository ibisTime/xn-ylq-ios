//
//  DidLoanTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "DidLoanTableView.h"
#import "LoanOrderDetailCell.h"
#import "RenewalModel.h"
@interface DidLoanTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;        //额度

@property (nonatomic, strong) UIImageView *statusIV;   //状态图标

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
    if (order.info) {
          self.titleArr = @[@"签约时间", @"借款单号", @"金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"快速信审费", @"账户管理费", @"利息", @"服务费", @"优惠券减免", @"到期还款额", @"分期情况", @"开始还款时间", @"最晚还款时间", @"今日应还本息"];
    }else{
        
         self.titleArr = @[@"签约时间", @"借款单号", @"金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"快速信审费", @"账户管理费", @"利息", @"服务费", @"优惠券减免", @"到期还款额"];
    }
  

    //签约时间
    NSString *signDate = [_order.signDatetime convertDate];
    STRING_NIL_NULL(signDate);
    
    //合同编号
    NSString *code = _order.code;
    STRING_NIL_NULL(code);
    
    //金额
    NSString *amount = [_order.amount convertToSimpleRealMoney];
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
    
    //快速信审费
    NSString *xsAmount = [_order.xsAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(xsAmount);
    
    //账户管理费
    NSString *glAmount = [_order.glAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(glAmount);
    
    //利息
    NSString *lxAmount = [_order.lxAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(lxAmount);
    
    //服务费
    NSString *fwAmount = [_order.fwAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(fwAmount);
    
    //优惠券减免
    NSString *couponAmount = [_order.yhAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(couponAmount);
    
    //到期还款额
    NSString *totalAmount = [_order.totalAmount convertToSimpleRealMoney];
    STRING_NIL_NULL(totalAmount);
    NSString *renewalNum;
    if (order.info.remark == nil) {
        order.info.remark = @"";
        //续期次数
       renewalNum = @"";
    }else{
        
        renewalNum = [NSString stringWithFormat:@"%@/%@", order.info.stageCount,order.stageCount];
        STRING_NIL_NULL(renewalNum);
    }
  
    if (order.info) {
        NSString *coupon = [order.info.startTime convertDate];
        STRING_NIL_NULL(coupon);
        
        //到期还款额
        NSString *total = [order.info.endTime convertDate];
        STRING_NIL_NULL(total);
        
        //续期次数
        NSString *renewa = [order.info.amount convertToSimpleRealMoney];
        STRING_NIL_NULL(renewa);
        self.contentArr = @[signDate, code, amount, duration, fkDate, jxDate, hkDate, xsAmount, glAmount, lxAmount, fwAmount, couponAmount, totalAmount, renewalNum,coupon,total,renewa];
    }else{
        
       self.contentArr = @[signDate, code, amount, duration, fkDate, jxDate, hkDate, xsAmount, glAmount, lxAmount, fwAmount, couponAmount, totalAmount];
    }
    

    self.statusIV.image = kImage(_order.imageStr);
    
    self.quotaLbl.text = [order.amount convertToSimpleRealMoney];
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
    if (self.order.info) {
        cell.rightLabel.textColor = indexPath.row == self.contentArr.count - 4? kAppCustomMainColor: kTextColor;
    }else{
        cell.rightLabel.textColor = kTextColor;
        if (indexPath.row == self.contentArr.count-1) {
            cell.rightLabel.textColor = kAppCustomMainColor;
        }
    }
   
    if (self.order.info) {
        cell.arrowHidden = indexPath.row == self.contentArr.count - 4 ? NO: YES;

    }else{
        cell.arrowHidden = YES;
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.order.info) {
        if (indexPath.row == self.titleArr.count - 4) {
            
            if (_detailBlock) {
                
                _detailBlock(OrderDetailTypeRenewal);
            }
        }
    }else{
        
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
