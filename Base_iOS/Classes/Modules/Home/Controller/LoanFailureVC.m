//
//  LoanFailureVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanFailureVC.h"

#import "GoodView.h"
#import "GoodModel.h"

#import "SelectMoneyVC.h"

@interface LoanFailureVC ()

@property (nonatomic, strong) GoodView *goodView;

@property (nonatomic, strong) UILabel *resultLbl;

@end

@implementation LoanFailureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请失败";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    
    topView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:topView];
    
    CGFloat leftMargin = 15;
    
    CGFloat topMargin = 10;
    
    CGFloat viewW = kScreenWidth - 2*leftMargin;
    
    CGFloat viewH = 125;
    
    GoodView *goodView = [[GoodView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, viewW, viewH)];

    goodView.goodModel = self.good;
    
    goodView.isCancel = YES;
    
    [topView addSubview:goodView];
    
    UILabel *textLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, goodView.yy + 25, kScreenWidth, 22);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    NSAttributedString *textAttr = [NSAttributedString getAttributedStringWithImgStr:@"失败" index:0 string:[NSString stringWithFormat:@"  %@", @"申请失败, 原因："] labelHeight:textLbl.height];
    
    textLbl.attributedText = textAttr;
    
    [topView addSubview:textLbl];
    
    self.resultLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:18];
    
    self.resultLbl.numberOfLines = 0;
    
    NSString *result = @"系统审核，请保证填写的资料为本人真实资料,如需再次申请，请7天后再提交审核";
    
    CGSize contentSize = [result calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:Font(18.0)];
    
//    [self.resultLbl labelWithTextString:_good.approveNote lineSpace:10];
    
    self.resultLbl.text = result;
    
    self.resultLbl.frame = CGRectMake(15, textLbl.yy + 25, kScreenWidth - 30, contentSize.height);
    
    self.resultLbl.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:self.resultLbl];
    
    topView.height = 250 - 18 + contentSize.height;

    UIButton *reApplication = [UIButton buttonWithTitle:@"重新申请" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    reApplication.frame = CGRectMake(15, topView.yy + 54, kScreenWidth - 30, 45);
    
    [reApplication addTarget:self action:@selector(clickReApplication) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reApplication];
}

#pragma mark - Events
- (void)clickReApplication {

    SelectMoneyVC *moneyVC = [SelectMoneyVC new];
    
    moneyVC.title = @"产品详情";
    
    moneyVC.selectType = SelectGoodTypeAuth;
    
    moneyVC.code = self.good.code;

    [self.navigationController pushViewController:moneyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
