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
//#import "MXOperatorAuthVC.h"
#import "IdentifierVC.h"
#import "ManualAuditVC.h"
#import "MailListVC.h"
#import "TongDunVC.h"

#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "AuthModel.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "MoxieSDK.h"
#import "MyQuotaView.h"
#import "QuotaModel.h"
#import "TabbarViewController.h"
#import "SelectMoneyVC.h"
#import "UIView+Custom.h"
#import "NewAuthVC.h"
@interface AuthVC ()<MoxieSDKDelegate>

@property (nonatomic, strong) DataView *dataView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) AuthModel *authModel;

@property (nonatomic, copy) NSString *isApply;     //是否有申请单
//
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) MyQuotaView *quotaView;

@property (nonatomic, strong) QuotaModel *quota;

@property (nonatomic, strong) UIButton *quotaBtn;

@property (nonatomic, strong) UILabel *Creditcoin;
@property (nonatomic, strong) UILabel *Creditcoin1;
@property (nonatomic, strong) UILabel *Creditcoin2;

//信用分状态
@property (nonatomic, assign) NSInteger flag;
@end

@implementation AuthVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([TLUser user].isLogin) {
        //查看认证状态
        [self requestAuthStatus];
        [self requestQuota];

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
    self.title = @"信用分";
    
    [self initTopView];
    if ([AppConfig config].comPany == ComPanyNoLoad) {
        if (![TLUser user].isLogin) {
            TLUserLoginVC *loginVC = [TLUserLoginVC new];
            
            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:nav animated:YES completion:nil];
            
            return ;
        }
    }
    
//    [self initDataView];
//
//    [self requestMXApiKey];
    
}

#pragma mark - Init

- (void)initTopView {
    
    CGFloat topH = kScreenWidth > 375 ? kHeight(30): 30;
    
    self.quotaView = [[MyQuotaView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    
    self.quotaView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:self.quotaView];
    CGFloat quotaBtnH = 45;
    
   
}

- (void)requestQuota {
    
    //--//
    //刷新信用分状态
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"623033";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSInteger flag = [responseObject[@"data"][@"status"] integerValue];
        self.flag = flag;
        self.quota = [QuotaModel new];
        NSString *title = @"";
        self.quota.flag = responseObject[@"data"][@"status"];
//        self.quota.sxAmount = responseObject[@"data"][@"list"][0][@"creditScore"];
        switch (flag) {
            case 0:
            {
                //未认证
      [self.quotaBtn setTitle:title forState:UIControlStateNormal];

                [self creatIntroduce];
                

            }break;
                
            case 1:
            {
                //认证中

                [self initSubviews];

            }break;
                
            case 2:
            {
                //待审核
                [self initSubviewsCheck];
                title = @"请耐心等待";
                [self.quotaBtn setTitle:title forState:UIControlStateNormal];
//                title = @"重新申请额度";
//                [self rewenRequest];

            }break;
            case 3:
            {
                //审核失败

                [self.quotaBtn setTitle:title forState:UIControlStateNormal];
                [self rewenRequest];
                self.Creditcoin1.text = [NSString stringWithFormat:@"失败理由: %@",responseObject[@"data"][@"apply"][@"approveNote"]];

            }break;
            case 4:
            {
               
                [self beginUser];
                self.quota.sxAmount = responseObject[@"data"][@"creditScore"];
                
                title = @"使用信用分";
                self.quota.validDays = [responseObject[@"data"][@"validDays"] integerValue];

                [self.quotaBtn setTitle:title forState:UIControlStateNormal];
                
            }break;
                
            case 5:
            {
              
                [self beginUser];
                self.quota.sxAmount = responseObject[@"data"][@"creditScore"];

                title = @"重新申请";
                [self.quotaBtn setTitle:title forState:UIControlStateNormal];
            }break;
            case 6:
            {
               
                [self beginUser];
                self.quota.sxAmount = responseObject[@"data"][@"creditScore"];
                title = @"重新申请";
                [self.quotaBtn setTitle:title forState:UIControlStateNormal];
                
            }break;
            default:
                break;
                

        }
        
        self.quotaView.quotaModel = self.quota;

        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)requestScore
{
  
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"623020";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithInfo:@"信用分申请成功"];
        [self requestQuota];
        [self requestGood];
    } failure:^(NSError *error) {
        
    }];

    
}

- (void)requestScoreAgain
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"623020";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        [TLAlert alertWithInfo:@"信用分申请成功"];
        [self requestQuota];
    } failure:^(NSError *error) {
        
    }];
    
    
}


- (void)rewenRequest
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.hidden = YES;

    self.contentView = [UIView new];

    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    UILabel *Creditcoin = [UILabel labelWithText:@"认证失败" textColor:[UIColor redColor] textFont:14.0];
    self.Creditcoin = Creditcoin;
    Creditcoin.frame = CGRectMake(15, 20, kScreenWidth-30, 30);
    Creditcoin.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:Creditcoin];
    
    UILabel *Creditcoin1 = [UILabel labelWithText:@"失败理由:核准失败" textColor:kTextColor textFont:14.0];
    self.Creditcoin1 = Creditcoin1;
    [self.contentView addSubview:self.Creditcoin1];
    Creditcoin1.frame = CGRectMake(15, Creditcoin.yy+16, kScreenWidth-30, 30);
    Creditcoin1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:Creditcoin1];
    CGFloat quotaBtnH = 45;
    
    self.quotaBtn = [UIButton buttonWithTitle:@"重新提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15, Creditcoin1.yy + 62, kScreenWidth - 30, quotaBtnH);
    
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.quotaBtn];
    
}


- (void)beginUser
{
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.contentView.hidden = YES;
    
        self.contentView = [UIView new];

        self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
        [self.view addSubview:self.contentView];
        CGFloat quotaBtnH = 45;

        self.quotaBtn = [UIButton buttonWithTitle:@"使用信用分" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
        self.quotaBtn.frame = CGRectMake(15,  100, kScreenWidth - 30, quotaBtnH);
    
        [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.contentView addSubview:self.quotaBtn];
//        TLNetworking *http = [TLNetworking new];
//        http.code = @"623051";
//        http.parameters[@"userId"] = [TLUser user].userId;
//
//        [http postWithSuccess:^(id responseObject) {
//
//            QuotaModel *model = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
//            self.quota= model;
//            self.quotaView.Model = model;
//
//    } failure:^(NSError *error) {
//
//
//    }];
}

- (void)beginDissmiss
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.hidden = YES;
    
    self.contentView = [UIView new];
    
    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    CGFloat quotaBtnH = 45;
    
    self.quotaBtn = [UIButton buttonWithTitle:@"重新申请" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15,  100, kScreenWidth - 30, quotaBtnH);
    
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.quotaBtn];
    TLNetworking *http = [TLNetworking new];
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        QuotaModel *model = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.quota= model;
        self.quotaView.Model = model;
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)beginrenw
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.hidden = YES;
    
    self.contentView = [UIView new];
    
    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    CGFloat quotaBtnH = 45;
    
    self.quotaBtn = [UIButton buttonWithTitle:@"重新申请" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15,  100, kScreenWidth - 30, quotaBtnH);
    
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.quotaBtn];
    TLNetworking *http = [TLNetworking new];
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        QuotaModel *model = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.quota= model;
        self.quotaView.Model = model;
        
    } failure:^(NSError *error) {
        
        
    }];
}


- (void)initSubviewsCheck {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.hidden = YES;
    
    self.contentView = [UIView new];
    
    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    
    NSArray *imgArr = @[@"期望额度", @"select", @"人工审核灰"];
    
    NSArray *titleArr = @[@"资料填写", @"待审核", @"信用核准"];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat imgViewW = 21;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        
        iv.frame = CGRectMake(kWidth(100), kHeight(58) + i*(21 + kHeight(65)), imgViewW, imgViewW);
        
        iv.layer.cornerRadius = imgViewW/2.0;
        
        iv.clipsToBounds = YES;
        
        [self.contentView addSubview:iv];
        
        UILabel *textLbl = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:15.0];
        
        textLbl.frame = CGRectMake(iv.xx + kWidth(20),kHeight(58) + i*(21 + kHeight(65)), 70, 16);
        
        [self.contentView addSubview:textLbl];
        
        if (i != 2) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(iv.centerX, iv.yy, 1, kHeight(65))];
            
            UIColor *color = i == 0 ? kAppCustomMainColor : [UIColor colorWithHexString:@"#cccccc"];
            
            [self.contentView addSubview:lineView];
            
            [lineView drawDashLine:3 lineSpacing:2 lineColor:color];
            
        }
    }
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"请耐心等待" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    self.quotaBtn = commitBtn;
    commitBtn.frame = CGRectMake(leftMargin, kHeight(280), kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:commitBtn];
    
}

- (void)initSubviews {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.hidden = YES;
    
    self.contentView = [UIView new];

    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    
    NSArray *imgArr = @[@"期望额度", @"unselect", @"人工审核灰"];
    
    NSArray *titleArr = @[@"资料填写", @"待审核", @"信用核准"];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat imgViewW = 21;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        
        iv.frame = CGRectMake(kWidth(100), kHeight(58) + i*(21 + kHeight(65)), imgViewW, imgViewW);
        
        iv.layer.cornerRadius = imgViewW/2.0;
        
        iv.clipsToBounds = YES;
        
        [self.contentView addSubview:iv];
        
        UILabel *textLbl = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:15.0];
        
        textLbl.frame = CGRectMake(iv.xx + kWidth(20),kHeight(58) + i*(21 + kHeight(65)), 70, 16);
        
        [self.contentView addSubview:textLbl];
        
        if (i != 2) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(iv.centerX, iv.yy, 1, kHeight(65))];
            
            UIColor *color = i == 0 ? kAppCustomMainColor : [UIColor colorWithHexString:@"#cccccc"];
            
            [self.contentView addSubview:lineView];
            
            [lineView drawDashLine:3 lineSpacing:2 lineColor:color];
            
        }
    }
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"完善资料" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    self.quotaBtn = commitBtn;
    commitBtn.frame = CGRectMake(leftMargin, kHeight(280), kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:commitBtn];
    
}

- (void)creatIntroduce
{
        self.contentView.hidden = YES;

        self.contentView = [UIView new];
        self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
        [self.view addSubview:self.contentView];
        UILabel *Creditcoin = [UILabel labelWithText:@"信用分用途" textColor:RGB(153, 153, 153) textFont:14.0];
        self.Creditcoin = Creditcoin;
        [self.view addSubview:self.quotaView];
        Creditcoin.frame = CGRectMake(15, 23, kScreenWidth-30, 30);
        Creditcoin.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:Creditcoin];

        UILabel *Creditcoin1 = [UILabel labelWithText:@"1 信用分即额度,可申请贷款" textColor:RGB(153, 153, 153) textFont:14.0];
        self.Creditcoin1 = Creditcoin1;
        [self.view addSubview:self.Creditcoin1];
        Creditcoin1.frame = CGRectMake(15, self.Creditcoin.yy+13, kScreenWidth-30, 30);
        Creditcoin1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:Creditcoin1];
    
        UILabel *Creditcoin2 = [UILabel labelWithText:@"2 信用分越多借款额越多" textColor:RGB(153, 153, 153) textFont:14.0];
        self.Creditcoin2 = Creditcoin2;
        [self.view addSubview:self.Creditcoin2];
        Creditcoin2.frame = CGRectMake(15, self.Creditcoin1.yy+13, kScreenWidth-30, 30);
        Creditcoin2.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:Creditcoin2];
        CGFloat quotaBtnH = 45;

        self.quotaBtn = [UIButton buttonWithTitle:@"去认证" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
        self.quotaBtn.frame = CGRectMake(15, Creditcoin2.yy + 44, kScreenWidth - 30, quotaBtnH);
    
        [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.contentView addSubview:self.quotaBtn];

}

- (void)BegincreatIntroduce
{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView = [UIView new];

    self.contentView.frame = CGRectMake(0, self.quotaView.yy, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
    CGFloat quotaBtnH = 45;
    
    self.quotaBtn = [UIButton buttonWithTitle:@"继续认证" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:quotaBtnH/2.0];
    
    self.quotaBtn.frame = CGRectMake(15,  80, kScreenWidth - 30, quotaBtnH);
    
    [self.quotaBtn addTarget:self action:@selector(clickUseQuota:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.quotaBtn];
}


#pragma mark - Events
- (void)clickUseQuota:(UIButton *)sender {
    //根据额度状态进行不同的跳转
    
    switch (self.flag) {
        case 0:
        {
            //调用申请信用分
            [self requestScore];

            
        }break;
            
        case 1:
        {
            //完善资料
            [self requestGood];

           
        }break;
            
        case 2:
        {
            //请耐心等待
//            [self requestGood];
            
            
        }break;
            
        case 3:
        {
            //重新提交
            [self requestScoreAgain];
            
        }break;
        case 4:
        {
            //使用信用分

            TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
            
            tabbarVC.currentIndex = 0;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }break;
        case 5:
        {
            //重新申请
            [self requestScoreAgain];

        }break;
       
        case 6:
        {
            //重新申请
//            [self requestScore];
            [self requestScoreAgain];

            
        }break;
        default:
            break;
    }
    
}

- (void)requestGood {
    
//    TLNetworking *http = [TLNetworking new];
//
//    http.code = @"623013";
//
//    http.parameters[@"userId"] = [TLUser user].userId;
//
//    [http postWithSuccess:^(id responseObject) {
//
//        if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
//
////            SelectMoneyVC *moneyVC = [SelectMoneyVC new];
            NewAuthVC * authVC = [NewAuthVC new];
            authVC.title = @"认证";
            
//            authVC.selectType = SelectGoodTypeSign;
            
            [self.navigationController pushViewController:authVC animated:YES];
            
//        }
//
//    } failure:^(NSError *error) {
////        SelectMoneyVC *moneyVC = [SelectMoneyVC new];
//        NewAuthVC * authVC = [NewAuthVC new];
//
//        authVC.title = @"认证";
//
////        authVC.selectType = SelectGoodTypeSign;
//
//        [self.navigationController pushViewController:authVC animated:YES];
//
//    }];
    
}
- (void)initDataView {
    
    BaseWeakSelf;
    
    self.bgSV.height -= 49;
    
    self.dataView = [[DataView alloc] initWithFrame:CGRectMake(0, self.quotaView.yy, kScreenWidth, kSuperViewHeight - 49)];
    
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
//
//    [MoxieSDK shared].delegate = self;
//    [MoxieSDK shared].mxUserId = kMoXieUserID;
//    [MoxieSDK shared].mxApiKey = [TLUser user].mxApiKey;
//    [MoxieSDK shared].fromController = self;
//
//    [MoxieSDK shared].taskType = @"carrier";
//    //跳过输入身份证和姓名界面
//    [MoxieSDK shared].carrier_phone = [TLUser user].mobile;
//    [MoxieSDK shared].carrier_name = identify.realName;
//    [MoxieSDK shared].carrier_idcard = identify.idNo;
////    [MoxieSDK shared].carrier_editable = YES;
//
//    [MoxieSDK shared].backImageName = @"返回";
//
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    //开始运营商认证
//    [[MoxieSDK shared] startFunction];
    
}

#pragma mark - Data
- (void)requestAuthStatus {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623050";
    
    if (!self.isFirst) {
        
        http.showView = self.view;
    }
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.dataView.authModel = self.authModel;
        
        self.isFirst = YES;
        //如果运营商状态是认证中，就不停刷定时器
        if ([self.authModel.infoCarrierFlag isEqualToString:@"3"]) {
            
//            [TLProgressHUD show];
            //查看认证状态
            [self requestCarrierStatus];
            //获取用户当前正在进行的申请记录
            [self requestToApproveFlag];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestMXApiKey {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623917";
    http.parameters[@"key"] = @"mxApiKey";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLUser user].mxApiKey = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)requestToApproveFlag {
    
    //获取用户当前正在进行的申请记录
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623032";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //申请状态
        self.isApply = responseObject[@"data"][@"toApproveFlag"];
        
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
//                if (self.authModel.infoCarrierFlag) {
                    
//                    [self initMXSDK];
                    
                    TongDunVC *tongDunVC = [TongDunVC new];
                    
                    tongDunVC.respBlock = ^(NSString *taskId) {
                        
                        [weakSelf authRespWithTaskId:taskId];
                    };
                    
                    [self.navigationController pushViewController:tongDunVC animated:YES];
                    
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

- (void)result:(NSMutableDictionary*)dic {
    NSLog(@"result ");
    
    NSString* system  = [[UIDevice currentDevice] systemVersion];
    if([system intValue]>=7){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    
}

#pragma mark - MoxieSDKDelegate

- (void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary {
    
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

#pragma mark - 同盾回调
- (void)authRespWithTaskId:(NSString *)taskId {
    
    //获取用户当前正在进行的申请记录
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623056";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"taskId"] = taskId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self requestCarrierStatus];
        
    } failure:^(NSError *error) {
        
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
        
        self.dataView.authModel = self.authModel;
        
        //运营商是否已认证
        if ([self.authModel.infoCarrierFlag isEqualToString:@"1"]) {
            
            [TLProgressHUD dismiss];

//            [TLAlert alertWithTitle:@"" message:@"运营商认证成功" confirmMsg:@"OK" confirmAction:^{
//
//                if ([self.isApply isEqualToString:@"1"]) {
//
//                    //进入系统审核界面
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                        ManualAuditVC *auditVC = [ManualAuditVC new];
//
//                        auditVC.title = @"系统审核";
//
//                        [self.navigationController pushViewController:auditVC animated:YES];
//                    });
//                }
//
//            }];
        } else if([self.authModel.infoCarrierFlag isEqualToString:@"3"]){
            
            //重复调认证状态接口
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self requestCarrierStatus];

            });
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
