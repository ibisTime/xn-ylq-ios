//
//  BaseUserLoginVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseUserLoginVC.h"
#import "BaseUserForgetPwdVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "BindMobileVC.h"
#import "BaseUserRegisterVC.h"

@interface BaseUserLoginVC ()

@property (nonatomic,strong) AccountTf *phoneTf;
@property (nonatomic,strong) AccountTf *pwdTf;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@end

@implementation BaseUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"登录"];
    
    [self setLeftItem];
    
    [self setUpUI];
    
    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxResp:) name:LOGIN_WX_NOTIFICATION object:nil];
}

- (void)setLeftItem {
    
    //取消按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 30, 16, 16);
    [closeBtn setImage:[UIImage imageNamed:kCancelIcon] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
}

- (void)setUpUI {
    
    self.view.backgroundColor = kWhiteColor;
    
    //    UIScrollView *bgSV = self.bgSV;
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    
    iconIV.image = [UIImage imageNamed:@"icon"];
    
    iconIV.layer.cornerRadius = 5;
    iconIV.clipsToBounds = YES;
    
    [self.view addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.width.height.mas_equalTo(66);
        
    }];
    
    CGFloat margin = 35;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = 40;
    
    UIView *bgView = [[UIView alloc] init];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(iconIV.mas_bottom).mas_equalTo(52);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(2*h + 1);
        make.width.mas_equalTo(w);
        
    }];
    
    //账号
    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机"];
    phoneTf.placeHolder = @"请输入手机号码";
    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //密码
    AccountTf *pwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.placeHolder = @"请输入密码";
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    for (int i = 0; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = [UIColor lineColor];
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo((i+1)*h);
            
        }];
    }
    //登录
    
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:22];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(h + 4);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(45);
        
    }];
    
    
    //注册
    UIButton *regBtn = [UIButton buttonWithTitle:@"新用户注册" titleColor:[UIColor colorWithHexString:@"#666666"] backgroundColor:kClearColor titleFont:14.0];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(38);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(15);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:@"忘记密码" titleColor:[UIColor colorWithHexString:@"#666666"] backgroundColor:kClearColor titleFont:14.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(80);
        make.height.mas_lessThanOrEqualTo(15);
        
    }];
    
}

- (void)back {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

//登录成功
- (void)login {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginSuccess) {
        self.loginSuccess();
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)findPwd {
    
    BaseUserForgetPwdVC *vc = [[BaseUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)goReg {
    
    BaseUserRegisterVC *registerVC = [[BaseUserRegisterVC alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)goLogin {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = @"f1";

    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        //保存用户信息
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        [[TLUser user] saveToken:token];
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
