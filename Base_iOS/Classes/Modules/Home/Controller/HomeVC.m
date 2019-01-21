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
#import "LoanOrderVC.h"
#import "TLPageDataHelper.h"

#import "ProductModel.h"
#import "UpdateModel.h"
#import "QuotaModel.h"
#import "TLUserLoginVC.h"
#import "TLTableView.h"
@interface HomeVC ()<RefreshDelegate,UITableViewDataSource,UITableViewDelegate>;

@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <ProductModel *>*goods;

@property (nonatomic, strong) GoodView *goodView;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) NSArray <UpdateModel *>*updates;

@property (nonatomic, strong) QuotaModel *quota;

@property (nonatomic, strong) UIView *placeHolderView
;

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
    
    self.navigationItem.titleView = [UIButton buttonWithTitle:[NSString stringWithFormat:@
                                                               "%@",AppName] titleColor:[UIColor colorWithHexString:@"#0cb8ae"] backgroundColor:kClearColor titleFont:kWidth(18.0)];

   
//    [UIBarButtonItem addRightItemWithTitle:@"借款记录" frame:CGRectMake(0, 0, 18, 13) vc:self action:@selector(notice)];

    UIButton *butn = [UIButton buttonWithTitle:@"借款记录" titleColor:[UIColor colorWithHexString:@"#0cb8ae"] backgroundColor:kWhiteColor titleFont:16];
    [butn addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:butn];
    //
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0,0, kScreenWidth, 0.1) delegate:self dataSource:self];
    self.tableView = tableView;
    tableView.refreshDelegate = self;
    [self.view addSubview:tableView];
    
    
    _isFirst = YES;
    
//    [self configUpdate];
//    [self requestQiniu];
    if ([TLUser user].isLogin) {
            [self requestQuota];
        }
    
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无产品");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"暂无产品" textColor:kTextColor textFont:15];
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [self.view addSubview:self.placeHolderView];
}
- (void)initGoodView {

    BaseWeakSelf;
    
    CGFloat leftMargin = 15;
    
    CGFloat topMargin = 10;
    
    CGFloat viewW = kScreenWidth - 2*leftMargin;
    
    CGFloat viewH = kWidth(135);
    
    CGFloat y = 0;
    
    self.bgSV.height = kSuperViewHeight - kTabBarHeight;

    self.bgSV.backgroundColor = kBackgroundColor;
    
    for (int i = 0; i < self.goods.count; i++) {
        
        GoodView *goodView = [[GoodView alloc] initWithFrame:CGRectMake(leftMargin, topMargin + i*(topMargin + viewH), viewW, viewH)];
        
        goodView.tag = 1220 + i;
        
        goodView.productModel = self.goods[i];

        goodView.loanBlock = ^(LoanType loanType, ProductModel *good) {
            
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
- (void)loanEventWithType:(LoanType)loanType good:(ProductModel *)good {

    BaseWeakSelf;
    
        if (![TLUser user].isLogin) {
    
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            loginVC.loginSuccess = ^(){
    
            };
            return;
        }
    
    switch (loanType) {
        case LoanTypeFirstStep:
        {
            if ([good.isLocked isEqualToString:@"0"]) {
                
                [self loanStatusWithGood:good];

            } else if ([good.isLocked isEqualToString:@"1"]) {
            
                [TLAlert alertWithTitle:@"" message:@"尊敬的用户,该款产品,您还不能申请" confirmMsg:@"OK" confirmAction:^{
                    
                }];
            }else{
                
                [self loanStatusWithGood:good];

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


- (void)requestQuota {
    
    //--//
    //刷新额度
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.quota = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        
      
        
    } failure:^(NSError *error) {
        
        
    }];
}



- (void)loanStatusWithGood:(ProductModel *)good {
    
    
    
    SelectMoneyVC *moneyVC = [SelectMoneyVC new];
    
    moneyVC.title = @"产品详情";
    
    moneyVC.selectType = SelectGoodTypeAuth;
    
    moneyVC.code = good.code;
    
    [self.navigationController pushViewController:moneyVC animated:YES];
    return;
    
    NSInteger status = [good.userProductStatus integerValue];
    
    switch (status) {
        case 0:
        {
            
//            NSInteger flag = [self.quota.flag integerValue];
//            NSInteger money = [[self.quota.sxAmount convertToSimpleRealMoney] integerValue];
//
//            NSString *title = @"";
//
//            switch (flag) {
//                case 0:
//                {
//
//                    TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
//
//                    tabbarVC.currentIndex = 1;
//
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//
//
//                }break;
//
//                case 1:
//                {
//                    if (money > 0) {
//
                    //选择产品
                    SelectMoneyVC *moneyVC = [SelectMoneyVC new];
                    
                    moneyVC.title = @"产品详情";
                    
                    moneyVC.selectType = SelectGoodTypeAuth;
                    
                    moneyVC.code = good.code;
                    
                    [self.navigationController pushViewController:moneyVC animated:YES];
//                        }
//                    else{
//                        TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
//                        
//                        tabbarVC.currentIndex = 1;
//                        
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                    
//                }break;
//                    
//                case 2:
//                {
//                    TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
//                    
//                    tabbarVC.currentIndex = 1;
//                    
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }break;
//                    
//                default:
//                    break;
//            }
//            
            
            
         
        
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
            
            quotaVC.title = @"信用分";
            
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
    if ( ![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    LoanOrderVC *noticeVC = [LoanOrderVC new];
    
    [self.navigationController pushViewController:noticeVC animated:YES];
}

#pragma mark - Data
- (void)reuqestGoods {
    [self.tableView beginRefreshing];
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//
//    if (_isFirst) {
//
//        helper.showView = self.view;
//
//    }
    helper.code = @"623012";
    if ([[TLUser user] isLogin]) {
        helper.parameters[@"userId"] = [TLUser user].userId;

    }else{
//        return;
    }
    [helper modelClass:[ProductModel class]];
    helper.tableView = self.tableView;
    
    [self.tableView addRefreshAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count > 0) {
                
                self.goods = objs;
                
                _isFirst = NO;
                
                for (UIView *subview in self.bgSV.subviews) {
                    
                    [subview removeFromSuperview];
                }
                [self.tableView endRefreshingWithNoMoreData_tl];

                [self initGoodView];
                
            }else{
                [self initPlaceHolderView];
            }
            
        } failure:^(NSError *error) {
            [NSThread sleepForTimeInterval:5.0];
            [self reuqestGoods];
            
        }];
    }];
    [self.tableView addLoadMoreAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count > 0) {
                
                self.goods = objs;
                
                _isFirst = NO;
                
                for (UIView *subview in self.bgSV.subviews) {
                    
                    [subview removeFromSuperview];
                }
                [self.tableView endRefreshingWithNoMoreData_tl];

                [self initGoodView];
                
            }else{
                [self initPlaceHolderView];
            }
            
        } failure:^(NSError *error) {
            
            [NSThread sleepForTimeInterval:5.0];
            [self reuqestGoods];
            
        }];
    }];
    [self.tableView beginRefreshing];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = FONT(14);
        
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
