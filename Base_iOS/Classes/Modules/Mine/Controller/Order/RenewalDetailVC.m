//
//  RenewalDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RenewalDetailVC.h"
#import "RenewalDetailTableView.h"

@interface RenewalDetailVC ()

@property (nonatomic, strong) RenewalDetailTableView *tableView;

@end

@implementation RenewalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"续期详情";
    
    [self initTableView];
}

#pragma mark - Init
- (void)initTableView {

    self.tableView = [[RenewalDetailTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.renewal = self.renewal;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
