//
//  BaseInviteFriendVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/31.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseInviteFriendVC.h"
#import "SGQRCodeTool.h"
#import "ShareView.h"

@interface BaseInviteFriendVC ()

@property (nonatomic, strong) UIImageView *headIconIV;  //头像

@property (nonatomic, strong) UILabel *nickNameLbl;     //昵称

@property (nonatomic, strong) UILabel *friendsLbl;      //邀请人数

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *qrCodeImageView;       //二维码

@property (nonatomic, strong) UIView *qrCodeView;

@property (nonatomic, strong) UIView *inviteCodeView;   //邀请码

@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation BaseInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"邀请好友"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self initSubviews];
    
}

#pragma mark - Init

- (void)initSubviews {
    
    [self initSemgement];

    [self initBgView];
    
    [self initInviteCodeView];
    
    [self initQRCodeView];
    
    //分享
    [self initShareBtn];

}

- (void)initSemgement {

    UISegmentedControl *inviteSC = [[UISegmentedControl alloc] initWithItems:@[@"二维码", @"邀请码"]];
    
    inviteSC.backgroundColor = kWhiteColor;
    
    inviteSC.tintColor = kAppCustomMainColor;
    
    inviteSC.selectedSegmentIndex = 0;
    
    inviteSC.frame = CGRectMake(0, kWidth(20), kWidth(160), kWidth(30));
    
    inviteSC.centerX = self.view.centerX;
    
    [inviteSC addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:inviteSC];
    
}

- (void)initBgView {

    CGFloat leftMargin = kWidth(30);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, kWidth(70), kScreenWidth - 2*leftMargin, kScreenWidth + kWidth(50))];
    
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    
    self.bgView = bgView;
    
    CGFloat headIconW = kWidth(45);
    
    self.headIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(25), kWidth(25), headIconW, headIconW)];
    
    self.headIconIV.contentMode = UIViewContentModeScaleAspectFill;
    
    self.headIconIV.layer.cornerRadius = headIconW/2,0;
    self.headIconIV.clipsToBounds = YES;
    
    [self.headIconIV sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].userExt.photo convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
    
    [bgView addSubview:self.headIconIV];
    
    self.nickNameLbl = [UILabel labelWithText:[TLUser user].nickname textColor:[UIColor textColor] textFont:15.0];
    
    CGFloat nickW = bgView.width - self.headIconIV.xx - kWidth(24);
    
    self.nickNameLbl.frame = CGRectMake(self.headIconIV.xx + kWidth(12), kWidth(29), nickW, 16);
    
    [bgView addSubview:self.nickNameLbl];
    
    self.friendsLbl = [UILabel labelWithText:[NSString stringWithFormat:@"我的小伙伴: %@", [TLUser user].referrerNum] textColor:[UIColor textColor2] textFont:15.0];
    
    self.friendsLbl.frame = CGRectMake(self.nickNameLbl.x, self.nickNameLbl.yy + kWidth(12), 200, 16);
    
    [bgView addSubview:self.friendsLbl];
}

- (void)initInviteCodeView {
    
    CGFloat leftMargin = kWidth(25);

    CGFloat inviteViewW = kScreenWidth - kWidth(110);
    
    
    self.inviteCodeView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, self.headIconIV.yy + kWidth(55), inviteViewW, inviteViewW)];
    
    [self.bgView addSubview:self.inviteCodeView];
    
    UIView *inviteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inviteViewW, inviteViewW - kWidth(40))];

    inviteBgView.layer.cornerRadius = 10;
    
    inviteBgView.clipsToBounds = YES;
    
    inviteBgView.backgroundColor = [UIColor colorWithHexString:@"#10D36D"];
    
    [self.inviteCodeView addSubview:inviteBgView];
    
    UIImageView *inviteIconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邀请码"]];
    
    inviteIconIV.frame = CGRectMake(0, kWidth(35), kWidth(22), kWidth(25));
    
    inviteIconIV.centerX = self.inviteCodeView.width/2.0;

    [inviteBgView addSubview:inviteIconIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"我的邀请码" textColor:kWhiteColor textFont:14.0];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.backgroundColor = kClearColor;
    
    textLbl.frame = CGRectMake(0, inviteIconIV.yy + kWidth(10), 200, 15.0);
    
    textLbl.centerX = self.inviteCodeView.width/2.0;
    
    [inviteBgView addSubview:textLbl];
    
    //邀请码
    UILabel *inviteLbl = [UILabel labelWithText:[TLUser user].inviteCode textColor:[UIColor textColor] textFont:50.0];
    
    inviteLbl.layer.cornerRadius = 5;
    
    inviteLbl.clipsToBounds = YES;
    
    inviteLbl.textAlignment = NSTextAlignmentCenter;
    
    inviteLbl.backgroundColor = kWhiteColor;
    
    inviteLbl.frame = CGRectMake(kWidth(15), textLbl.yy + kWidth(35), self.inviteCodeView.width - 2*kWidth(15), kWidth(60));
    
    [inviteBgView addSubview:inviteLbl];
    
    UILabel *promptLbl = [UILabel labelWithText:@"邀请好友" textColor:[UIColor textColor2] textFont:14.0];
    
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    promptLbl.frame = CGRectMake(0, inviteBgView.yy + kWidth(30), 200, 15.0);
    
    promptLbl.centerX = self.inviteCodeView.width/2.0;
    
    [self.inviteCodeView addSubview:promptLbl];
    
    self.inviteCodeView.hidden = YES;

}

- (void)initQRCodeView {
    
    CGFloat leftMargin = kWidth(25);
    
    CGFloat qrViewW = kScreenWidth - kWidth(110);
    
    self.qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, self.headIconIV.yy + kWidth(25), qrViewW, qrViewW + kWidth(50))];
    
    [self.bgView addSubview:self.qrCodeView];

    self.qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, qrViewW, qrViewW)];
    
    [self.qrCodeView addSubview:self.qrCodeImageView];
    
    UILabel *textLbl = [UILabel labelWithText:@"扫描上面的二维码, 邀请好友" textColor:[UIColor textColor2] textFont:14.0];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.frame = CGRectMake(0, self.qrCodeImageView.yy + kWidth(20), 200, 15.0);
    
    textLbl.centerX = self.qrCodeView.width/2.0;
    
    [self.qrCodeView addSubview:textLbl];
    
    [self getUrl];

}

- (void)initShareBtn {

    CGFloat leftMargin = kWidth(30);
    
    UIButton *shareBtn = [UIButton buttonWithTitle:@"立即分享" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:kWidth(45)/2.0];
    
    shareBtn.frame = CGRectMake(leftMargin, self.bgView.yy + leftMargin, kScreenWidth - 2*leftMargin, kWidth(45));
    
    [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shareBtn];
}

- (void)getUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"807717";
    http.parameters[@"ckey"] = @"domainUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *url = responseObject[@"data"][@"cvalue"];
        
        NSString *shareStr = [NSString stringWithFormat:@"%@?kind=f1&mobile=%@", url, [TLUser user].mobile];
        //
        self.shareUrl = shareStr;
        
        UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData: shareStr
                                                         imageViewWidth:kScreenWidth];
        self.qrCodeImageView.image = image;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events

- (void)clickSelect:(UISegmentedControl *)sender {

    _currentIndex = sender.selectedSegmentIndex;
    
    if (_currentIndex == 0) {
        
        self.qrCodeView.hidden = NO;
        
        self.inviteCodeView.hidden = YES;
        
    } else {
    
        self.qrCodeView.hidden = YES;
        
        self.inviteCodeView.hidden = NO;
    }
    
}

- (void)clickShare:(UIButton *)sender {

    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
    }];
    
    shareView.shareTitle = @"加入健康e购大平台";
    shareView.shareDesc = @"邀请好友送积分。";
    shareView.shareURL = self.shareUrl;
    
    [self.view addSubview:shareView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
