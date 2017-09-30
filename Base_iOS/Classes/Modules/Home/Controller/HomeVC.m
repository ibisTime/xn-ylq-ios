//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/3.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"
#import "GoodView.h"
#import "NSAttributedString+add.h"

#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "TabbarViewController.h"
#import "SelectMoneyVC.h"
#import "ManualAuditVC.h"
#import "MyQuotaVC.h"
#import "LoanFailureVC.h"
#import "LoanVC.h"
#import "LoanOrderDetailVC.h"
#import "RepaymentVC.h"
#import "NoticeVC.h"

#import "TLPageDataHelper.h"

#import "GoodModel.h"
#import "UpdateModel.h"

@interface HomeVC ()

@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, strong) NSArray <GoodModel *>*goods;

@property (nonatomic, strong) GoodView *goodView;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) NSArray <UpdateModel *>*updates;

@end

@implementation HomeVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kWhiteColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self reuqestGoods];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UIButton buttonWithTitle:@"九州宝" titleColor:kTextColor backgroundColor:kClearColor titleFont:kWidth(18.0)];

    [UIBarButtonItem addRightItemWithImageName:@"消息" frame:CGRectMake(0, 0, 18, 13) vc:self action:@selector(notice)];
    
    _isFirst = YES;
    
    [self configUpdate];

}

- (void)initGoodView {

    BaseWeakSelf;
    
    CGFloat leftMargin = 15;
    
    CGFloat topMargin = 10;
    
    CGFloat viewW = kScreenWidth - 2*leftMargin;
    
    CGFloat viewH = kWidth(135);
    
    CGFloat y = 0;
    
    self.bgSV.height = kScreenHeight - 64 - 49;

    self.bgSV.backgroundColor = kBackgroundColor;
    
    for (int i = 0; i < self.goods.count; i++) {
        
        GoodView *goodView = [[GoodView alloc] initWithFrame:CGRectMake(leftMargin, topMargin + i*(topMargin + viewH), viewW, viewH)];
        
        goodView.tag = 1220 + i;
        
        goodView.goodModel = self.goods[i];

        goodView.loanBlock = ^(LoanType loanType, GoodModel *good) {
            
            [weakSelf loanEventWithType:loanType good:good];
        };
        
        self.goodView = goodView;
        
        [self.bgSV addSubview:goodView];
        
        y = goodView.yy;
        
    }
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:kWidth(11.0)];
    
    promptLbl.frame = CGRectMake(0, y + 10, kScreenWidth, kWidth(15));
    
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    NSAttributedString *promptAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"产品" index:0 string:@" 更多产品敬请期待" labelHeight:kWidth(15)];
    
    promptLbl.attributedText = promptAttrStr;
    
    [self.bgSV addSubview:promptLbl];
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, promptLbl.yy + 5);

}

#pragma mark - Events
- (void)loanEventWithType:(LoanType)loanType good:(GoodModel *)good {

    BaseWeakSelf;
    
    switch (loanType) {
        case LoanTypeFirstStep:
        {
            if ([good.isLocked isEqualToString:@"0"]) {
                
                [self loanStatusWithGood:good];

            } else if ([good.isLocked isEqualToString:@"1"]) {
            
                [TLAlert alertWithTitle:@"" message:@"尊敬的用户,该款产品,您还不能申请" confirmMsg:@"OK" confirmAction:^{
                    
                }];
            }
            
        }break;
            
        case LoanTypeSecondStep:
        {
            
        }break;
            
        case LoanTypeCancel:
        {
            [TLAlert alertWithTitle:@"" msg:@"真的要取消这次借款申请？" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"623021";
                
                http.parameters[@"applyUser"] = [TLUser user].userId;
                http.parameters[@"productCode"] = good.code;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"取消成功"];
                    
                    [self reuqestGoods];
                    
                } failure:^(NSError *error) {
                    
                    
                }];
            }];
            
        }break;
            
        default:
            break;
    }
}

- (void)loanStatusWithGood:(GoodModel *)good {
    
    NSInteger status = [good.userProductStatus integerValue];
    
    switch (status) {
        case 0:
        {
            //选择产品
            SelectMoneyVC *moneyVC = [SelectMoneyVC new];
            
            moneyVC.title = @"产品详情";
            
            moneyVC.selectType = SelectGoodTypeAuth;
            
            moneyVC.code = good.code;
            
            [self.navigationController pushViewController:moneyVC animated:YES];
            
        
        }break;
            
        case 1:
        {
        
            //认证中
            TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
            
            tabbarVC.currentIndex = 1;
            
        }break;
          
        case 2:
        {
            //系统审核
            ManualAuditVC *auditVC = [ManualAuditVC new];
            
            auditVC.title = @"系统审核";
            
            [self.navigationController pushViewController:auditVC animated:YES];
            
            
        }break;
            
        case 3:
        {
            //额度申请失败
            LoanFailureVC *failureVC = [LoanFailureVC new];
            
            failureVC.good = good;
            
            [self.navigationController pushViewController:failureVC animated:YES];
            
        }break;
            
        case 4:
        {
            //已有额度
            MyQuotaVC *quotaVC = [[MyQuotaVC alloc] init];
            
            quotaVC.title = @"我的额度";
            
            [self.navigationController pushViewController:quotaVC animated:YES];
        }break;
            
        case 5:
        {
            //放款中
            LoanVC *loanVC = [LoanVC new];
            
            loanVC.borrowCode = good.borrowCode;
            
            [self.navigationController pushViewController:loanVC animated:YES];

        }break;
        
        case 6://待还款
        case 7://已逾期
        case 11://打款失败

        {
            
            [self requestOrderWithCode:good.borrowCode];
            
        }break;
            
        default:
            break;
    }
    
}

- (void)notice {

    NoticeVC *noticeVC = [NoticeVC new];
    
    [self.navigationController pushViewController:noticeVC animated:YES];
}

#pragma mark - Data
- (void)reuqestGoods {

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    if (_isFirst) {
        
        helper.showView = self.view;

    }
    
    helper.code = @"623012";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    [helper modelClass:[GoodModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        if (objs.count > 0) {
            
            self.goods = objs;
            
            _isFirst = NO;
            
            for (UIView *subview in self.bgSV.subviews) {
                
                [subview removeFromSuperview];
            }
            
            [self initGoodView];
            
        }
        
    } failure:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self reuqestGoods];
        });
        
    }];
    
}

- (void)requestOrderWithCode:(NSString *)code {

    LoanOrderDetailVC *detailVC = [[LoanOrderDetailVC alloc] init];
    
    detailVC.code = code;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - Config
- (void)configUpdate {
    
    //1:iOS 2:安卓
    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.code = @"805918";
    http.parameters[@"type"] = @"ios-c";
    
    [http postWithSuccess:^(id responseObject) {
        
        UpdateModel *update = [UpdateModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //获取当前版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![currentVersion isEqualToString:update.version]) {
            //1：强制，0：不强制
            if ([update.forceUpdate isEqualToString:@"0"]) {
                
                [TLAlert alertWithTitle:@"更新提醒" msg:update.note confirmMsg:@"立即升级" cancleMsg:@"稍后提醒" cancle:^(UIAlertAction *action) {
                    
                } confirm:^(UIAlertAction *action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.downloadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                    
                }];
                
            } else {
                
                [TLAlert alertWithTitle:@"更新提醒" message:update.note confirmMsg:@"立即升级" confirmAction:^{
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.downloadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        exit(0);
                        
                    });
                }];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
