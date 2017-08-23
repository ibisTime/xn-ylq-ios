//
//  ZMOPScoreVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMOPScoreVC.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "ZMScoreModel.h"
#import "ZMOPScoreResultVC.h"

@interface ZMOPScoreVC ()

@property (nonatomic, strong) TLTextField *realName;    //真实姓名

@property (nonatomic, strong) TLTextField *idCard;      //身份证

@property (nonatomic, assign) BOOL isAuth;              //是否授权

@end

@implementation ZMOPScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];

}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    self.navigationController.navigationBar.translucent = YES;
    
    if (!_isAuth) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kBlackColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    

}

#pragma mark - Init
- (void)initSubviews {
    
    _isAuth = NO;
    
    CGFloat leftMargin = 15;
    
    InfoIdentify *identify = self.authModel.infoIdentify;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@"请输入姓名"];
    
    self.realName.returnKeyType = UIReturnKeyNext;
    
    self.realName.text = identify.realName ? identify.realName: nil;
    
    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy + 1, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@"请输入身份证号码"];
    
    self.idCard.text = identify.idNo ? identify.idNo: nil;
    
    [self.view addSubview:self.idCard];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:45/2.0];
    
    confirmBtn.frame = CGRectMake(leftMargin, self.idCard.yy + 40, kScreenWidth - 2*leftMargin, 45);
    
    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
}

#pragma mark - Events
- (void)confirmIDCard:(UIButton *)sender {
    
    if (![self.realName.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        return;
    }
    
    if (![self.idCard.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入身份证号码"];
        return;
    }
    
    if (self.idCard.text.length != 18) {
        
        [TLAlert alertWithInfo:@"请输入18位身份证号码"];
        return;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    http.showView = self.view;

    http.code = @"623047";
//    http.parameters[@"idNo"] = self.idCard.text;
//    http.parameters[@"realName"] = self.realName.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        ZMOPScoreResultVC *scoreResultVC = [ZMOPScoreResultVC new];
        
        scoreResultVC.title = @"芝麻信用评分结果";
        
        scoreResultVC.realName = self.realName.text;
        
        scoreResultVC.idCard = self.idCard.text;
        
        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
            
            ZMScoreModel *scoreModel = [ZMScoreModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            //是否授权
            if (scoreModel.authorized) {
                
                _isAuth = YES;
                
//                scoreResultVC.result = YES;
//                
//                scoreResultVC.scoreModel = scoreModel;
                
                [TLUser user].currentAuth = 2;
                
                [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"kCurrentAuthStatus"];
                [TLAlert alertWithSucces:@"认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                return ;
                
            } else {
                
                _isAuth = NO;
                
                NSString *appId = scoreModel.appId;
                
                NSString *sign = scoreModel.signature;
                
                NSString *params = scoreModel.param;
                
                if (appId && sign && params) {
                    
                    [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params extParams:nil selector:@selector(result:) target:self];
                    
                } else {
                    
                    [TLAlert alertWithInfo:@"appId或sign或param为空"];
                }
                
                return ;
                
            }
            
        } else {
            
            _isAuth = YES;

            scoreResultVC.result = NO;
            
            scoreResultVC.failureReason = responseObject[@"errorInfo"];
        }
        
        [self.navigationController pushViewController:scoreResultVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)result:(NSMutableDictionary *)dic {

    NSLog(@"result %@", dic);
    
    if (dic[@"authResult"]) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.isShowMsg = NO;

        http.code = @"623047";
        http.parameters[@"idNo"] = self.idCard.text;
        http.parameters[@"realName"] = self.realName.text;
        
        [http postWithSuccess:^(id responseObject) {
            
            _isAuth = YES;
            
            ZMOPScoreResultVC *scoreResultVC = [ZMOPScoreResultVC new];

            scoreResultVC.title = @"芝麻信用评分结果";
            
            scoreResultVC.realName = self.realName.text;
            
            scoreResultVC.idCard = self.idCard.text;
            
            if ([responseObject[@"errorCode"] isEqual:@"0"]) {
                
//                ZMScoreModel *scoreModel = [ZMScoreModel mj_objectWithKeyValues:responseObject[@"data"]];
//                
//                scoreResultVC.result = YES;
//                
//                scoreResultVC.scoreModel = scoreModel;
                
                [TLUser user].currentAuth = 2;
                
                [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"kCurrentAuthStatus"];
                [TLAlert alertWithSucces:@"认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                return ;
                
            } else {
            
                scoreResultVC.result = NO;

                scoreResultVC.failureReason = responseObject[@"errorInfo"];
            }
            
            [self.navigationController pushViewController:scoreResultVC animated:YES];

            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
    
        [TLAlert alertWithError:@"授权失败"];
    }

}

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
