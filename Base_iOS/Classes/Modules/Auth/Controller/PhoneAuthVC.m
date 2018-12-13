//
//  PhoneAuthVC.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/11/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#define ACCOUNT_MARGIN 0;
#define ACCOUNT_HEIGHT 45;
#define ACCOUNT_MIDDLE_MARGIN 0;
#import "PhoneAuthVC.h"
#import "TLTextField.h"
#import "TLCaptchaView.h"
#import "AccountTf.h"
@interface PhoneAuthVC ()
@property (nonatomic,strong) TLTextField *realName;

@property (nonatomic, strong) TLCaptchaView *captchaView;
@end

@implementation PhoneAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    CGFloat btnMargin = 15;
    //账号
    TLTextField *realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"手机号" titleWidth:100 placeholder:@"请输入手机号"];
    [self.view addSubview:realName];
    self.realName = realName;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, realName.yy + 1, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor zh_lineColor];
    [self.view addSubview:line];
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(realName.x, realName.yy + 1, realName.width, realName.height)];
    [self.view addSubview:captchaView];
    self.captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:22];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(30, realName.yy+100, kScreenWidth-60, 45);
//    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(btnMargin);
//        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
//        make.height.mas_equalTo(h);
//        make.top.mas_equalTo(self.view.mas_top).offset(140);
//
//    }];
    // Do any additional setup after loading the view.
}

- (void)changePwd
{
    
    
}
#pragma mark - Events
- (void)sendCaptcha {
    
    if (![self.realName.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.realName.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}



@end
