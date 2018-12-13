//
//  SignContractVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SignContractVC.h"

#import "LoanVC.h"
#import "ZHBankCardAddVC.h"

#import "LoanProtocolVC.h"
#import "ZHBankCardAddVC.h"
#import "ZHBankCardListVC.h"
@interface SignContractVC ()

@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;

@end

@implementation SignContractVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([[TLUser user].bankcardFlag isEqualToString:@"0"]) {
        
     
        
    } else if ([[TLUser user].bankcardFlag isEqualToString:@"1"]) {
        
        [self requestBankCard];
        
    }
        
    
}

-(void)setCore
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623024";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"creditScore"] = @"2000000";
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithSucces:@"设置成功"];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"借款";
    
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
    STRING_NIL_NULL(realName);
    
    //借款金额
    NSString *money = [NSString stringWithFormat:@"%@元", [_good.amount convertToSimpleRealMoney]];
    STRING_NIL_NULL(money);
    
    //借款时限
    NSString *day = [NSString stringWithFormat:@"%ld天", _good.duration];
    STRING_NIL_NULL(day);
    
    //综合费用
    CGFloat totalMoney =[_good.xsAmount doubleValue] + [_good.lxAmount doubleValue] + [_good.fwAmount doubleValue] + [_good.glAmount doubleValue];
    
    NSString *total = [NSString stringWithFormat:@"%@元", [@(totalMoney) convertToSimpleRealMoney]];
    STRING_NIL_NULL(total);
    
    CGFloat couponFee = _coupon ? [_coupon.amount doubleValue]: 0;
    //实到金额=总额-综合费用+优惠券金额
    CGFloat effectAmount = [_good.amount doubleValue] - totalMoney + couponFee;
    
    NSString *effectAmountStr = [NSString stringWithFormat:@"%@元", [@(effectAmount) convertToSimpleRealMoney]];
    STRING_NIL_NULL(effectAmountStr);
    
    //还款方案
    NSString *plan = [NSString stringWithFormat:@"一次性还款%@元", [_good.amount convertToSimpleRealMoney]];
    STRING_NIL_NULL(plan);
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
    
    STRING_NIL_NULL(yqStr);
    
    NSArray *contentArr = @[realName, money, day, total, effectAmountStr, plan, yqStr];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.yy, kScreenWidth, 350)];
    
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
//    UIButton *selectBtn = [UIButton buttonWithImageName:@"同意" selectedImageName:@"未同意"];
//
//    selectBtn.tag = 1250;
//
//    selectBtn.frame = CGRectMake(kWidth(100), contentView.yy + kWidth(30), 14, 14);
//
//    [selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.bgSV addSubview:selectBtn];
//
//    UILabel *agreeLbl = [UILabel labelWithText:@"我同意" textColor:kTextColor textFont:12];
//
//    agreeLbl.frame = CGRectMake(selectBtn.xx + 7, selectBtn.y, 40, 12);
//
//    [self.bgSV addSubview:agreeLbl];
//
//    UIButton *agreeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"《%@-借款协议》", [TLUser user].realName] titleColor:[UIColor colorWithHexString:@"#4385b3"] backgroundColor:kClearColor titleFont:12];
//
//    //    agreeBtn.frame = CGRectMake(agreeLbl.xx, agreeLbl.y, 200, 12);
//
//    [agreeBtn setEnlargeEdge:10];
//
//    [agreeBtn addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.bgSV addSubview:agreeBtn];
//    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.mas_lessThanOrEqualTo(200);
//        make.height.mas_equalTo(12);
//        make.left.mas_equalTo(agreeLbl.xx);
//        make.top.mas_equalTo(agreeLbl.y);
//
//    }];
    //确认借款
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认借款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    confirmBtn.frame = CGRectMake(15, contentView.yy, kScreenWidth - 30, 45);
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:confirmBtn];
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, confirmBtn.yy + kWidth(30));
    
}

#pragma mark - Events
- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)agreement {
    
    LoanProtocolVC *loanProtocolVC = [LoanProtocolVC new];
    
    loanProtocolVC.coupon = self.coupon;
    
    [self.navigationController pushViewController:loanProtocolVC animated:YES];
}



//签约
- (void)confirm {
    
    //判断是否绑定银行卡，是就进入放款中，否就绑定银行卡
    if ([[TLUser user].bankcardFlag isEqualToString:@"1"]) {
        BaseWeakSelf;
        TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
        pageDataHelper.code = @"802025";
        pageDataHelper.parameters[@"token"] = [TLUser user].token;
        pageDataHelper.parameters[@"userId"] = [TLUser user].userId;
        [pageDataHelper modelClass:[ZHBankCard class]];
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            ZHBankCard *bankCard = self.banks[0];
            
            [TLAlert alertWithTitle:@"请确认银行卡信息是否正确" msg:[NSString stringWithFormat:@"户名: %@\n开户行: %@\n银行卡号: %@", bankCard.realName, bankCard.bankName, bankCard.bankcardNumber] confirmMsg:@"确定" cancleMsg:@"修改" cancle:^(UIAlertAction *action) {
                
                ZHBankCardAddVC *bankCardVC = [ZHBankCardAddVC new];
                
                bankCardVC.bankCard = bankCard;
                
                [self.navigationController pushViewController:bankCardVC animated:YES];
                
            } confirm:^(UIAlertAction *action) {
                
                UIButton *btn = [self.view viewWithTag:1250];
                
                if (btn.selected) {
                    
                    [TLAlert alertWithInfo:@"同意借款协议才能借款"];
                    return ;
                }
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"623070";
                http.parameters[@"userId"] = [TLUser user].userId;
                http.parameters[@"productCode"] = self.good.code;
                if (self.coupon.couponId.length>0) {
                    http.parameters[@"couponId"] = self.coupon.couponId;
                    
                }
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"借款成功"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        LoanVC *loanVC = [LoanVC new];
                        
                        loanVC.borrowCode = responseObject[@"data"][@"code"];
                        
                        [self.navigationController pushViewController:loanVC animated:YES];
                        
                    });
                    
                } failure:^(NSError *error) {
                    
                    
                }];
            }];
            
            return ;
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
      
    }else{
        [TLAlert alertWithTitle:@"提示！" message:@"您还没有银行卡,请先绑定银行卡" confirmAction:^(UIAlertAction *action) {
            ZHBankCardListVC *bankCardAddVC= [[ZHBankCardListVC alloc] init];
            [self requestBankCard];
            
            [self.navigationController pushViewController:bankCardAddVC animated:YES];
        }];
        
      
        
    }
    
    
}

#pragma mark - Data
- (void)requestBankCard {
    
    BaseWeakSelf;
    
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802025";
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"userId"] = [TLUser user].userId;
    [pageDataHelper modelClass:[ZHBankCard class]];
    [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.banks = objs;
    
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
