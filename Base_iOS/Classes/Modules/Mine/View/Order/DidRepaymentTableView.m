//
//  DidRepaymentTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "DidRepaymentTableView.h"
#import "LoanOrderDetailCell.h"

@interface DidRepaymentTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) UIImageView *statusIV;   //状态图标

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation DidRepaymentTableView

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
    
    self.titleArr = @[@"签约时间", @"合同编号", @"金额", @"期限", @"打款日", @"计息日", @"约定还款日", @"实际还款日", @"快速信审费", @"账户管理费", @"利息", @"服务费", @"优惠券减免", @"到期还款额", @"状态说明", @"续期次数"];
    
    NSString *signDate = [_order.signDatetime convertDate];
    
    NSString *code = _order.code;
    
    NSString *amount = [_order.amount convertToSimpleRealMoney];
    
    NSString *duration = [NSString stringWithFormat:@"%ld天", _order.duration];
    
    //打款日
    NSString *fkDate = [_order.fkDatetime convertDate];
    STRING_NIL_NULL(fkDate);
    
    //计息日
    NSString *jxDate = [_order.jxDatetime convertDate];
    STRING_NIL_NULL(jxDate);
    
    //约定还款日
    NSString *hkDate = [_order.hkDatetime convertDate];
    STRING_NIL_NULL(hkDate);
    
    //实际还款日
    NSString *realHkDatetime = [_order.realHkDatetime convertDate];
    STRING_NIL_NULL(realHkDatetime);
    
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
    
    //状态说明
    NSString *remark = _order.remark;
    STRING_NIL_NULL(remark);
    
    //续期次数
    NSString *renewalNum = [NSString stringWithFormat:@"%ld次", _order.renewalCount];
    STRING_NIL_NULL(renewalNum);
    
    self.contentArr = @[signDate, code, amount, duration, fkDate, jxDate, hkDate, realHkDatetime, xsAmount, glAmount, lxAmount, fwAmount, couponAmount, totalAmount, remark, renewalNum];
    
    self.statusIV.image = kImage(_order.imageStr);

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
    
    cell.rightLabel.textColor = indexPath.row == self.contentArr.count - 3 ? kAppCustomMainColor: kTextColor;

    cell.arrowHidden = indexPath.row == self.contentArr.count - 1 ? NO: YES;

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

@end
