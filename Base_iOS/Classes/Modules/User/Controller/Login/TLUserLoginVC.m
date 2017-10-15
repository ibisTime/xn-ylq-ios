//
//  TLUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserLoginVC.h"
#import "TLUserForgetPwdVC.h"
#import "WXApi.h"
#import "BindMobileVC.h"
#import "TLUserRegisterVC.h"

@interface TLUserLoginVC ()

@property (nonatomic,strong) AccountTf *phoneTf;
@property (nonatomic,strong) AccountTf *pwdTf;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@end

@implementation TLUserLoginVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"登录"];
    
    [self setLeftItem];
    
    [self setUpUI];
    
    [self setUpNotification];
    
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
    
    self.view.backgroundColor = kBackgroundColor;
        
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;

    UIView *bgView = [[UIView alloc] init];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(2*h + 1);
        make.width.mas_equalTo(w);
        
    }];
    
    //账号
    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    phoneTf.leftIconView.image = [UIImage imageNamed:@"用户名"];
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
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:22.5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.height.mas_equalTo(h);
        make.right.mas_equalTo(-btnMargin);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(40);
        
    }];
    
    
    //注册
    UIButton *regBtn = [UIButton buttonWithTitle:@"去注册" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(15);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:@"找回密码?" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(80);
        make.height.mas_lessThanOrEqualTo(15);
        
    }];
    
}

- (void)setUpNotification {

    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
    
}

#pragma mark - Events

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

- (void)findPwd {
    
    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goReg {
    
    TLUserRegisterVC *registerVC = [[TLUserRegisterVC alloc] init];
    
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
    http.parameters[@"kind"] = @"C";
    
    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //保存用户账号和密码
    [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
