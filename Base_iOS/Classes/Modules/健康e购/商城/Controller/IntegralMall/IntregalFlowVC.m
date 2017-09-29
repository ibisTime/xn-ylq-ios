//
//  IntregalFlowVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalFlowVC.h"
#import "IntregalTaskHeaderView.h"
#import "IntregalRecordCell.h"

#import "ZHCurrencyModel.h"
#import "IntregalRecordModel.h"

#import "HTMLStrVC.h"

@interface IntregalFlowVC ()

@property (nonatomic, strong) IntregalTaskHeaderView *headerView;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSMutableArray <IntregalRecordModel *>*recodes;

@end

@implementation IntregalFlowVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestIntregalRecodeList];
    
    [self requestUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"积分记录"];
    
    [UIBarButtonItem addRightItemWithTitle:@"积分规则" frame:CGRectMake(0, 0, 80, 20) vc:self action:@selector(intregalRule)];

    self.recodes = [NSMutableArray array];

    [self initHeaderView];
    
    [self initTableView];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[IntregalTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    self.headerView.taskType = IntregalTaskTypeFlow;
    
    [self.view addSubview:self.headerView];
    
}

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, self.headerView.yy + 10, kScreenWidth, kScreenHeight - kNavigationBarHeight - self.headerView.yy - 10) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录" topMargin:40];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestIntregalRecodeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802520";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"currency"] = @"JF";
    helper.parameters[@"accountType"] = @"C";
    helper.parameters[@"accountNumber"] = self.accountNumber;
    
    [helper modelClass:[IntregalRecordModel class]];
    
    //积分记录
    [helper refresh:^(NSMutableArray <IntregalRecordModel *>*objs, BOOL stillHave) {
        
        weakSelf.recodes = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray <IntregalRecordModel *>*objs, BOOL stillHave) {
            
            weakSelf.recodes = objs;
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
                
                weakSelf.headerView.jfNumText = [obj.amount convertToRealMoney];
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                //                weakSelf.headerView.rmbNum = [obj.amount convertToRealMoney];
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma tableView -- dataSource
//--//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recodes.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    
    IntregalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntregalRecordCell"];
    
    if (!cell) {
        
        cell = [[IntregalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntregalRecordCell"];
    }
    
    cell.task = self.recodes[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    headerView.backgroundColor = kWhiteColor;
    
    UILabel *textLabel = [UILabel labelWithText:@"收支明细" textColor:[UIColor textColor] textFont:13.0];
    
    [headerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_lessThanOrEqualTo(15);
        
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    
    line.backgroundColor = kPaleGreyColor;
    
    [headerView addSubview:line];
    
    return headerView;
}

#pragma mark - Events

- (void)intregalRule {
    
//    HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//    htmlVC.type = HTMLTypeIntregalRule;
//
//    [self.navigationController pushViewController:htmlVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
