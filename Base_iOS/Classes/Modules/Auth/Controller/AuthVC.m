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

#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "AuthModel.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "MoxieSDK.h"

@interface AuthVC ()<MoxieSDKDelegate>

@property (nonatomic, strong) DataView *dataView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) AuthModel *authModel;

@end

@implementation AuthVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if ([TLUser user].isLogin) {
        
        [self requestAuthStatus];

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
    
    [self initMXSDK];
    
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
    
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].mxUserId = kMoXieUserID;
    [MoxieSDK shared].mxApiKey = kMoXieApiKey;
    [MoxieSDK shared].fromController = self;
    //    [MoxieSDK shared].cacheDisable = YES;
    
    [MoxieSDK shared].backImageName = @"返回";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
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

#pragma mark - Events

- (void)clickCancel {

    [UIView animateWithDuration:0.2 animations:^{
        
        self.dataView.y = 0;
        
    }];
}

- (void)dataWithSection:(SectionModel *)section {
    
    BaseWeakSelf;
    //认证是否完成,是（点击哪个就进入哪个）否：按认证顺序来
    
    switch (section.type) {
            
        case DataTypeBaseInfo:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    BaseInfoVC *baseInfoVC = [BaseInfoVC new];
                    
                    baseInfoVC.title = section.title;
                    
                    [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
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
                    
                    ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
                    
                    zmopScoreVC.title = section.title;
                    
                    [self.navigationController pushViewController:zmopScoreVC animated:YES];
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            ZMOPScoreVC *zmopScoreVC = [ZMOPScoreVC new];
            
            zmopScoreVC.title = section.title;
            
            zmopScoreVC.authModel = self.authModel;
            
            [self.navigationController pushViewController:zmopScoreVC animated:YES];
            
        }break;
            
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
            
        case DataTypeYYSRZ:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    [MoxieSDK shared].taskType = @"carrier";
                    
                    [[MoxieSDK shared] startFunction];
                    
                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
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
            //            }
            [MoxieSDK shared].taskType = @"carrier";
            
            [[MoxieSDK shared] startFunction];
            
        }break;
            
        case DataTypeTXLRZ:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    [TLAlert alertWithInfo:@"正在研发中，敬请期待"];

                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            
            [TLAlert alertWithInfo:@"正在研发中，敬请期待"];
//            ZMFoucsNameVC *foucsNameVC = [ZMFoucsNameVC new];
//
//            foucsNameVC.title = section.title;
//
//            [self.navigationController pushViewController:foucsNameVC animated:YES];
            
        }break;
            
        case DataTypeWXRZ:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    [TLAlert alertWithInfo:@"正在研发中，敬请期待"];

                };
                
                NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
                
                return ;
            }
            [TLAlert alertWithInfo:@"正在研发中，敬请期待"];

//            ZMCheatFoucsNameVC *cheatFoucsNameVC = [ZMCheatFoucsNameVC new];
//
//            cheatFoucsNameVC.title = section.title;
//            
//            [self.navigationController pushViewController:cheatFoucsNameVC animated:YES];
            
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
    
//    [TLUser user].message = message;
//    
//    NSDictionary *userInfo = @{@"message": message};
//    
//    [[TLUser user] saveUserInfo:userInfo];
    
    if(code == 2) {
        //继续查询该任务进展
        
        [TLAlert alertWithInfo:@"继续查询该任务进展"];
        
    } else if(code == 1) {
        //code是1则成功
        
        [TLProgressHUD show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"623048";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"taskId"] = taskId;
            
            [http postWithSuccess:^(id responseObject) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"623050";
                
                http.parameters[@"userId"] = [TLUser user].userId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLProgressHUD dismiss];

                    self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
                    
                    self.dataView.authModel = self.authModel;
                    
                    [TLAlert alertWithSucces:@"认证成功"];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        ManualAuditVC *auditVC = [ManualAuditVC new];
                        
                        auditVC.title = @"人工审核";
                        
                        [self.navigationController pushViewController:auditVC animated:YES];
                    });
                    
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
