//
//  SignContractVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SignContractVC.h"
#import "LoanVC.h"
#import "HTMLStrVC.h"

@interface SignContractVC ()

@end

@implementation SignContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签约";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    [self.bgSV addSubview:topView];
    
    UILabel *textLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:18];
    
    textLbl.frame = CGRectMake(0, 0, 150, 18);
    
    textLbl.center = topView.center;
    
    NSAttributedString *textArrt = [NSAttributedString getAttributedStringWithImgStr:@"logo" index:0 string:[NSString stringWithFormat:@"  %@", @"借款协议"] labelHeight:textLbl.height];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.attributedText = textArrt;
    
    [topView addSubview:textLbl];
    
    NSArray *textArr = @[@"借款人:", @"借款金额:", @"借款时限:", @"综合费用:", @"实到金额:", @"还款方案:", @"逾期政策:"];
    //借款人
    NSString *realName = [TLUser user].realName;
    //借款金额
    NSString *money = [NSString stringWithFormat:@"%@元", [_good.amount convertToSimpleRealMoney]];
    //借款时限
    NSString *day = [NSString stringWithFormat:@"%ld天", _good.duration];
    //综合费用
    CGFloat totalMoney =[_good.xsAmount doubleValue] + [_good.lxAmount doubleValue] + [_good.fwAmount doubleValue] + [_good.glAmount doubleValue];

    NSString *total = [NSString stringWithFormat:@"%@元", [@(totalMoney) convertToSimpleRealMoney]];
    
    CGFloat couponFee = _coupon ? [_coupon.amount doubleValue]: 0;
    //实到金额=总额-综合费用+优惠券金额
    CGFloat effectAmount = [_good.amount doubleValue] - totalMoney + couponFee;
    
    NSString *effectAmountStr = [NSString stringWithFormat:@"%@元", [@(effectAmount) convertToSimpleRealMoney]];
    //还款方案
    NSString *plan = [NSString stringWithFormat:@"一次性还款%@元", [_good.amount convertToSimpleRealMoney]];
//    //还款日期
//    NSDate *currentDate = [NSDate date];
//    
//    NSDate *repaymentDate = [currentDate dateByAddingTimeInterval:7*24*60*60];
//    
//    NSString *repaymentDateStr = [NSString stringFromDate:repaymentDate formatter:@"yyyy年M月d日"];
    //逾期政策
    CGFloat yqAmount1 = [_good.yqRate1 doubleValue]*[_good.amount doubleValue];
    
    CGFloat yqAmount2 = [_good.yqRate2 doubleValue]*[_good.amount doubleValue];
    
    NSString *yqStr = [NSString stringWithFormat:@"7天内逾期, %@元每天\n7天后逾期, %@元每天", [@(yqAmount1) convertToSimpleRealMoney], [@(yqAmount2) convertToSimpleRealMoney]];
    
    NSArray *contentArr = @[realName, money, day, total, effectAmountStr, plan, yqStr];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.yy, kScreenWidth, 330)];
    
    contentView.backgroundColor = kWhiteColor;
    
    [self.bgSV addSubview:contentView];
    
    for (int i = 0; i < textArr.count; i++) {
        
        UILabel *titleLbl = [UILabel labelWithText:textArr[i] textColor:kTextColor2 textFont:14];
        
        titleLbl.frame = CGRectMake(kWidth(85), 24 + i*(14+22), 70, 14);
        
        [contentView addSubview:titleLbl];
        
        UILabel *contentLbl = [UILabel labelWithText:contentArr[i] textColor:kTextColor textFont:14];
        
        contentLbl.numberOfLines = 0;
        
        CGFloat contentH = i == textArr.count - 1 ? 35: 14;
        
        contentLbl.frame = CGRectMake(titleLbl.xx + 20, 24 + i*(14+22), 200, contentH);
        
        [contentView addSubview:contentLbl];
        
    }
    
    //借款协议
    UIButton *selectBtn = [UIButton buttonWithImageName:@"同意" selectedImageName:@"未同意"];
    
    selectBtn.tag = 1250;
    
    selectBtn.frame = CGRectMake(kWidth(100), contentView.yy + kWidth(30), 14, 14);
    
    [selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:selectBtn];
    
    UILabel *agreeLbl = [UILabel labelWithText:@"我同意" textColor:kTextColor textFont:12];
    
    agreeLbl.frame = CGRectMake(selectBtn.xx + 7, selectBtn.y, 40, 12);
    
    [self.bgSV addSubview:agreeLbl];
    
    UIButton *agreeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"《%@-借款协议》", [TLUser user].realName] titleColor:[UIColor colorWithHexString:@"#4385b3"] backgroundColor:kClearColor titleFont:12];

//    agreeBtn.frame = CGRectMake(agreeLbl.xx, agreeLbl.y, 200, 12);
    
    [agreeBtn setEnlargeEdge:10];
    
    [agreeBtn addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(agreeLbl.xx);
        make.top.mas_equalTo(agreeLbl.y);
        
    }];
    //确认借款
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认借款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    confirmBtn.frame = CGRectMake(15, agreeLbl.yy + kWidth(30), kScreenWidth - 30, 45);
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:confirmBtn];
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, confirmBtn.yy + kWidth(30));
    
}

#pragma mark - Events
- (void)clickSelect:(UIButton *)sender {

    sender.selected = !sender.selected;
    
}

- (void)agreement {

    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeBorrowProtocol;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}
//签约
- (void)confirm {

    UIButton *btn = [self.view viewWithTag:1250];
    
    if (btn.selected) {
        
        [TLAlert alertWithInfo:@"同意借款协议才能签约"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623070";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"couponId"] = self.coupon.couponId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"签约成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            LoanVC *loanVC = [LoanVC new];
            
            [self.navigationController pushViewController:loanVC animated:YES];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
