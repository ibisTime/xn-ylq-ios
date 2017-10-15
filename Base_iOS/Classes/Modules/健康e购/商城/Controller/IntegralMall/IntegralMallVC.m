//
//  IntegralMallVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/17.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralMallVC.h"

#import "IntegralMallHeaderView.h"
#import "GoodListCell.h"
#import "IntegralHotGoodCell.h"

#import "IntegralMallListModel.h"
#import "ZHCurrencyModel.h"
#import "GoodModel.h"
#import "TableViewManager.h"

#import "IntegralGoodDetailVC.h"
#import "IntegralTaskListVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface IntegralMallVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IntegralMallHeaderView *headerView;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <GoodModel *>*integralGoods;

@property (nonatomic, strong) NSMutableArray <GoodModel *>*hotGoods;

@property (nonatomic, strong) TableViewManager *manager;

@end

@implementation IntegralMallVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestUserInfo];

    [self.tableView beginRefreshing];
    
    if (![TLUser user].userId) {
        
        [self.headerView logout];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"积分商城"];
    
    [self addNotifications];

    [self initManager];
    
    [self initTableView];
    
    [self initHeaderView];
    
    [self requestIntegralGoods];

}

#pragma mark - Init

- (void)initManager {

    self.integralGoods = [NSMutableArray array];
    
    self.hotGoods = [NSMutableArray array];
    
    self.manager = [[TableViewManager alloc] init];
    
    TableViewModel *hotModel = [[TableViewModel alloc] init];
    
    hotModel.headerSectionHeight = 42;
    
    hotModel.footerSectionHeight = 0.1;
    
    hotModel.rowHeight = kScreenWidth + 105;
    
    hotModel.rowNum = 3;
    
    TableViewModel *jFModel = [[TableViewModel alloc] init];
    
    jFModel.headerSectionHeight = 42;
    
    jFModel.footerSectionHeight = 0.1;
    
    jFModel.rowHeight = 105;
    
    jFModel.rowNum = 1;
    
    self.manager.items = @[hotModel, jFModel];
}

- (void)initTableView {

    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) delegate:self dataSource:self];
    
    [self.tableView registerClass:[GoodListCell class] forCellReuseIdentifier:@"IntegralGoodCellId"];
    
    [self.tableView registerClass:[IntegralHotGoodCell class] forCellReuseIdentifier:@"IntegralHotGoodCellId"];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    [self.view addSubview:self.tableView];
    
}

- (void)initHeaderView {

    BaseWeakSelf;
    
    self.headerView = [[IntegralMallHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70) btnEvnets:^{
        
        if (![TLUser user].userId) {
            
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            
            return;
        }
        
        IntegralTaskListVC *taskVC = [IntegralTaskListVC new];
        
        [weakSelf.navigationController pushViewController:taskVC animated:YES];
        
    }];
    
    [self.headerView changeInfo];
    
    self.tableView.tableHeaderView = self.headerView;
    
}

#pragma mark - Notifications
- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

- (void)changeInfo {
    
    [self.headerView changeInfo];
    
}

- (void)loginOut {
    
    //
    
    [self.headerView logout];
    
}

#pragma mark - Data

- (void)requestHotGoods {

    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808025";

    helper.parameters[@"kind"] = @"2";

    helper.parameters[@"status"] = @"3";
    helper.parameters[@"location"] = @"1";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [weakSelf.hotGoods removeAllObjects];
        
        weakSelf.hotGoods = objs;
        
        [weakSelf.tableView reloadData_tl];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)requestIntegralGoods {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808025";
    
    helper.parameters[@"kind"] = @"2";

    helper.parameters[@"status"] = @"3";
    helper.parameters[@"location"] = @"0";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf requestHotGoods];
            
            weakSelf.integralGoods = objs;
            
            [weakSelf.tableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.integralGoods = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)requestUserInfo {

    BaseWeakSelf;
    //刷新rmb和积分
    TLNetworking *sjHttp = [TLNetworking new];
    sjHttp.code = @"802503";
    sjHttp.parameters[@"userId"] = [TLUser user].userId;
    
    if (![TLUser user].token) {
        
        return;
    }
    
    sjHttp.parameters[@"token"] = [TLUser user].token;
    [sjHttp postWithSuccess:^(id responseObject) {
        
        NSArray <ZHCurrencyModel *> *arr = [ZHCurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"JF"]) {
                
                weakSelf.headerView.jfNum = [obj.amount convertToRealMoney];
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
//                weakSelf.headerView.rmbNum = [obj.amount convertToRealMoney];
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.manager.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.hotGoods.count;
    }
    
    return self.integralGoods.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *integralHotGoodCellId = @"IntegralHotGoodCellId";
        
        IntegralHotGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:integralHotGoodCellId forIndexPath:indexPath];
        
        cell.integralModel = self.hotGoods[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    static NSString *zhgoodCellId = @"IntegralGoodCellId";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:zhgoodCellId];
    
    cell.integralModel = self.integralGoods[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        GoodModel *integralGood = self.hotGoods[indexPath.row];
        
        IntegralGoodDetailVC *detailVC = [[IntegralGoodDetailVC alloc] init];
        detailVC.goods = integralGood;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else {
    
        GoodModel *integralGood = self.integralGoods[indexPath.row];
        
        IntegralGoodDetailVC *detailVC = [[IntegralGoodDetailVC alloc] init];
        detailVC.goods = integralGood;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewModel *model = self.manager.items[indexPath.section];
    
    return model.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (self.hotGoods.count == 0) {
            
            return 0.1;
        }
        
    } else if (section == 1) {
    
        if (self.integralGoods.count == 0) {
            
            return 0.1;
        }
    }
    
    TableViewModel *model = self.manager.items[section];

    return model.headerSectionHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    TableViewModel *model = self.manager.items[section];

    return model.footerSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *names = @[@"热门兑换", @"积分兑换"];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    headView.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        
        if (self.hotGoods.count == 0) {
            
            return headView;
            
        }
        
    } else if (section == 1) {
        
        if (self.integralGoods.count == 0) {
            
            return headView;
        }
    }
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth, 42) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(15) textColor:[UIColor zh_textColor]];
    lbl.text = names[section];
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
