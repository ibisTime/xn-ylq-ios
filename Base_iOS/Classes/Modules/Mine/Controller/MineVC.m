//
//  MineVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
#import "SettingCell.h"

#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"
#import "SettingGroup.h"
#import "QuotaModel.h"
#import "CouponModel.h"

#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "CouponVC.h"
#import "MyQuotaVC.h"
#import "LoanOrderVC.h"
#import "InviteFriendVC.h"
#import "SettingVC.h"
#import "HTMLStrVC.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate,MineHeaderSeletedDelegate>

@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic, strong) SettingGroup *group;
@property (nonatomic, strong) TLTableView *mineTableView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, copy) NSString *accountNumber;

@end

@implementation MineVC

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
    
    [self requestUserInfo];
    
    [self requestCouponList];
    //--//
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的";

    self.tabBarController.customizableViewControllers = nil;

    [UIBarButtonItem addLeftItemWithImageName:@"" frame:CGRectMake(0, 0, 100, 30) vc:self action:nil];
    
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
}

#pragma mark - Init

- (void)initTableView {

    BaseWeakSelf;
    
    TLTableView *mineTableView = [TLTableView groupTableViewWithFrame:CGRectZero
                                                             delegate:self
                                                           dataSource:self];
    [self.view addSubview:mineTableView];

    mineTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    mineTableView.rowHeight = 45;
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f4f7"];

    self.mineTableView = mineTableView;
    
    
    //tableview的header
    MineHeaderView *mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    mineTableView.tableHeaderView = mineHeaderView;
    mineHeaderView.delegate = self;
    
    self.headerView = mineHeaderView;
    
}

#pragma mark - Data

- (void)requestUserInfo {

    //1.刷新用户信息
    [[TLUser user] updateUserInfo];
    
    //--//
    //刷新额度
    TLNetworking *http = [TLNetworking new];
    http.code = @"623051";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        QuotaModel *model = [QuotaModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.headerView.quotaNum = [model.sxAmount convertToSimpleRealMoney];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestCouponList {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"623147";
    
    helper.parameters[@"userId"] = [TLUser user].userId;

    helper.parameters[@"status"] = @"0";
    
    [helper modelClass:[CouponModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.headerView.couponNum = [NSString stringWithFormat:@"%ld", objs.count];
        
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
    
    NSString *userPhotoStr = [[TLUser user].photo convertImageUrl];
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    self.headerView.nameLbl.text = [TLUser user].mobile;
    
//    NSString *img = [[TLUser user].userExt.gender isEqualToString:@"1"] ? @"男": @"女生";

//    self.headerView.genderImg.image = [UIImage imageNamed:img];
    
//    self.headerView.vipImg.hidden = [[TLUser user].level isEqualToString:@"1"] ? NO: YES;
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
                    http.code = USER_CHANGE_USER_PHOTO;
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"修改头像成功"];
                        [TLUser user].photo = key;
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
        
        case MineHeaderSeletedTypeSelectPhoto:
        {
            [self choosePhoto];

        }break;
            
        case MineHeaderSeletedTypeCoupon:
        {
            CouponVC *couponVC = [CouponVC new];
            
            [self.navigationController pushViewController:couponVC animated:YES];
            
        }break;
            
        case MineHeaderSeletedTypeQuota:
        {
        
            MyQuotaVC *myQuotaVC = [MyQuotaVC new];
            
            [self.navigationController pushViewController:myQuotaVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

#pragma mark- 头部条状 事件处理

- (SettingGroup *)group {
    
    if (!_group) {
        
        BaseWeakSelf;
        
        _group = [[SettingGroup alloc] init];
        
        NSArray *names = @[@[@"借款记录", @"邀请好友", @"帮助中心"], @[@"个人设置"]];

        //借款记录
        SettingModel *loanRecordItem = [SettingModel new];
        loanRecordItem.imgName = names[0][0];
        loanRecordItem.text  = names[0][0];
        [loanRecordItem setAction:^{
            
            LoanOrderVC *loanOrderVC = [LoanOrderVC new];
            
            
            [weakSelf.navigationController pushViewController:loanOrderVC animated:YES];
        }];
        
        //邀请好友
        SettingModel *inviteFriendItem = [SettingModel new];
        inviteFriendItem.imgName = names[0][1];
        inviteFriendItem.text  = names[0][1];
        [inviteFriendItem setAction:^{
            
            InviteFriendVC *inviteVC = [InviteFriendVC new];
            
            [weakSelf.navigationController pushViewController:inviteVC animated:YES];
        }];
        
        //帮助中心
        SettingModel *helpItem = [SettingModel new];
        helpItem.imgName = names[0][2];
        helpItem.text  = names[0][2];
        [helpItem setAction:^{
            
            HTMLStrVC *htmlVC = [HTMLStrVC new];
            
            htmlVC.type = HTMLTypeHelpCenter;
            
            [weakSelf.navigationController pushViewController:htmlVC animated:YES];
            
        }];
        
        //个人设置
        SettingModel *settingItem = [SettingModel new];
        settingItem.imgName = names[1][0];
        settingItem.text = names[1][0];
        [settingItem setAction:^{
            
            SettingVC *settingVC = [SettingVC new];
            
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
            
        }];
        
        _group.groups = @[@[loanRecordItem, inviteFriendItem, helpItem], @[settingItem]];
        
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
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellID"];
    
    if (!cell) {
        
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCellID"];
        
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
