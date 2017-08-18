//
//  BankCardAuthResultVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/2.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BankCardAuthResultVC.h"

@interface BankCardAuthResultVC ()

@property (nonatomic, strong) TLTextField *realNameTF;    //真实姓名

@property (nonatomic, strong) TLTextField *idCardTF;      //身份证

@property (nonatomic, strong) TLTextField *bankCardTF;    //银行卡

@property (nonatomic, strong) TLTextField *mobileTF;      //预留手机号

@end

@implementation BankCardAuthResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];
    
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat imageW = kWidth(60);
    
    NSString *result = self.result ? @"认证成功": @"认证失败";
    
    NSString *resultStr = self.result ? @"认证成功": @"认证失败";
    
    UIImageView *resultIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWidth(35), imageW, imageW)];
    
    resultIV.image = [UIImage imageNamed:result];
    
    resultIV.layer.cornerRadius = imageW/2.0;
    
    resultIV.clipsToBounds = YES;
    
    resultIV.centerX = self.view.centerX;
    
    [self.view addSubview:resultIV];
    
    UILabel *promptLabel = [UILabel labelWithText:resultStr textColor:[UIColor textColor] textFont:15.0];
    
    promptLabel.frame = CGRectMake(0, resultIV.yy + kWidth(20), kScreenWidth, 16);
    
    promptLabel.backgroundColor = kClearColor;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:promptLabel];
    
    promptLabel.text = self.result ? result:self.failureReason;
    
    self.realNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, promptLabel.yy + kWidth(35), kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@"请输入姓名"];
    
    self.realNameTF.text = self.realName;
    
    self.realNameTF.enabled = NO;
    
    [self.view addSubview:self.realNameTF];
    
    self.idCardTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realNameTF.yy, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@"请输入身份证号码"];
    
    self.idCardTF.text = self.idCard;
    
    self.idCardTF.enabled = NO;
    
    [self.view addSubview:self.idCardTF];
    
    self.bankCardTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.idCardTF.yy, kScreenWidth, 50) leftTitle:@"银行卡号" titleWidth:105 placeholder:@"请输入银行卡号"];
    
    self.bankCardTF.text = self.bankCardId;
    
    self.bankCardTF.enabled = NO;
    
    [self.view addSubview:self.bankCardTF];
    
    if (self.mobile.length > 0) {
        
        self.mobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.bankCardTF.yy, kScreenWidth, 50) leftTitle:@"手机号" titleWidth:105 placeholder:@"请输入银行预留手机号(选填)"];
        
        self.mobileTF.text = self.mobile;
        
        self.mobileTF.enabled = NO;
        
        [self.view addSubview:self.mobileTF];
    }

}

#pragma mark - Events

- (void)back {
    
    if (self.result) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
