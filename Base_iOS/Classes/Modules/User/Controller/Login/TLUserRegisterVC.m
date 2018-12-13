//
//  TLUserRegisterVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLUserRegisterVC.h"
//#import "SGScanningQRCodeVC.h"
#import <Photos/Photos.h>
#import "NavigationController.h"
#import "HTMLStrVC.h"

#import <CoreLocation/CoreLocation.h>

#import "CaptchaView.h"
#import "PickerTextField.h"
#import "AddressPickerView.h"

@interface TLUserRegisterVC ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CaptchaView *captchaView;

@property (nonatomic,strong) AccountTf *phoneTf;

@property (nonatomic,strong) AccountTf *pwdTf;

@property (nonatomic,strong) AccountTf *referrer;

@property (nonatomic,strong) PickerTextField *referrerType;

@property (nonatomic, strong) AccountTf *addressTf;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,strong) AddressPickerView *addressPicker;

@property (nonatomic,strong) UIButton *selectBtn;
//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic, copy) NSString *address;  //详细地址

@end

@implementation TLUserRegisterVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"注册"];
    
    [TLProgressHUD show];
    
    if (![TLAuthHelper isEnableLocation]) {
        
        // 请求定位授权
        [self.sysLocationManager requestWhenInUseAuthorization];
        
        [self setUpUI];
        
        [TLAlert alertWithTitle:@"" msg:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [TLAuthHelper openSetting];
            
        }];
        
        return;
        
    }
    
    [self.sysLocationManager startUpdatingLocation];
}

#pragma mark - Events

- (void)setUpUI {
    
    [TLProgressHUD dismiss];
    
    self.view.backgroundColor = kBackgroundColor;

    NSInteger count = 4;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    CGFloat btnMargin = 15;
    
    UIView *bgView = [[UIView alloc] init];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(count*h + 1);
        make.width.mas_equalTo(w);
        
    }];

    //账号
    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    phoneTf.placeHolder = @"请输入手机号";
    phoneTf.leftIconView.image = [UIImage imageNamed:@"用户名"];
    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, phoneTf.yy + middleMargin, w, h)];
    [bgView addSubview:captchaView];
    captchaView.captchaTf.leftIconView.image = [UIImage imageNamed:@"验证码"];
    captchaView.captchaTf.placeHolder = @"请输入验证码";
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.captchaView = captchaView;
    
    //密码
    AccountTf *pwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, captchaView.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.placeHolder = @"请输入密码";
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    AccountTf *addressTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, pwdTf.yy + middleMargin, w, h)];
    addressTf.placeHolder = @"当前位置-自动定位";
    addressTf.leftIconView.image = [UIImage imageNamed:@"定位"];
    addressTf.enabled = NO;
//    addressTf.hidden = YES;

    [bgView addSubview:addressTf];
    self.addressTf = addressTf;
    
    for (int i = 0; i < count; i++) {
        
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
    
    //注册
    UIButton *regBtn = [UIButton buttonWithTitle:@"立即注册" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:22.5];
    
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(35);
        
    }];
    
//    UILabel *protocalLbl = [[UILabel alloc] initWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(12.0) textColor:kAppCustomMainColor];
//    
//    protocalLbl.text = @"注册即代表同意";
//    
//    [self.bgSV addSubview:protocalLbl];
//    
//    [protocalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(btnMargin);
//        make.width.mas_lessThanOrEqualTo(90);
//        make.height.mas_equalTo(30);
//        make.top.mas_equalTo(regBtn.mas_bottom).mas_equalTo(15);
//        
//    }];
    
    //协议按钮
//    UIButton *protocalBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin,regBtn.yy + 10, w, 25) title:@"《信息收集及使用规则》" backgroundColor:[UIColor clearColor]];
//    protocalBtn.titleLabel.font = FONT(12);
//    [protocalBtn addTarget:self action:@selector(collectRule) forControlEvents:UIControlEventTouchUpInside];
//    protocalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [protocalBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
//
//    [protocalBtn setEnlargeEdgeWithTop:10 right:0 bottom:0 left:0];
//
//    [self.bgSV addSubview:protocalBtn];
//
//    [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(protocalLbl.mas_right).mas_equalTo(0);
//        make.width.mas_lessThanOrEqualTo(140);
//        make.height.mas_lessThanOrEqualTo(13);
//        make.top.mas_equalTo(regBtn.mas_bottom).mas_equalTo(13);
//
//    }];
    
        UIButton *selectBtn = [UIButton buttonWithImageName:@"同意" selectedImageName:@"未同意"];
        self.selectBtn = selectBtn;
        selectBtn.tag = 1250;
    
        selectBtn.frame = CGRectMake(kWidth(100), regBtn.yy + kWidth(30), 14, 14);
    
        [selectBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.bgSV addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.mas_equalTo(regBtn.mas_left).mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(14);
            make.height.mas_lessThanOrEqualTo(14);
            make.top.mas_equalTo(regBtn.mas_bottom).mas_equalTo(20);
        
        }];
    
    //信息收集及使用规则
    UIButton *collectRuleBtn = [[UIButton alloc] initWithFrame:CGRectMake(selectBtn.xx+20,regBtn.yy + 20, w, 25) title:@"《借款服务与隐私协议》" backgroundColor:[UIColor clearColor]];
    collectRuleBtn.titleLabel.font = Font(12);
    [collectRuleBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
    collectRuleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [collectRuleBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
    
    [collectRuleBtn setEnlargeEdgeWithTop:0 right:0 bottom:10 left:0];
    [self.bgSV addSubview:collectRuleBtn];
    
    [collectRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(selectBtn.mas_right).mas_offset(20);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_lessThanOrEqualTo(13);
        make.top.mas_equalTo(regBtn.mas_bottom).mas_equalTo(20);
        
    }];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:self.addressTf.frame];
//    
//    [bgView addSubview:btn];
//    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //定位成功 隐藏地址选择
    if (self.province && self.city && self.area) {
        
        //        self.addressTf.height = 0.1;
        self.addressTf.text = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area];
        
    }
}

-(void)clickSelect:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
}

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
            weakSelf.addressTf.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 50.0;
        
    }
    return _sysLocationManager;
    
}

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    [self setUpUI];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    CLLocation *location = manager.location;
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        if (error) {
            
            
        } else {
            
            self.province = placemark.administrativeArea ;
            self.city = placemark.locality ? : placemark.administrativeArea; //市
            self.area = placemark.subLocality; //区
            
            //道路
            NSString *road = placemark.thoroughfare;
            STRING_NIL_NULL(road);
            //具体地方
            NSString *building = placemark.name;
            STRING_NIL_NULL(building);
            //详细地址
            self.address = [NSString stringWithFormat:@"%@%@", road,building];
        }
        
        [self setUpUI];
        
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.sysLocationManager startUpdatingLocation];
        
    }
}

#pragma mark - Events

//--//
- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        return;
    }
    
            //发送验证码
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = CAPTCHA_CODE;
            http.parameters[@"bizType"] = USER_REG_CODE;
            http.parameters[@"mobile"] = self.phoneTf.text;
            http.parameters[@"kind"] = @"C";
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
                
                [self.captchaView.captchaBtn begin];
                
            } failure:^(NSError *error) {
                
                [TLAlert alertWithError:@"发送失败,请检查手机号"];
                
            }];

    

    
}

- (void)goReg {
    
    if (self.selectBtn.selected == YES) {
        [TLAlert alertWithInfo:@"请先同意借款协议"];
        return;
    }
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
  
//    if ([self.addressTf.text valid]) {
//        
//        if (!(self.province && self.city && self.area)) {
//            
//            [TLAlert alertWithInfo:@"请选择省市区"];
//            return;
//        }
//    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INVITE_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"loginPwdStrength"] = @"2";
    http.parameters[@"isRegHx"] = @"0";
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"kind"] = @"C";
    
    http.parameters[@"province"] = self.province;
    http.parameters[@"city"] = self.city;
    http.parameters[@"area"] = self.area;
    http.parameters[@"address"] = self.address;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.view endEditing:YES];
        
        [TLAlert alertWithSucces:@"注册成功"];
        NSString *tokenId = responseObject[@"data"][@"token"];
        NSString *userId = responseObject[@"data"][@"userId"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //获取用户信息
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = USER_INFO;
            http.parameters[@"userId"] = userId;
            http.parameters[@"token"] = tokenId;
            [http postWithSuccess:^(id responseObject) {
                
                NSDictionary *userInfo = responseObject[@"data"];
                [TLUser user].userId = userId;
                [TLUser user].token = tokenId;
                
                //保存信息
                [[TLUser user] saveToken:tokenId];
                [[TLUser user] saveUserInfo:userInfo];
                [[TLUser user] setUserInfoWithDict:userInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        });
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)chooseAddress {

    [self.view endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
}

- (void)readProtocal {
    
    HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
    
    htmlVC.type = HTMLTypeRegProtocol;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}

- (void)collectRule {
    
    HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
    
    htmlVC.type = HTMLTypeInfoRule;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}


@end
