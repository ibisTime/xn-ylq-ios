//
//  IntegralTaskListVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralTaskListVC.h"

#import "IntregalTaskModel.h"
#import "ZHCurrencyModel.h"

#import "IntregalTaskHeaderView.h"

#import "IntregalTaskCell.h"

//#import "HealthTestVC.h"
//#import "AssessmentVC.h"
#import "IntregalFlowVC.h"
//#import "HTMLStrVC.h"

#import "TabbarViewController.h"

@interface IntegralTaskListVC ()<UITableViewDelegate, UITableViewDataSource, IntregalTaskDelegate>

@property (nonatomic, strong) IntregalTaskHeaderView *headerView;

@property (nonatomic, strong) TLTableView *tabeleView;

@property (nonatomic, strong) NSMutableArray <IntregalTaskModel *>*tasks;

@property (nonatomic, copy) NSString *accountNumber;

@end

@implementation IntegralTaskListVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestIntregalTaskList];
    
    [self requestUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的积分"];
    
//    [UIBarButtonItem addRightItemWithTitle:@"积分规则" frame:CGRectMake(0, 0, 80, 20) vc:self action:@selector(intregalRule)];
    
    self.tasks = [NSMutableArray array];
    
    [self initHeaderView];
    
//    [self initTableView];
    
}

#pragma mark - Init
- (void)initHeaderView {

    self.headerView = [[IntregalTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    self.headerView.taskType = IntregalTaskTypeTask;
    
    self.headerView.delegate = self;
    
    [self.view addSubview:self.headerView];
    
}

- (void)initTableView {

    self.tabeleView = [TLTableView tableViewWithFrame:CGRectMake(0, self.headerView.yy + 10, kScreenWidth, kSuperViewHeight - self.headerView.yy - 10) delegate:self dataSource:self];
    
    self.tabeleView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无任务"];
    
    [self.view addSubview:self.tabeleView];
}

#pragma mark - Data
- (void)requestIntregalTaskList {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"621915";
    http.parameters[@"type"] = @"1";
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"100";
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.tasks removeAllObjects];
        
        //添加模型，第一个写死

        IntregalTaskModel *model = [IntregalTaskModel new];
        
        model.note = @"商城购物";
        
        model.value = @"1:1分值";
        
        model.ckey = @"scgw";
        
        model.isFirst = YES;
        
        [self.tasks addObject:model];

        NSArray *arr = [IntregalTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        
        [self.tasks addObjectsFromArray:arr];
        
        [self.tabeleView reloadData];
        
    } failure:^(NSError *error) {
        
        
        
    }];
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
                
                weakSelf.accountNumber = obj.accountNumber;
                
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
    
    return self.tasks.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    
    IntregalTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntregalTaskCell"];
    
    if (!cell) {
        
        cell = [[IntregalTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntregalTaskCell"];
    }
    
    cell.task = self.tasks[indexPath.row];
    
    cell.comfirmBtn.tag = 2800 + indexPath.row;
    
    [cell.comfirmBtn addTarget:self action:@selector(getIntregal:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    UILabel *textLabel = [UILabel labelWithText:@"今日可赚积分列表" textColor:[UIColor textColor] textFont:13.0];
    
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

#pragma makr - IntregalTaskDelegate

- (void)didSelectedWithType:(IntregalTaskType)type idx:(NSInteger)idx {

    switch (type) {
        case IntregalTaskTypeFlow:
        {
        
            IntregalFlowVC *flowVC = [IntregalFlowVC new];
            
            flowVC.accountNumber = self.accountNumber;
            
            [self.navigationController pushViewController:flowVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - Events

- (void)intregalRule {

//    HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//    htmlVC.type = HTMLTypeIntregalRule;
//
//    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)getIntregal:(UIButton *)sender {

    TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
    
    NSInteger index = sender.tag - 2800;
    
    IntregalTaskModel *model = self.tasks[index];
    
    if ([model.ckey isEqualToString:@"scgw"]) {
        
        self.tabBarController.selectedIndex = 4;
        
        tabbarVC.currentIndex = 4;
        
        [self.navigationController popToRootViewControllerAnimated:NO];

        
    } else if ([model.ckey isEqualToString:@"jkrw"]) {
    
        self.tabBarController.selectedIndex = 0;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else if ([model.ckey isEqualToString:@"jbfxpg"]) {
        
//        AssessmentVC *assessmentVC = [AssessmentVC new];
//
//        [self.navigationController pushViewController:assessmentVC animated:YES];
        
    } else if ([model.ckey isEqualToString:@"jkpfcs"]) {
        
        self.tabBarController.selectedIndex = 0;
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else if ([model.ckey isEqualToString:@"jkzc"]) {
        
//        HealthTestVC *testVC = [HealthTestVC new];
//
//        [self.navigationController pushViewController:testVC animated:YES];
        
    } else if ([model.ckey isEqualToString:@"ft"] || [model.ckey isEqualToString:@"tzbpl"] || [model.ckey isEqualToString:@"tzbdz"] || [model.ckey isEqualToString:@"pl"] || [model.ckey isEqualToString:@"dz"]) {
    
        self.tabBarController.selectedIndex = 1;

        tabbarVC.currentIndex = 1;

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
