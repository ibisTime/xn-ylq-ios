//
//  NewAuthVC.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/11/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewAuthVC.h"
#import "TLImagePicker.h"
#import "SettingGroup.h"
#import "SettingModel.h"
#import "SettingCell.h"
#import "IDCardVC.h"
#import "PhoneAuthVC.h"
#import "AlipayAuthVC.h"
#import "BaseInfoVC.h"
#import "MailListVC.h"
#import "AuthModel.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "MoxieAuthVC.h"
#import <MoxieSDK.h>
#import "ZQFaceAuthEngine.h"
#import "ZQOCRScanEngine.h"
#import "TLUploadManager.h"
#import <Photos/Photos.h>

#import <CoreLocation/CoreLocation.h>

#import "AddressPickerView.h"
@interface NewAuthVC ()<UITableViewDataSource,UITableViewDelegate,ZQFaceAuthDelegate,ZQOcrScanDelegate,MoxieSDKDelegate,CLLocationManagerDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
}
@property (nonatomic, strong) TLTableView *mineTableView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, strong) UILabel *mobileLbl;

@property (nonatomic, strong) UILabel *serviceTimeLbl;

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) SettingModel *loanRecordItem;

@property (nonatomic, strong) SettingModel *inviteFriendItem;

@property (nonatomic, strong) SettingModel *helpItem;

@property (nonatomic, strong) SettingModel *contactItem;

@property (nonatomic, strong) SettingModel *settingItem;

@property (nonatomic, strong) SettingModel *settingPhone;

@property (nonatomic, strong) SettingModel *settingbase;

@property (nonatomic, strong) AuthModel *authModel;

@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,strong) AddressPickerView *addressPicker;

//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic, copy) NSString *address;  //详细地址

@end

@implementation NewAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestCarrierStatus];

    
}
- (void)initTableView {
    
    BaseWeakSelf;
    
    TLTableView *mineTableView = [TLTableView groupTableViewWithFrame:CGRectZero
                                                             delegate:self
                                                           dataSource:self];
    [self.view addSubview:mineTableView];
    
    mineTableView.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 49);
    mineTableView.rowHeight = 45;
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f4f7"];
    mineTableView.scrollEnabled = NO;
    
    self.mineTableView = mineTableView;
    
    
}
#pragma mark- 头部条状 事件处理

- (SettingGroup *)group {
    
    if (!_group) {
        
        BaseWeakSelf;
        
        _group = [[SettingGroup alloc] init];
        
        NSArray *names = @[@"手机号认证", @"填写定位", @"身份认证", @"支付宝认证",@"通讯录认证",@"运营商认证",@"基本信息认证"];
        
        //借款记录
        SettingModel *loanRecordItem = [SettingModel new];
        loanRecordItem.text  = names[0];
        
        loanRecordItem.subText = @"已认证";
        self.loanRecordItem = loanRecordItem;
        [loanRecordItem setAction:^{
            
//            PhoneAuthVC *vc = [PhoneAuthVC new];
//            vc.title = @"手机号认证";
//
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        
        //邀请好友
        SettingModel *inviteFriendItem = [SettingModel new];
        inviteFriendItem.text  = names[1];
        if ([TLUser user].province.length>0) {
            inviteFriendItem.subText = @"已认证";

        }else{
            inviteFriendItem.subText = @"未认证";

        }
        self.inviteFriendItem = inviteFriendItem;
        [inviteFriendItem setAction:^{
            //获取定位
            if (![TLAuthHelper isEnableLocation]) {
                
                // 请求定位授权
                [self.sysLocationManager requestWhenInUseAuthorization];
                
                
                [TLAlert alertWithTitle:@"" msg:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                    
                } confirm:^(UIAlertAction *action) {
                    
                    [TLAuthHelper openSetting];
                    
                }];
                
                return;
                
            }
            
            [self.sysLocationManager startUpdatingLocation];
            
//            NewAuthVC *vc = [NewAuthVC new];
//
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        //帮助中心
        SettingModel *helpItem = [SettingModel new];
        helpItem.text  = names[2];
        helpItem.subText = [self.authModel.infoZqznFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
        self.helpItem = helpItem;

        [helpItem setAction:^{
            if ([self.authModel.infoZqznFlag isEqualToString:@"1"]) {
                return ;
            }
            [self postRequest];
//            IDCardVC *vc = [IDCardVC new];
//            vc.title = @"身份证认证";
//
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        
        //联系客服
        SettingModel *contactItem = [SettingModel new];
        contactItem.text  = names[3];
        contactItem.subText = [self.authModel.infoZfbFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
        self.contactItem = contactItem;

        [contactItem setAction:^{
            if ([self.authModel.infoZfbFlag isEqualToString:@"1"]) {
                return ;
            }
            
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"623061";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"key"] = @"INFO_ZHIFUBAO";
            
            
            [http postWithSuccess:^(id responseObject) {
                
                [MoxieSDK shared].userId = [TLUser user].userId;
                [MoxieSDK shared].apiKey = @"079bae4e7fd041b9a1d986e16e75e3e5";
                [MoxieSDK shared].fromController = self;
                
                [MoxieSDK shared].delegate = self;
                [MoxieSDK shared].taskType = @"alipay";
                
                [[MoxieSDK shared] start];
                [MoxieSDK shared].backImageName = @"返回";
                
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                
                [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                
            } failure:^(NSError *error) {
                    
                }];
            
            
           
            
        }];
        
        //个人设置
        SettingModel *settingItem = [SettingModel new];
        settingItem.text = names[4];
        settingItem.subText = [self.authModel.infoAddressBookFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
        self.settingItem = settingItem;

        [settingItem setAction:^{
            if ([self.authModel.infoAddressBookFlag isEqualToString:@"1"]) {
                return ;
            }
            MailListVC *vc = [MailListVC new];

            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        //个人设置
        SettingModel *settingPhone = [SettingModel new];
        settingPhone.text = names[5];
        settingPhone.subText = @"未认证";
        self.settingPhone = settingPhone;
        settingPhone.subText = [self.authModel.infoCarrierFlag isEqualToString:@"1"] ? @"已认证":@"未认证";

        [settingPhone setAction:^{
            if ([self.authModel.infoCarrierFlag isEqualToString:@"1"]) {
                return ;
            }
            [self beginMoxie];
//            [TLAlert alertWithInfo:@"暂未实现"];
//            return ;
           
            
            
//            if ([self.authModel.infoCarrierFlag isEqualToString:@"1"]) {
//                return ;
//            }
//            NewAuthVC *vc = [NewAuthVC new];
//
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        //个人设置
        SettingModel *settingbase = [SettingModel new];
        settingbase.text = names[6];
        settingbase.subText = @"未认证";
        self.settingbase = settingbase;
        settingbase.subText = [self.authModel.infoPersonalFlag isEqualToString:@"1"] ? @"已认证":@"未认证";

        [settingbase setAction:^{
            if ([self.authModel.infoPersonalFlag isEqualToString:@"1"]) {
                return ;
            }
            BaseInfoVC *vc = [BaseInfoVC new];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        
        
        _group.groups = @[@[loanRecordItem, inviteFriendItem, helpItem, contactItem,settingItem,settingPhone,settingbase]];
        
    }
    return _group;
    
}

- (void)beginMoxie
{
    
    
    //余额查询
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623061";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"key"] = @"INFO_CARRIER ";
    
    
    [http postWithSuccess:^(id responseObject) {
        //运营商
        [MoxieSDK shared].userId = [TLUser user].userId;
        [MoxieSDK shared].apiKey = @"079bae4e7fd041b9a1d986e16e75e3e5";
        [MoxieSDK shared].fromController = self;
        [MoxieSDK shared].delegate = self;
        [MoxieSDK shared].taskType = @"carrier";
        MXLoginCustom *loginCustom = [MXLoginCustom new];
        if ([TLUser user].realName.length >0 &&[TLUser user].mobile.length >0 && [TLUser user].idNo.length >0) {
            loginCustom.loginParams = @{
                                        @"phone":[NSString stringWithFormat:@"%@",[TLUser user].mobile],
                                        @"name":[NSString stringWithFormat:@"%@",[TLUser user].realName],
                                        @"idcard":[NSString stringWithFormat:@"%@",[TLUser user].idNo]
                                        };
            [MoxieSDK shared].loginCustom = loginCustom;
        }
        
        [[MoxieSDK shared] start];
        [MoxieSDK shared].backImageName = @"返回";
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        
    } failure:^(NSError *error) {
            
        }];
    
    
}
- (void)postRequest
{
    //余额查询
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623061";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"key"] = @"INFO_ZQZN";

    
    [http postWithSuccess:^(id responseObject) {
        //身份认证
        ZQOCRScanEngine *engine = [[ZQOCRScanEngine alloc] init];
        engine.delegate = self;
        engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
        engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
        [engine startOcrScanIdCardInViewController:self];    } failure:^(NSError *error) {
        
    }];
    
  
    
}
//获取运营商状态
- (void)requestCarrierStatus {
    
    //认证结果查询
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623050";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initTableView];
        [self refrashStatus];
        
        //运营商是否已认证
        if ([self.authModel.infoCarrierFlag isEqualToString:@"1"]) {
            
            [TLProgressHUD dismiss];
            
                
               
            
                
           
        } else if([self.authModel.infoCarrierFlag isEqualToString:@"3"]){
            
            //重复调认证状态接口
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                [self requestCarrierStatus];
                
            });
        }
        
        
    } failure:^(NSError *error) {
        
        [self initTableView];

    }];
}

-(void)refrashStatus
{
    self.helpItem.subText = [self.authModel.infoZqznFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
    self.contactItem.subText = [self.authModel.infoZfbFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
    self.settingItem.subText = [self.authModel.infoAddressBookFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
    self.settingPhone.subText = [self.authModel.infoCarrierFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
    self.settingbase.subText = [self.authModel.infoPersonalFlag isEqualToString:@"1"] ? @"已认证":@"未认证";
    if ([self.authModel.infoZqznFlag isEqualToString:@"3"]) {
        self.helpItem.subText = @"认证中";
    }
    if ([self.authModel.infoZqznFlag isEqualToString:@"4"]) {
        self.helpItem.subText = @"认证失败";
    }
    if ([self.authModel.infoCarrierFlag isEqualToString:@"3"]) {
        self.settingPhone.subText = @"认证中";
    }
    if ([self.authModel.infoCarrierFlag isEqualToString:@"4"]) {
        self.settingPhone.subText = @"认证失败";
    }
    if ([self.authModel.infoZfbFlag isEqualToString:@"3"]) {
        self.contactItem.subText = @"认证中";
    }if ([self.authModel.infoZfbFlag isEqualToString:@"4"]) {
        self.contactItem.subText = @"认证失败";
    }
    [self.mineTableView reloadData_tl];
}

- (void)dataWithSection:(NSInteger )section {
    
    BaseWeakSelf;
    //认证是否完成,是（点击哪个就进入哪个）否：按认证顺序来
    
    BOOL isIdent = [self.authModel.infoIdentifyFlag isEqualToString:@"1"];
    
    BOOL isBasic = [self.authModel.infoAntifraudFlag isEqualToString:@"1"];
    
    BOOL isZMScore = [self.authModel.infoZMCreditFlag isEqualToString:@"1"];
    
    BOOL isYYS = [self.authModel.infoCarrierFlag isEqualToString:@"1"];
    
    switch (section) {
            
        case 0:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                   
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            
            
        }break;
            
        case 1:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    if (!isIdent) {
                        
                        [TLAlert alertWithInfo:@"请先进行身份认证"];
                        
                        return;
                    }
                    
                    BaseInfoVC *baseInfoVC = [BaseInfoVC new];
                    
//                    baseInfoVC.title = section.title;
                    
                    [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            if (!isIdent) {
                
                [TLAlert alertWithInfo:@"请先进行身份认证"];
                
                return;
            }
            
            BaseInfoVC *baseInfoVC = [BaseInfoVC new];
            
//            baseInfoVC.title = section.title;
            
            [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
            
        }break;
            
        case 2:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    if (!isIdent) {
                        
                        [TLAlert alertWithInfo:@"请先进行身份认证"];
                        
                        return;
                        
                    } else if (!isBasic) {
                        
                        [TLAlert alertWithInfo:@"请先提交个人信息"];
                        return;
                    }
                    
//                    ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
//
//                    zmopScoreVC.title = section.title;
//
//                    [self.navigationController pushViewController:zmopScoreVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            if (!isIdent) {
                
                [TLAlert alertWithInfo:@"请先进行身份认证"];
                
                return;
                
            } else if (!isBasic) {
                
                [TLAlert alertWithInfo:@"请先提交个人信息"];
                return;
            }
            
//            ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
//
//            zmopScoreVC.title = section.title;
//
//            zmopScoreVC.authModel = self.authModel;
//
//            [self.navigationController pushViewController:zmopScoreVC animated:YES];
            
        }break;
            
        case 3:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    if (!isIdent) {
                        
                        [TLAlert alertWithInfo:@"请先进行身份认证"];
                        
                        return;
                        
                    } else if (!isBasic) {
                        
                        [TLAlert alertWithInfo:@"请先提交个人信息"];
                        return;
                        
                    }else if (!isZMScore) {
                        
                        [TLAlert alertWithInfo:@"请先认证芝麻分"];
                        return;
                    }
                    
                    //判断是否已认证
                    if (!isYYS) {
                        
//                        [self initMXSDK];
                        
                    } else {
                        
                        [TLAlert alertWithInfo:@"运营商已认证, 请勿重复认证"];
                        return ;
                    }
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            if (!isIdent) {
                
                [TLAlert alertWithInfo:@"请先进行身份认证"];
                
                return;
                
            } else if (!isBasic) {
                
                [TLAlert alertWithInfo:@"请先提交个人信息"];
                return;
                
            }else if (!isZMScore) {
                
                [TLAlert alertWithInfo:@"请先认证芝麻分"];
                return;
            }
            
            if (!isYYS) {
                
                //判断是否在认证中,3为认证中状态
                if (![self.authModel.infoCarrierFlag isEqualToString:@"3"]) {
                    //                if (self.authModel.infoCarrierFlag) {
                    
                    //                    [self initMXSDK];
                    
//                    TongDunVC *tongDunVC = [TongDunVC new];
//
//                    tongDunVC.respBlock = ^(NSString *taskId) {
//
//                        [weakSelf authRespWithTaskId:taskId];
//                    };
//
//                    [self.navigationController pushViewController:tongDunVC animated:YES];
                    
                } else {
                    
                    [TLAlert alertWithInfo:@"运营商数据正在认证，请稍后"];
                }
                
            } else {
                
                [TLAlert alertWithInfo:@"运营商已认证, 请勿重复认证"];
                return ;
            }
            
        }break;
            
        default:
            break;
    }
}
#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.groups[indexPath.section];
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - ZQFaceAuthDelegate

- (void)faceAuthFinishedWithResult:(ZQFaceAuthResult)result UserInfo:(id)userInfo{
    
    NSLog(@"OC authFinish");
    UIImage * livingPhoto = [userInfo objectForKey:@"livingPhoto"];
    
    if(result  == ZQFaceAuthResult_Done && livingPhoto !=nil){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜您，已完成活体检测！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        //        [alertView show];
        TLUploadManager *manager = [TLUploadManager manager];
        NSData *imgData = UIImageJPEGRepresentation(livingPhoto, 0.6);
        manager.imgData = imgData;
        manager.image = livingPhoto;
        [SVProgressHUD showWithStatus:@""];

        [manager getTokenAuthShowView:self.view succes:^(NSString *key) {
            [SVProgressHUD dismiss];

            str3 = key;
            
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"623044";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"frontImage"] = str1;
            http.parameters[@"backImage"] = str2;
            http.parameters[@"faceImage"] = str3;
            //            QUERY
            [http postWithSuccess:^(id responseObject) {
                [self requestCarrierStatus];
                [[TLUser user] updateUserInfo];
                [TLAlert alertWithSucces:@"身份证提交成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });
            } failure:^(NSError *error) {
                
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)faceAuthFinishedWithResult:(NSInteger)result userInfo:(id)userInfo{
    
    NSLog(@"Swift authFinish");
}

- (void)idCardOcrScanFinishedWithResult:(ZQFaceAuthResult)result userInfo:(id)userInfo{
    NSLog(@"OC OCR Finish");
    
    UIImage *frontcard = [userInfo objectForKey:@"frontcard"];
    UIImage *portrait = [userInfo objectForKey:@"portrait"];
    UIImage *backcard = [userInfo objectForKey:@"backcard"];
    if(result  == ZQFaceAuthResult_Done && frontcard != nil && portrait != nil && backcard !=nil){
        
        
        NSData *imgData = UIImageJPEGRepresentation(frontcard, 0.6);
        NSData *imgData1 = UIImageJPEGRepresentation(backcard, 0.6);
        //进行上传
        TLUploadManager *manager = [TLUploadManager manager];
        
        manager.imgData = imgData;
        manager.image = frontcard;
        [SVProgressHUD showWithStatus:@""];

        [manager getTokenAuthShowView:self.view succes:^(NSString *key) {
            [SVProgressHUD dismiss];

            str1 = key;
            TLUploadManager *manager1 = [TLUploadManager manager];
            
            manager1.imgData = imgData1;
            manager1.image = backcard;
            [SVProgressHUD showWithStatus:@""];

            [manager1 getTokenAuthShowView:self.view succes:^(NSString *key) {
                [SVProgressHUD dismiss];

                str2 = key;
                ZQFaceAuthEngine * engine = [[ZQFaceAuthEngine alloc]init];
                engine.delegate = self;
                engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
                engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
                [engine startFaceAuthInViewController:self];
                
            } failure:^(NSError *error) {
                
            }];
        } failure:^(NSError *error) {
            
        }];
    }
    
}




#pragma mark- datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.group.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.group.items = self.group.groups[section];
    
    return  self.group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellID"];
    
    if (!cell) {
        
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCellID"];
        
    }
    
    self.group.items = self.group.groups[indexPath.section];
    
    //
    cell.settingModel = self.group.items[indexPath.row];
    
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}
#pragma MoxieSDK Result Delegate
//魔蝎SDK --- 回调数据结果
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    //任务结果code，详细参考文档
//    return;
    int code = [resultDictionary[@"code"] intValue];
    //是否登录成功
    BOOL loginDone = [resultDictionary[@"loginDone"] boolValue];
    //任务类型
    NSString *taskType = resultDictionary[@"taskType"];
    //任务Id
    NSString *taskId = resultDictionary[@"taskId"];
    //描述
    NSString *message = resultDictionary[@"message"];
    //当前账号
    NSString *account = resultDictionary[@"account"];
    //用户在该业务平台上的userId，例如支付宝上的userId（目前支付宝，淘宝，京东支持）
    NSString *businessUserId = resultDictionary[@"businessUserId"]?resultDictionary[@"businessUserId"]:@"";
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,message:%@,account:%@,loginDone:%d，businessUserId:%@",code,taskType,taskId,message,account,loginDone,businessUserId);
    //【登录中】假如code是2且loginDone为false，表示正在登录中
    if(code == 2 && loginDone == false){
        NSLog(@"任务正在登录中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【采集中】假如code是2且loginDone为true，已经登录成功，正在采集中
    else if(code == 2 && loginDone == true){
        NSLog(@"任务已经登录成功，正在采集中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【采集成功】假如code是1则采集成功（不代表回调成功）
    else if(code == 1){
        [self requestCarrierStatus];

        NSLog(@"任务采集成功，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【未登录】假如code是-1则用户未登录
    else if(code == -1){
        NSLog(@"用户未登录");
    }
    //【任务失败】该任务按失败处理，可能的code为0，-2，-3，-4
    else{
        NSLog(@"任务失败");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
            weakSelf.inviteFriendItem.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
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
    
//    [self setUpUI];
    
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
            self.inviteFriendItem.subText = @"已认证";
            [self.mineTableView reloadData_tl];
            
            
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"623062";
            http.parameters[@"userId"] = [TLUser user].userId;

            http.parameters[@"province"] = self.province;
            http.parameters[@"city"] = self.city;
            http.parameters[@"area"] = self.area;
            http.parameters[@"address"] = self.address;
            [http postWithSuccess:^(id responseObject) {
                [TLAlert alertWithSucces:@"定位已认证"];
            } failure:^(NSError *error) {
                
            }];


        }
        
//        [self setUpUI];
        
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.sysLocationManager startUpdatingLocation];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
