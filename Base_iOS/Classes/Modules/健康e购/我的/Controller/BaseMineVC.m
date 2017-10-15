//
//  BaseMineVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseMineVC.h"
#import "SettingGroup.h"
#import "BaseMineHeaderView.h"
#import "TLImagePicker.h"

#import "SettingCell.h"
#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"

#import "ZHCurrencyModel.h"
#import "NSAttributedString+add.h"

#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "UserDetailEditVC.h"
#import "MallOrderVC.h"
#import "BaseSettingVC.h"
#import "IntegralTaskListVC.h"
#import "InviteFriendVC.h"

@interface BaseMineVC ()<UITableViewDataSource,UITableViewDelegate,MineHeaderSeletedDelegate>

@property (nonatomic, strong) BaseMineHeaderView *headerView;
@property (nonatomic, strong) SettingGroup *group;
@property (nonatomic, strong) TLTableView *mineTableView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, strong) UILabel *mobileLbl;           //服务电话

@property (nonatomic, strong) UILabel *serviceTimeLbl;      //服务时间
@end

@implementation BaseMineVC

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([TLUser user].userId) {
        
        //获取用户信息
        [self requestUserInfo];
        //获取服务时间
        [self requestServiceTime];
        //获取服务电话
        [self requestServiceMobile];
    }
    
    //--//
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的";

    [UIBarButtonItem addLeftItemWithImageName:@"" frame:CGRectMake(0, 0, 100, 30) vc:self action:nil];
    
    [self initTableView];
    
    [self addNotification];
    
    [self initServiceInfo];

}

#pragma mark - Init

- (void)initTableView {
    
    TLTableView *mineTableView = [TLTableView groupTableViewWithFrame:CGRectZero
                                                             delegate:self
                                                           dataSource:self];
    [self.view addSubview:mineTableView];

    mineTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight);
    mineTableView.rowHeight = 45;
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f4f7"];

    self.mineTableView = mineTableView;
    
    //tableview的header
    //headerView
    BaseMineHeaderView *mineHeaderView = [[BaseMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    mineTableView.tableHeaderView = mineHeaderView;
    mineHeaderView.delegate = self;
    
    self.headerView = mineHeaderView;
    
}

- (void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

- (void)initServiceInfo {
    
    if (kScreenWidth) {
        
        CGFloat serviceH = 60;
        
        UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kTabBarHeight - serviceH, kScreenWidth, serviceH)];
        
        [self.view addSubview:serviceView];
        
        self.mobileLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth, 16) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15) textColor:[UIColor textColor]];
        
        [serviceView addSubview:self.mobileLbl];
        
        self.serviceTimeLbl = [UILabel labelWithFrame:CGRectMake(0, self.mobileLbl.yy + 10, kScreenWidth, 12) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(12) textColor:[UIColor textColor2]];
        
        [serviceView addSubview:self.serviceTimeLbl];
        
    } else {
    
        CGFloat serviceH = 60;
        
        CGFloat y = 50;
        
        UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, y + serviceH)];
        
        self.mobileLbl = [UILabel labelWithFrame:CGRectMake(0, y, kScreenWidth, 16) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15) textColor:[UIColor textColor]];
        
        [serviceView addSubview:self.mobileLbl];
        
        self.serviceTimeLbl = [UILabel labelWithFrame:CGRectMake(0, self.mobileLbl.yy + 10, kScreenWidth, 12) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(12) textColor:[UIColor textColor2]];
        
        [serviceView addSubview:self.serviceTimeLbl];
        
        self.mineTableView.tableFooterView = serviceView;
    }
    
    
    
    
}

#pragma mark - Data

- (void)requestUserInfo {

    __weak typeof(self) weakself = self;

    //1.刷新用户信息
    [[TLUser user] updateUserInfo];
    
    //--//
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
                
                weakself.headerView.jfNumText = [obj.amount convertToRealMoney];
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                weakself.headerView.rmbNum = [obj.amount convertToRealMoney];
                
                [[NSUserDefaults standardUserDefaults] setObject:[obj.amount convertToRealMoney] forKey:@"BalanceMoney"];
                
                self.accountNumber = obj.accountNumber;
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestServiceTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"807717";
    
    http.parameters[@"ckey"] = @"time";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.serviceTimeLbl.text = [NSString stringWithFormat:@"%@: %@", responseObject[@"data"][@"cvalue"], responseObject[@"data"][@"note"]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestServiceMobile {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"807717";
    
    http.parameters[@"ckey"] = @"telephone";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSAttributedString *mobileAttr = [NSAttributedString getAttributedStringWithImgStr:@"服务电话" index:0 string:[NSString stringWithFormat:@" %@", responseObject[@"data"][@"note"]] labelHeight:self.mobileLbl.height];

        self.mobileLbl.attributedText = mobileAttr;
//        self.mobileLbl.text = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark- 通知处理
- (void)loginOut {
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:nil placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    [self.headerView reset];
    
    //
    self.headerView.nameLbl.text = @"--";
    
    //论坛-绞肉机
    self.headerView.genderImg.image = nil;
    
    self.headerView.vipImg.hidden = YES;
    
    [[TLUser user] loginOut];
    
}


- (void)changeInfo {
    
    NSString *userPhotoStr = [[TLUser user].userExt.photo convertImageUrl];
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.headerView.nameLbl.text = [TLUser user].nickname;
    
    NSString *img = [[TLUser user].userExt.gender isEqualToString:@"1"] ? @"男": @"女生";

    self.headerView.genderImg.image = [UIImage imageNamed:img];
    
    self.headerView.vipImg.hidden = [[TLUser user].level isEqualToString:@"1"] ? NO: YES;
}

#pragma mark- 修改头像
- (void)choosePhoto {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                [TLProgressHUD showWithStatus:@""];

                QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone2];
                    
                }]];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    //设置头像
                    
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = @"805077";
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"修改头像成功"];
                        [TLUser user].userExt.photo = key;
                        weakSelf.headerView.userPhoto.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}

#pragma mark - MineHeaderSeletedDelegate

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {

    switch (type) {
        case MineHeaderSeletedTypeDefault:
        {
            UserDetailEditVC *detailVC = [UserDetailEditVC new];
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
        
        case MineHeaderSeletedTypeSelectPhoto:
        {
            [self choosePhoto];

        }
            break;
            
        case MineHeaderSeletedTypeIntregalFlow:
        {
//            IntegralTaskListVC *taskVC = [IntegralTaskListVC new];
//            
//            [self.navigationController pushViewController:taskVC animated:YES];
        }
            break;
            
        case MineHeaderSeletedTypeRMBFlow:
        {
//            ConsumptionListVC *consumptionListVC = [ConsumptionListVC new];
//            
//            consumptionListVC.accountNumber = self.accountNumber;
//            
//            [self.navigationController pushViewController:consumptionListVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark- 头部条状 事件处理

- (SettingGroup *)group {
    
    if (!_group) {
        
        BaseWeakSelf;
        
        _group = [[SettingGroup alloc] init];
        
        NSArray *names = @[@[@"邀请好友", @"商城", @"设置"]];

        
        //邀请好友
        SettingModel *invitationItem = [SettingModel new];
        invitationItem.imgName = names[0][0];
        invitationItem.text  = names[0][0];
        [invitationItem setAction:^{
            
//            [TLAlert alertWithInfo:@"正在研发中，敬请期待！"];
            InviteFriendVC *inviteFriendVC = [InviteFriendVC new];
            
            [weakSelf.navigationController pushViewController:inviteFriendVC animated:YES];
            
        }];
        
        //健康商城
        SettingModel *mallItem = [SettingModel new];
        mallItem.imgName = names[0][1];
        mallItem.text  = names[0][1];
        [mallItem setAction:^{
            
            MallOrderVC  *vc = [MallOrderVC new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        
        //设置
        SettingModel *settingItem = [SettingModel new];
        settingItem.imgName = names[0][2];
        settingItem.text = names[0][2];
        [settingItem setAction:^{
            
            BaseSettingVC *settingVC = [BaseSettingVC new];
            
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
            
        }];
        
        
        _group.groups = @[@[invitationItem, mallItem, settingItem]];
        
    }
    return _group;
    
}



#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.groups[indexPath.section];
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark- datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.group.groups.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.group.items = self.group.groups[section];
    
    return  self.group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSettingCellID"];
    
    if (!cell) {
        
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSettingCellID"];
        
    }
    
    self.group.items = self.group.groups[indexPath.section];
    
    //
    cell.settingModel = self.group.items[indexPath.row];
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.00001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
