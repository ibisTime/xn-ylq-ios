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
        
        [self initHeaderView];

    }
    return self;
}

- (void)initHeaderView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    
    headerView.backgroundColor = kWhiteColor;
    
    CGFloat centerX = kScreenWidth /2.0;

    UIImageView *statusIV = [[UIImageView alloc] initWithImage:kImage(@"待放款")];
    
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
    
    UILabel *remarkLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:15];
    
    remarkLbl.frame = CGRectMake(0, self.quotaLbl.yy + 20, 150, 16);
    
    remarkLbl.textAlignment = NSTextAlignmentCenter;
    
    remarkLbl.centerX = centerX;
    
    NSAttributedString *promptAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"款项在路上" index:0 string:[NSString stringWithFormat:@" %@", @"款项已经在路上"]];

    remarkLbl.attributedText = promptAttrStr;
    
    [headerView addSubview:remarkLbl];
    
    self.tableHeaderView = headerView;
    
    self.tableFooterView = [UIView new];
}

- (void)setOrder:(OrderModel *)order {

    _order = order;
    
    self.titleArr = @[@"签约时间", @"合同编号", @"金额", @"期限", @"状态说明"];

    NSString *signDate = [_order.signDatetime convertDate];
    
    NSString *code = _order.code;
    
    NSString *amount = [_order.amount convertToSimpleRealMoney];
    
    NSString *duration = [NSString stringWithFormat:@"%ld", _order.duration];
    
    NSString *remark = _order.remark;
    
    self.contentArr = @[signDate, code, amount, duration, remark];
    
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


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

@end
