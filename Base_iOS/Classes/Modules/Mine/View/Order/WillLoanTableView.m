//
//  WillLoanTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "WillLoanTableView.h"
#import "LoanOrderDetailCell.h"

@interface WillLoanTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *quotaLbl;    //额度

@property (nonatomic, strong) UIImageView *statusIV;   //状态图标

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation WillLoanTableView

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
    
    CGFloat headH = [self.order.status isEqualToString:@"1"] ? 160: 125;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headH)];
    
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
    
    if ([self.order.status isEqualToString:@"0"] || [self.order.status isEqualToString:@"1"]) {
        
        UILabel *remarkLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:15];
        
        remarkLbl.frame = CGRectMake(0, self.quotaLbl.yy + 20, 150, 16);
        
        remarkLbl.textAlignment = NSTextAlignmentCenter;
        
        remarkLbl.centerX = centerX;
        
        NSAttributedString *promptAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"款项在路上" index:0 string:[NSString stringWithFormat:@" %@", @"款项已经在路上"] labelHeight:remarkLbl.height];
        
        remarkLbl.attributedText = promptAttrStr;
        
        [headerView addSubview:remarkLbl];
    }
    
    self.tableHeaderView = headerView;
    
    self.tableFooterView = [UIView new];
}

- (void)initFooterView {

    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    UIButton *reCommitBtn = [UIButton buttonWithTitle:@"重新提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    reCommitBtn.frame = CGRectMake(leftMargin, 50, kScreenWidth - 2*leftMargin, btnH);
    
    [reCommitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:reCommitBtn];
    
    self.tableFooterView = footerView;

}

#pragma mark - Setting
- (void)setOrder:(OrderModel *)order {

    _order = order;
    
    self.titleArr = @[@"签约时间", @"合同编号", @"金额", @"期限", @"状态说明"];
    //签约时间
    NSString *signDate = [_order.signDatetime convertDate];
    //合同编号
    NSString *code = _order.code;
    //金额
    NSString *amount = [_order.amount convertToSimpleRealMoney];
    //期限
    NSString *duration = [NSString stringWithFormat:@"%ld天", _order.duration];
    //状态说明
    NSString *remark = [_order.status isEqualToString:@"2"] ? _order.approveNote: _order.remark;
    
    self.contentArr = @[signDate, code, amount, duration, remark];
    
    self.statusIV.image = kImage(_order.imageStr);
    
    self.quotaLbl.text = [_order.amount convertToSimpleRealMoney];
    
    if ([_order.status isEqualToString:@"7"]) {
        
        [self initFooterView];

    }
}

#pragma mark - Events
- (void)clickCommit {

    if (_commitBlock) {
        
        _commitBlock();
    }
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


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

@end
