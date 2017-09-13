//
//  AuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/3.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AuthVC.h"

#import "DataView.h"

#import "BaseInfoVC.h"
#import "ZMOPScoreVC.h"
#import "MXOperatorAuthVC.h"
#import "IdentifierVC.h"
#import "ManualAuditVC.h"
#import "MailListVC.h"

#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "AuthModel.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "MoxieSDK.h"

@interface AuthVC ()<MoxieSDKDelegate>

@property (nonatomic, strong) DataView *dataView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) AuthModel *authModel;

@property (nonatomic, copy) NSString *isApply;     //是否有申请单

@end

@implementation AuthVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([TLUser user].isLogin) {
        
        [self requestAuthStatus];
        
//        [self requestApplyStatus];
        
    } else {
        
        AuthModel *authModel = [AuthModel new];
        
        authModel.infoIdentifyFlag = @"0";
        
        authModel.infoAntifraudFlag = @"0";
        
        authModel.infoZMCreditFlag = @"0";
        
        authModel.infoCarrierFlag = @"0";
        
        self.dataView.authModel = authModel;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"认证引导";
    
    [self initTopView];
    
    [self initDataView];
    
    [self requestMXApiKey];
    
}

#pragma mark - Init

- (void)initTopView {
    
    CGFloat topH = kScreenWidth > 375 ? kHeight(30): 30;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topH)];
    
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#fdfbed"];
    
    [self.bgSV addSubview:self.topView];
    
    UILabel *promptLbl = [UILabel labelWithText:@"请如实填写本人信息，提高审核成功率" textColor:[UIColor colorWithHexString:@"#ffae00"] textFont:12.0];
    
    promptLbl.frame = CGRectMake(0, 0, kScreenWidth, 30);
    
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.topView addSubview:promptLbl];
    
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"删除"];
    
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setEnlargeEdge:15];
    
    [self.topView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        
    }];
}

- (void)initDataView {
    
    BaseWeakSelf;
    
    self.bgSV.height -= 49;
    
    self.dataView = [[DataView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth, kScreenHeight - 64 - 49)];
    
    self.dataView.dataBlock = ^(SectionModel *section) {
        
        [weakSelf dataWithSection:section];
    };
    
    [self.bgSV addSubview:self.dataView];
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, self.dataView.yy);
}

- (void)initMXSDK {
    
    //            if (![TLUser user].message) {
    //
    //                [MoxieSDK shared].taskType = @"carrier";
    //
    //                [[MoxieSDK shared] startFunction];
    //
    //            } else {
    //
    //                MXOperatorAuthVC *operatorAuthVC = [MXOperatorAuthVC new];
    //
    //                operatorAuthVC.title = @"详情报告";
    //
    //                [self.navigationController pushViewController:operatorAuthVC animated:YES];
    //            }，
    
    InfoIdentify *identify = self.authModel.infoIdentify;
    
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].mxUserId = kMoXieUserID;
    [MoxieSDK shared].mxApiKey = [TLUser user].mxApiKey;
    [MoxieSDK shared].fromController = self;
    
    [MoxieSDK shared].taskType = @"carrier";
    //跳过输入身份证和姓名界面
    [MoxieSDK shared].carrier_phone = [TLUser user].mobile;
    [MoxieSDK shared].carrier_name = identify.realName;
    [MoxieSDK shared].carrier_idcard = identify.idNo;
//    [MoxieSDK shared].carrier_editable = YES;
    
    [MoxieSDK shared].backImageName = @"返回";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //开始运营商认证
    [[MoxieSDK shared] startFunction];
    
}

#pragma mark - Data
- (void)requestAuthStatus {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623050";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.dataView.authModel = self.authModel;
        
    } failure:^(NSError *error) {
        
        
    }];
}

//- (void)requestApplyStatus {
//    //获取用户当前正在进行的申请记录
//    TLNetworking *http = [TLNetworking new];
//    
//    http.code = @"623032";
//    
//    http.parameters[@"userId"] = [TLUser user].userId;
//    
//    [http postWithSuccess:^(id responseObject) {
//        
//        self.isApply = responseObject[@"data"][@"toApproveFlag"];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (void)requestMXApiKey {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623917";
    http.parameters[@"key"] = @"mxApiKey";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLUser user].mxApiKey = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - Events

- (void)clickCancel {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.dataView.y = 0;
        
    }];
}

- (void)dataWithSection:(SectionModel *)section {
    
    BaseWeakSelf;
    //认证是否完成,是（点击哪个就进入哪个）否：按认证顺序来
    
    BOOL isIdent = [self.authModel.infoIdentifyFlag isEqualToString:@"1"];
    
    BOOL isBasic = [self.authModel.infoAntifraudFlag isEqualToString:@"1"];
    
    BOOL isZMScore = [self.authModel.infoZMCreditFlag isEqualToString:@"1"];
    
    BOOL isYYS = [self.authModel.infoCarrierFlag isEqualToString:@"1"];
    
    switch (section.type) {
            
        case DataTypeSFRZ:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    IdentifierVC *identifierAuthVC = [IdentifierVC new];
                    
                    [self.navigationController pushViewController:identifierAuthVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            IdentifierVC *identifierAuthVC = [IdentifierVC new];
            
            [self.navigationController pushViewController:identifierAuthVC animated:YES];
            
        }break;
            
        case DataTypeBaseInfo:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    if (!isIdent) {
                        
                        [TLAlert alertWithInfo:@"请先进行身份认证"];
                        
                        return;
                    }
                    
                    BaseInfoVC *baseInfoVC = [BaseInfoVC new];
                    
                    baseInfoVC.title = section.title;
                    
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
            
            baseInfoVC.title = section.title;
            
            [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
            
        }break;
            
        case DataTypeZMF:
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
                    
                    ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
                    
                    zmopScoreVC.title = section.title;
                    
                    [self.navigationController pushViewController:zmopScoreVC animated:YES];
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
            
            ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
            
            zmopScoreVC.title = section.title;
            
            zmopScoreVC.authModel = self.authModel;
            
            [self.navigationController pushViewController:zmopScoreVC animated:YES];
            
        }break;
            
        case DataTypeYYSRZ:
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
                        
                        [self initMXSDK];
                        
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
                    
                    [self initMXSDK];
                    
                } else {
                    
                    [TLAlert alertWithInfo:@"运营商数据正在认证，请稍后"];
                }
                
            } else {
                
                [TLAlert alertWithInfo:@"运营商已认证, 请勿重复认证"];
                return ;
            }
            
        }break;
            
        case DataTypeTXLRZ:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    //                    if (!isIdent) {
                    //
                    //                        [TLAlert alertWithInfo:@"请先进行身份认证"];
                    //                        return;
                    //
                    //                    } else if (!isBasic) {
                    //
                    //                        [TLAlert alertWithInfo:@"请先提交个人信息"];
                    //                        return;
                    //
                    //                    }else if (!isZMScore) {
                    //
                    //                        [TLAlert alertWithInfo:@"请先认证芝麻分"];
                    //                        return;
                    //
                    //                    } else if (!isYYS) {
                    //
                    //                        [TLAlert alertWithInfo:@"请先认证运营商"];
                    //                        return;
                    //                    }
                    
                    MailListVC *mailListVC = [MailListVC new];
                    
                    [self.navigationController pushViewController:mailListVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            //            if (!isIdent) {
            //
            //                [TLAlert alertWithInfo:@"请先进行身份认证"];
            //                return;
            //
            //            } else if (!isBasic) {
            //
            //                [TLAlert alertWithInfo:@"请先提交个人信息"];
            //                return;
            //
            //            }else if (!isZMScore) {
            //
            //                [TLAlert alertWithInfo:@"请先认证芝麻分"];
            //                return;
            //
            //            } else if (!isYYS) {
            //
            //                [TLAlert alertWithInfo:@"请先认证运营商"];
            //                return;
            //            }
            
            MailListVC *mailListVC = [MailListVC new];
            
            [self.navigationController pushViewController:mailListVC animated:YES];
            
        }break;
            
        case DataTypeWXRZ:
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
                        
                    } else if (!isYYS) {
                        
                        [TLAlert alertWithInfo:@"请先认证运营商"];
                        return;
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
                
            } else if (!isYYS) {
                
                [TLAlert alertWithInfo:@"请先认证运营商"];
                return;
            }
            
        }break;
            
        default:
            break;
    }
}

- (void)result:(NSMutableDictionary*)dic{
    NSLog(@"result ");
    
    NSString* system  = [[UIDevice currentDevice] systemVersion];
    if([system intValue]>=7){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    
}

#pragma mark - MoxieSDKDelegate

-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary {
    
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
    NSString *searchId = resultDictionary[@"searchId"];
    NSString *message = resultDictionary[@"message"];
    NSString *account = resultDictionary[@"account"];
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,searchId:%@,message:%@,account:%@",code,taskType,taskId,searchId,message,account);
    
    if(code == 2) {
        //继续查询该任务进展
        
//        [TLAlert alertWithInfo:@"继续查询该任务进展"];
        
    } else if(code == 1) {
        //code是1则成功
        
        [TLProgressHUD show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            魔蝎运营商认证
            //            TLNetworking *http = [TLNetworking new];
            //
            //            http.code = @"623048";
            //            http.parameters[@"userId"] = [TLUser user].userId;
            //            http.parameters[@"taskId"] = taskId;
            //
            //            [http postWithSuccess:^(id responseObject) {
            //
            //
            //
            //            } failure:^(NSError *error) {
            //
            //
            //            }];
            
            //获取用户当前正在进行的申请记录
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"623032";
            
            http.parameters[@"userId"] = [TLUser user].userId;
            
            [http postWithSuccess:^(id responseObject) {
                
                //申请状态
                self.isApply = responseObject[@"data"][@"toApproveFlag"];
                
                //认证结果查询
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"623050";
                
                http.parameters[@"userId"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
                    
                    self.dataView.authModel = self.authModel;
                    
                    [TLProgressHUD dismiss];
                    
                    [TLAlert alertWithTitle:@"" message:@"运营商认证成功" confirmMsg:@"OK" confirmAction:^{
                        
                        if ([self.isApply isEqualToString:@"1"]) {
                            
                            //进入人工审核界面
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                ManualAuditVC *auditVC = [ManualAuditVC new];
                                
                                auditVC.title = @"人工审核";
                                
                                [self.navigationController pushViewController:auditVC animated:YES];
                            });
                        }
                        
                    }];
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
            } failure:^(NSError *error) {
                
            }];
        
        });
        
    } else if(code == -1) {
        //用户没有做任何操作
        
        //        [TLAlert alertWithInfo:@"用户没有做任何操作"];
        
    } else if(code == -2) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"平台方服务问题"];
        
    } else if(code == -3) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"魔蝎数据服务异常"];
        
    }else if(code == -4) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"用户输入出错"];
        
    }else {
        
        //该任务失败按失败处理
        [TLAlert alertWithError:@"查询失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
