//
//  SelectMoneyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/7.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SelectMoneyVC.h"

#import "NSAttributedString+add.h"
#import "UIView+Custom.h"
#import "NSString+Extension.h"

#import "TabbarViewController.h"
#import "SignContractVC.h"
#import "ManualAuditVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"

#import "CouponModel.h"
#import "ProductModel.h"

#import "PickerTextField.h"
#define kFirstMoney     500
#define kSecondMoney    1000
#define kFirstDay       7
#define kSecondDay      14

@interface SelectMoneyVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *btnArr;

@property (nonatomic, strong) PickerTextField *couponBtn;          //选择优惠券
@property (nonatomic, strong) UILabel *fastFeeLbl;          //快速信审费

@property (nonatomic, strong) UILabel *interestFeeLbl;      //利息

@property (nonatomic, strong) UILabel *accountManageFeeLbl; //账户管理费

@property (nonatomic, strong) UILabel *serviceFeeLbl;       //服务费

@property (nonatomic, strong) UILabel *resultLbl;           //总结

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *totalPriceLbl;       //总还款

@property (nonatomic, strong) UILabel *priceTextLbl;        //

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) NSArray <CouponModel *>*coupons;

@property (nonatomic, strong) ProductModel *good;

@property (nonatomic, strong) CouponModel *selectCoupon;

@end

@implementation SelectMoneyVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //获取优惠券列表
    [self requestCouponList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestGood];
}

#pragma mark - Init
- (void)initSubviews {

    self.money = kFirstMoney;
    
    self.day = kFirstDay;
    
    self.view.backgroundColor = kPaleGreyColor;
    
    NSArray *titleArr = @[@"借款金额", @"借款时长"];
    
    NSString *money = [NSString stringWithFormat:@"%@元", [_good.amount convertToSimpleRealMoney]];
    
    NSString *day = [NSString stringWithFormat:@"%ld天", _good.duration];
    
    NSArray *textArr = @[money, day];
    
    NSArray *imgArr = @[@"借款金额", @"借款时长"];
    
    CGFloat leftMargin = 15;

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, leftMargin, kScreenWidth - 2*leftMargin, 330)];
    
    contentView.backgroundColor = kWhiteColor;
    
    contentView.layer.cornerRadius = 5;
    contentView.clipsToBounds = YES;
    
    [self.view addSubview:contentView];
    
    CGFloat viewW = kScreenWidth - 2*leftMargin;
    
    CGFloat bgViewH = 150;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, bgViewH)];
    
    bgView.tag = 1000;
    
    [contentView addSubview:bgView];

    for (int i = 0; i < 2; i++) {
        
        UILabel *textLbl = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:13.0];
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        
        textLbl.frame = CGRectMake(0, 25, bgView.width, 20);
        
        textLbl.centerX = (1+2*i)*kScreenWidth/4.0;
        
        NSAttributedString *textAttrStr = [NSAttributedString getAttributedStringWithImgStr:imgArr[i] index:0 string:[NSString stringWithFormat:@" %@", titleArr[i]] labelHeight:textLbl.height];
        
        textLbl.attributedText = textAttrStr;
        
        [bgView addSubview:textLbl];
        
        CGFloat btnH = 22;
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[i] titleColor:kTextColor3 backgroundColor:kClearColor titleFont:21.0 cornerRadius:btnH/2.0];
        
        btn.frame = CGRectMake(0, textLbl.yy + 20, kWidth(100), btnH);
        
        btn.centerX = (1+2*i)*kScreenWidth/4.0;
        
        btn.tag = 1100 + (i + 1)*10 + i;
        
        [bgView addSubview:btn];
        
    }
    
    BaseWeakSelf;
    
    self.couponBtn = [[PickerTextField alloc] initWithFrame:CGRectMake(0, 110, 150, 40) leftTitle:@"" titleWidth:0 placeholder:@""];
    
    self.couponBtn.clearButtonMode = UITextFieldViewModeNever;
    
    self.couponBtn.text = @"请选择优惠券";
    
    self.couponBtn.didSelectBlock = ^(NSInteger index) {
        
        if (index == 0) {
            
            weakSelf.couponBtn.text = @"请选择优惠券";

            [weakSelf calculateMoneyWithCoupon:@(0)];
            
            weakSelf.selectCoupon = nil;
            
        } else {
        
            CouponModel *coupon = weakSelf.coupons[index - 1];
            
            weakSelf.couponBtn.text = [NSString stringWithFormat:@"%@元优惠券", [coupon.amount convertToSimpleRealMoney]];
            
            [weakSelf calculateMoneyWithCoupon:coupon.amount];
            
            weakSelf.selectCoupon = coupon;
            
        }
        
    };
    
    self.couponBtn.frame = CGRectMake(0, 110, 150, 40);
    
    self.couponBtn.centerX = bgView.width/2.0;
    
    self.couponBtn.textAlignment = NSTextAlignmentCenter;
    
    self.couponBtn.delegate = self;
    
    [self.couponBtn addTarget:self action:@selector(selectCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:self.couponBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, bgView.yy + 20, kScreenWidth - 60, 1)];
    
    lineView.backgroundColor = kLineColor;
    
//    [lineView drawDashLine:3 lineSpacing:1 lineColor:kLineColor];
    
    [contentView addSubview:lineView];
    
    self.contentView = contentView;
    
    [self initBottomView];
    
    [self startCalculatedPrice];
}

- (void)initBottomView {

    UIView *view = [self.view viewWithTag:1000];

    self.fastFeeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.fastFeeLbl.frame = CGRectMake(kWidth(30), view.yy + 50, 200, 20);
    
    [self.contentView addSubview:self.fastFeeLbl];
    
    self.accountManageFeeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.accountManageFeeLbl.frame = CGRectMake(kWidth(30), self.fastFeeLbl.yy  + 5, 200, 20);
    
    [self.contentView addSubview:self.accountManageFeeLbl];
    
    self.resultLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.resultLbl.frame = CGRectMake(kWidth(30), self.accountManageFeeLbl.yy  + 5, 250, 20);
    
    [self.contentView addSubview:self.resultLbl];
    
    self.interestFeeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    CGFloat interestX = kScreenWidth - 30 - kWidth(30) - 200;
    
    self.interestFeeLbl.frame = CGRectMake(interestX, view.yy + 50, 200, 20);
    
    self.interestFeeLbl.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.interestFeeLbl];
    
    self.serviceFeeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    CGFloat serviceX = kScreenWidth - 30 - kWidth(30) - 200;
    
    self.serviceFeeLbl.frame = CGRectMake(serviceX, self.interestFeeLbl.yy + 5, 200, 20);
    
    self.serviceFeeLbl.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.serviceFeeLbl];
    
    UILabel *priceTextLbl = [UILabel labelWithText:@"到期还款：" textColor:kTextColor textFont:18.0];
    
    [self.contentView addSubview:priceTextLbl];
    
    self.priceTextLbl = priceTextLbl;
    
    self.totalPriceLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:18.0];
    
    [self.contentView addSubview:self.totalPriceLbl];
    
    CGFloat nextBtnH = 45;
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:11.0];
    
    promptLbl.frame = CGRectMake(0, self.contentView.yy + 15, kScreenWidth, 16);
    
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    NSAttributedString *promptAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"禁止学生贷款" index:0 string:[NSString stringWithFormat:@" %@", @"本平台禁止学生借款"] labelHeight:promptLbl.height];
    
    promptLbl.attributedText = promptAttrStr;
    
    [self.view addSubview:promptLbl];
    
    NSString *btnTitle = _selectType == SelectGoodTypeAuth ? @"下一步": @"签约";
    
    UIButton *nextBtn = [UIButton buttonWithTitle:btnTitle titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:nextBtnH/2.0];
    
    nextBtn.frame = CGRectMake(15, promptLbl.yy + 30, kScreenWidth - 30, nextBtnH);
    
    [nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
    
}

#pragma mark - Events

- (void)startCalculatedPrice {

    self.fastFeeLbl.text = [NSString stringWithFormat:@"快速信审费：%@元", [_good.xsAmount convertToSimpleRealMoney]];
    
    self.accountManageFeeLbl.text = [NSString stringWithFormat:@"账户管理费：%@元", [_good.glAmount convertToSimpleRealMoney]];

    self.interestFeeLbl.text = [NSString stringWithFormat:@"利息：%@元", [_good.lxAmount convertToSimpleRealMoney]];

    self.serviceFeeLbl.text = [NSString stringWithFormat:@"服务费：%@元", [_good.fwAmount convertToSimpleRealMoney]];

    [self calculateMoneyWithCoupon:@(0)];
    
    self.priceTextLbl.frame = CGRectMake(100, self.resultLbl.yy + 20, 100, 20);
    
    NSString *money = [_good.amount convertToSimpleRealMoney];
    
    self.totalPriceLbl.frame = CGRectMake(self.priceTextLbl.xx, self.resultLbl.yy + 20, 150, 20);
    
    self.totalPriceLbl.text = [NSString stringWithFormat:@"%@元", money];
    
}

- (void)calculateMoneyWithCoupon:(NSNumber *)couponAmount {

    CGFloat totalMoney = [_good.amount doubleValue] - ([_good.xsAmount doubleValue] + [_good.lxAmount doubleValue] + [_good.fwAmount doubleValue] + [_good.glAmount doubleValue]) + [couponAmount doubleValue];
    
    NSString *resultStr = [NSString stringWithFormat:@"以上费用预先扣除，实到 %@元", [@(totalMoney) convertToSimpleRealMoney]];
    
    [self.resultLbl labelWithString:resultStr title:[NSString stringWithFormat:@"%@元", [@(totalMoney) convertToSimpleRealMoney]] font:Font(13.0) color:kAppCustomMainColor];
}

- (void)clickNext:(UIButton *)sender {
    
    
    
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:navi animated:YES completion:nil];
        
        return ;
    }
    
//    ZHRealNameAuthVC *authVC = [[ZHRealNameAuthVC alloc] init];
//    [authVC setAuthSuccess:^{
//
//        [self realNameAuthAfterAction];
//
//    }];
//    [self.navigationController pushViewController:authVC animated:YES];
    
    
//    if (_selectType == SelectGoodTypeAuth) {
//
//        TLNetworking *http = [TLNetworking new];
//
//        http.showView = self.view;
//        http.code = @"623020";
//        http.parameters[@"applyUser"] = [TLUser user].userId;
//        http.parameters[@"productCode"] = _good.code;
//
//        [http postWithSuccess:^(id responseObject) {
//
//            NSString *status = responseObject[@"data"][@"status"];
//
//            if ([status isEqualToString:@"1"]) {
//
//                [TLAlert alertWithTitle:@"" message:@"您的信息未认证，请先完成认证" confirmMsg:@"OK" confirmAction:^{
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                        TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
//
//                        tabbarVC.currentIndex = 1;
//
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    });
//                }];
//
//            } else if ([status isEqualToString:@"2"]) {
//
//                ManualAuditVC *auditVC = [ManualAuditVC new];
//
//                auditVC.title = @"系统审核";
//
//                [self.navigationController pushViewController:auditVC animated:YES];
//            }
//
//        } failure:^(NSError *error) {
//
//
//        }];
//
//    } else if(_selectType == SelectGoodTypeSign) {
    
        SignContractVC *signContractVC = [SignContractVC new];
        
        signContractVC.good = self.good;
        
        signContractVC.coupon = self.selectCoupon;
        
        [self.navigationController pushViewController:signContractVC animated:YES];
//    }
    
}

- (void)selectCoupon:(UITapGestureRecognizer *)sender {
    
    if (self.coupons.count == 0) {
        
        [TLAlert alertWithInfo:@"暂无可使用优惠券"];

    }
}

#pragma mark - Data
- (void)requestCouponList {

    if (![TLUser user].isLogin) {
        
        return ;
    }
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"623148";
    helper.isList = YES;
    
    helper.parameters[@"amount"] = [NSString stringWithFormat:@"%lld", [_good.amount longLongValue]];
    
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    [helper modelClass:[CouponModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.coupons = objs;
        //有无优惠券
        if (self.coupons.count == 0) {
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCoupon:)];
            
            [self.couponBtn addGestureRecognizer:tapGR];
            
        } else {
        
            NSMutableArray *titleArr = [NSMutableArray array];
            
            [titleArr addObject:@"请选择优惠券"];
            
            for (CouponModel *coupon in self.coupons) {
                
                NSString *time = [coupon.invalidDatetime convertDate];
                
                NSString *title = [NSString stringWithFormat:@"减免%@元 %@到期", [coupon.amount convertToSimpleRealMoney], time];
                
                [titleArr addObject:title];
            }
            
            self.couponBtn.tagNames = titleArr;
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGood {

    NSString *code = _selectType == SelectGoodTypeAuth ? @"623011": @"623013";
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = code;
    
    if (_selectType == SelectGoodTypeAuth) {
        
        http.parameters[@"code"] = self.code;

    } else if (_selectType == SelectGoodTypeSign){
    
        http.parameters[@"userId"] = [TLUser user].userId;

    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.good = [ProductModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];
        
        //获取优惠券列表
        [self requestCouponList];

    } failure:^(NSError *error) {
        
        
    }];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:navi animated:YES completion:nil];
        
        return NO;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
