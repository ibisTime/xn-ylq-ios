//
//  BaseInfoVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoVC.h"

#import "BaseInfoGroup.h"
#import "BaseInfoModel.h"
#import "AuthModel.h"

#import "BaseInfoCell.h"

#import "BaseInfoDetailVC.h"
#import "JobInfoVC.h"
#import "EmergencyContactVC.h"
#import "BankCardAuthVC.h"

@interface BaseInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseInfoGroup *group;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AuthModel *authModel;

@end

@implementation BaseInfoVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self requestAuthStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initTableView];
    
}

#pragma mark - Init

- (void)initFooterView {

    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    UIColor *bgColor = [_authModel.infoAntifraudFlag isEqualToString:@"1"] ? kGreyButtonColor: kAppCustomMainColor;

    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:bgColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, 50, kScreenWidth - 2*leftMargin, btnH);
    
    commitBtn.enabled = [_authModel.infoAntifraudFlag isEqualToString:@"1"] ? NO: YES;

    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:commitBtn];
    
    self.tableView.tableFooterView = footerView;
}

- (void)initTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    tableView.rowHeight = 45;
    
    tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    
    tableView.tableFooterView = [UIView new];
    
    _tableView = tableView;
}

- (void)setGroup {
    
    BaseWeakSelf;
    //
    BaseInfoModel *baseInfo = [BaseInfoModel new];
    baseInfo.text = @"基本信息";
    baseInfo.imgName = @"基本信息";
    baseInfo.isAuth = [self.authModel.infoBasicFlag boolValue];
    
    [baseInfo setAction:^{
        
        BaseInfoDetailVC *detailVC = [BaseInfoDetailVC new];
        
        detailVC.title = @"基本信息";
        
        detailVC.authModel = weakSelf.authModel;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        
    }];
    
    //
    BaseInfoModel *jobInfo = [BaseInfoModel new];
    jobInfo.text = @"职业信息";
    jobInfo.imgName = @"职业信息";
    jobInfo.isAuth = [self.authModel.infoOccupationFlag boolValue];
    
    [jobInfo setAction:^{
        
        JobInfoVC *jobInfoVC = [JobInfoVC new];
        
        jobInfoVC.title = @"职业信息";
        
        jobInfoVC.authModel = weakSelf.authModel;
        
        [weakSelf.navigationController pushViewController:jobInfoVC animated:YES];
        
    }];
    
    //
    BaseInfoModel *contact = [BaseInfoModel new];
    contact.text = @"紧急联系人";
    contact.imgName = @"紧急联系人";
    contact.isAuth = [self.authModel.infoContactFlag boolValue];
    
    [contact setAction:^{
        
        EmergencyContactVC *contactVC = [EmergencyContactVC new];
        
        contactVC.title = @"紧急联系人";
        
        contactVC.authModel = weakSelf.authModel;
        
        [weakSelf.navigationController pushViewController:contactVC animated:YES];
    }];
    
    //    BaseInfoModel *bankCardAuth = [BaseInfoModel new];
    //    bankCardAuth.text = @"银行卡认证";
    //    bankCardAuth.imgName = @"银行卡认证";
    //    bankCardAuth.isAuth = [self.authModel.infoBankcardFlag boolValue];
    //
    //    [bankCardAuth setAction:^{
    //
    //        BankCardAuthVC *bankCardAuthVC = [BankCardAuthVC new];
    //
    //        bankCardAuthVC.title = @"银行卡认证";
    //
    //        bankCardAuthVC.authModel = weakSelf.authModel;
    //
    //        [weakSelf.navigationController pushViewController:bankCardAuthVC animated:YES];
    //    }];
    
    self.group = [BaseInfoGroup new];
    
    //    self.group.items = @[baseInfo, jobInfo, contact, bankCardAuth];
    
    self.group.items = @[baseInfo, jobInfo, contact];
    
    
}

#pragma mark - Data
- (void)requestAuthStatus {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"623050";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self setGroup];
        
        [self initFooterView];
        
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickCommit {

    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"623052";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"wifimac"] = [NSString getWifiMacAddress];
    http.parameters[@"ip"] = [NSString getIPAddress:YES];
    
    [http postWithSuccess:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"kCurrentAuthStatus"];
        
        [TLUser user].currentAuth = 1;
        
//        [TLAlert alertWithSucces:@"提交成功"];

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        });

        [TLAlert alertWithTitle:@"" message:@"个人信息提交成功" confirmMsg:@"OK" confirmAction:^{
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseInfoCellID"];
    if (!cell) {
        
        cell = [[BaseInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BaseInfoCellID"];
        
    }
    
    BaseInfoModel *model = self.group.items[indexPath.row];
    
    cell.baseInfoModel = model;
    
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 5;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
