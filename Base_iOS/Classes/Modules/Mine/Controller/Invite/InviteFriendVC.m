//
//  InviteFriendVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "InviteFriendVC.h"
#import "ShareView.h"

#import "HistoryInviteVC.h"

@interface InviteFriendVC ()

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation InviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"获客";
    
    [UIBarButtonItem addRightItemWithTitle:@"推荐历史" frame:CGRectMake(0, 0, 70, 30) vc:self action:@selector(historyFriends)];
    
    [self initSubviews];
    
    [self requestActivityRule];
    
    [self getUrl];
}

#pragma mark - Init
- (void)initSubviews {

    UIImageView *inviteIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(275))];
    
    inviteIV.image = kImage(@"邀好友");
    
    [self.view addSubview:inviteIV];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, inviteIV.yy + 10, kScreenWidth, kScreenHeight - 64 - 65 - 20 - kWidth(275))];
    
    self.centerView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.centerView];
    
    UILabel *textLbl = [UILabel labelWithText:@"活动规则" textColor:kTextColor textFont:kWidth(15)];
    
    textLbl.frame = CGRectMake(15, 10, 100, kWidth(15));
    
    [self.centerView addSubview:textLbl];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 65, kScreenWidth, 65)];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bottomView];
    
    UIButton *recommendBtn = [UIButton buttonWithTitle:@"我要推荐" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:kWidth(18) cornerRadius:22.5];
    
    [recommendBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    
    recommendBtn.frame = CGRectMake(15, 10, kScreenWidth - 30, 45);
    
    [bottomView addSubview:recommendBtn];
}

- (void)setRemark:(NSString *)remark {
    
    _remark = remark;
    
    //注意事项
    //
    CGFloat height = ([_remark componentsSeparatedByString:@"\n"].count+1)*25;
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:[UIColor zh_themeColor] textFont:13.0];
    
    promptLbl.backgroundColor = kTextColor3;
    
    [promptLbl labelWithTextString:_remark lineSpace:10];
    
    promptLbl.backgroundColor = kClearColor;
    
    promptLbl.numberOfLines = 0;
    
    promptLbl.frame = CGRectMake(15, 40, kScreenWidth - 2*15, height);
    
    [self.centerView addSubview:promptLbl];
    //
}

#pragma mark - Events
- (void)historyFriends {

    HistoryInviteVC *inviteVC = [HistoryInviteVC new];
    
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)inviteFriend {

    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(NSString *title) {
        
        if ([title isEqualToString:@"0"]) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
            
        }
        
    } vc:self];
    
    shareView.shareTitle = @"邀请好友";
    shareView.shareDesc = @"邀好友送优惠券 多邀多得";
    shareView.shareURL = self.shareUrl;
    
    [self.view addSubview:shareView];
}

#pragma mark - Data
- (void)requestActivityRule {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805917";
    
    http.parameters[@"ckey"] = @"activityRule";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.remark = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805917";
    http.parameters[@"ckey"] = @"domainUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *url = responseObject[@"data"][@"cvalue"];
        
        NSString *shareStr = [NSString stringWithFormat:@"%@?kind=C&mobile=%@", url, [TLUser user].mobile];
        //
        self.shareUrl = shareStr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
