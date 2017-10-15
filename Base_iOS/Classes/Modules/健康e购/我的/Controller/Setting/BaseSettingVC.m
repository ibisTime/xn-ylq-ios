//
//  BaseSettingVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseSettingVC.h"
#import "CustomTabBar.h"
#import "SettingGroup.h"

#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "TLUserForgetPwdVC.h"
#import "ZHAddressChooseVC.h"
#import "ZHBankCardListVC.h"
#import "BaseHTMLStrVC.h"

#import "SettingModel.h"
#import "SettingCell.h"

@interface BaseSettingVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, copy) NSString *cacheStr;

@property (nonatomic, strong) UITableView *mineTableView;

@end

@implementation BaseSettingVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.mineTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"设置"];
    
    [self initTableView];
    
    [self setGroup];
    
    //    UILabel *label = [UILabel labelWithText:@"Copyright ©2017-2020\n金华金桥电子商务有限公司" textColor:[UIColor textColor2] textFont:14.0];
    //
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = kClearColor;
    //    label.numberOfLines = 0;
    //    [self.view addSubview:label];
    //    [label mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.mas_equalTo(0);
    //        make.width.mas_equalTo(kScreenWidth);
    //        make.height.mas_lessThanOrEqualTo(40);
    //        make.bottom.mas_equalTo(-20);
    //
    //    }];
    
}

- (void)initTableView {
    
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    
    mineTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    [self.view addSubview:mineTableView];
    
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    mineTableView.rowHeight = 45;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    mineTableView.tableFooterView = footerView;
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    
    _mineTableView = mineTableView;
}

- (void)setGroup {
    
    BaseWeakSelf;
    //
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = @"修改手机号";
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
        
    }];
    
    //
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    //
    SettingModel *changePhone = [SettingModel new];
    changePhone.text = @"修改支付密码";
    [changePhone setAction:^{
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    //
    SettingModel *bankCard = [SettingModel new];
    bankCard.text = @"银行卡";
    [bankCard setAction:^{
        
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    SettingModel *address = [SettingModel new];
    address.text = @"收货地址";
    [address setAction:^{
        
        ZHAddressChooseVC *chooseVC = [ZHAddressChooseVC new];
        
        
        [self
         .navigationController pushViewController:chooseVC animated:YES];
    }];
    
    SettingModel *aboutUs = [SettingModel new];
    aboutUs.text = @"关于我们";
    [aboutUs setAction:^{
        
        BaseHTMLStrVC *htmlVC = [BaseHTMLStrVC new];
        
        htmlVC.type = HTMLTypeAboutUs;
        
        [self.navigationController pushViewController:htmlVC animated:YES];
    }];
    
    self.group = [SettingGroup new];
    
    self.group.groups = @[@[changeMobile, changeLoginPwd, changePhone], @[bankCard, address, aboutUs]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 30, 45)];
        _loginOutBtn.backgroundColor = kAppCustomMainColor;
        [_loginOutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
    
}

- (void)logout {
    
    UITabBarController *tbcController = self.tabBarController;
    
    //
    [self.navigationController popViewControllerAnimated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tbcController.selectedIndex = 0;
        
        CustomTabBar *tabBar = (CustomTabBar *)tbcController.tabBar;
        tabBar.selectedIdx = 0;
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.group.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.group.items = self.group.groups[section];
    
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
    
    self.group.items = self.group.groups[indexPath.section];
    
    cell.textLabel.text = self.group.items[indexPath.row].text;
    
    if (indexPath.section == 0) {
        
        cell.rightLabel.text = indexPath.row == 0 ? [TLUser user].mobile: @"";
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.groups[indexPath.section];
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
