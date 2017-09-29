//
//  MallOrderVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/17.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "MallOrderVC.h"

#import "SettingGroup.h"
#import "SettingModel.h"
#import "SettingCell.h"

#import "IntegralOrderVC.h"
#import "ZHShoppingListVC.h"

@interface MallOrderVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SettingGroup *group;

@end

@implementation MallOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"健康商城"];
    
    [self initTableView];
    
    [self setGroup];
}

- (void)initTableView {
    
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    mineTableView.backgroundColor = kPaleGreyColor;
    
    [self.view addSubview:mineTableView];
    
    mineTableView.rowHeight = 45;
    
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    
    _tableView = mineTableView;
}

- (void)setGroup {
    
    BaseWeakSelf;
    //
    SettingModel *goodOrder = [SettingModel new];
    goodOrder.text = @"商品订单";
    [goodOrder setAction:^{
        
        ZHShoppingListVC  *vc = [ZHShoppingListVC new];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //
    SettingModel *integralOrder = [SettingModel new];
    integralOrder.text = @"兑换订单";
    [integralOrder setAction:^{
        
        IntegralOrderVC *integralOrderVC = [IntegralOrderVC new];
        
        [weakSelf.navigationController pushViewController:integralOrderVC animated:YES];
        
    }];
    
    self.group = [SettingGroup new];

    self.group.items = @[goodOrder, integralOrder];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = FONT(14);
        
    }
    
    cell.textLabel.text = self.group.items[indexPath.row].text;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
