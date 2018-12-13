//
//  RenewalDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalDetailVC.h"
#import "RenewalDetailTableView.h"
#import "RenwalListView.h"
@interface RenewalDetailVC ()

@property (nonatomic, strong) RenewalDetailTableView *tableView;
@property (nonatomic, strong)RenwalListView *mineHeaderView;
@end

@implementation RenewalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"分期详情";
    
    [self initTableView];
}

#pragma mark - Init
- (void)initTableView {

    self.tableView = [[RenewalDetailTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.renewal = self.renewal;
    
    [self.view addSubview:self.tableView];
    RenwalListView *mineHeaderView = [[RenwalListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    self.tableView.tableHeaderView = mineHeaderView;
    
    self.mineHeaderView = mineHeaderView;
    self.mineHeaderView.quotaModel = self.renewal;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
