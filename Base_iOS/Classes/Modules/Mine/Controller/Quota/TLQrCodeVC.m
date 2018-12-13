//
//  TLQrCodeVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLQrCodeVC.h"
#import "SGQRCodeGenerateManager.h"
#import "AppConfig.h"
//#import "UIButton+SGImagePosition.h"
#import <QuartzCore/QuartzCore.h>
#import "TLWXManager.h"
#import "BouncedPasteView.h"
#import "ZJAnimationPopView.h"
@interface TLQrCodeVC ()
{
    NSString *address ;
}


@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,strong) UIView *bgView1;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic , strong)ZJAnimationPopView *popView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, copy) NSString *h5String;

@property (nonatomic, strong) UIImageView *qrIV;
@property (nonatomic, strong) UIImageView *qrIV1;

@property (nonatomic , strong)BouncedPasteView *bouncedView;

@end

@implementation TLQrCodeVC


-(BouncedPasteView *)bouncedView
{
    if (!_bouncedView) {
        _bouncedView = [[BouncedPasteView alloc]initWithFrame:CGRectMake(kWidth(25), kScreenHeight + kNavigationBarHeight , kScreenWidth - kWidth(50), _bouncedView.pasteButton.yy + kHeight(30))];
        kViewRadius(_bouncedView, 4);
        [_bouncedView.pasteButton addTarget:self action:@selector(pasteButtonClick) forControlEvents:(UIControlEventTouchUpInside)];



    }
    return _bouncedView;
}
-(void)pasteButtonClick
{
    [TLAlert alertWithSucces:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  
    
    pasteboard.string = self.bouncedView.informationLabel.text;
}


#pragma mark 显示弹框
//- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
//{
//    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
//    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
//    // 1.初始化
//    _popView = [[ZJAnimationPopView alloc] initWithCustomView:_bouncedView popStyle:popStyle dismissStyle:dismissStyle];
//
//    // 2.设置属性，可不设置使用默认值，见注解
//    // 2.1 显示时点击背景是否移除弹框
//    _popView.isClickBGDismiss = ![_bouncedView isKindOfClass:[BouncedPasteView class]];
////    移除
//    _popView.isClickBGDismiss = YES;
//    // 2.2 显示时背景的透明度
//    _popView.popBGAlpha = 0.5f;
//    // 2.3 显示时是否监听屏幕旋转
//    _popView.isObserverOrientationChange = YES;
//    // 2.4 显示时动画时长
//    //    popView.popAnimationDuration = 0.8f;
//    // 2.5 移除时动画时长
//    //    popView.dismissAnimationDuration = 0.8f;
//
//    // 2.6 显示完成回调
//    _popView.popComplete = ^{
//        NSLog(@"显示完成");
//    };
//    // 2.7 移除完成回调
//    _popView.dismissComplete = ^{
//        NSLog(@"移除完成");
//    };
//    // 4.显示弹框
//    [_popView pop];
//}


////打开微信,去粘贴
//-(void)pasteButtonClick
//{
//    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功!" key:nil]];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    NSString *lang;
//    LangType type = [LangSwitcher currentLangType];
//    if (type == LangTypeSimple || type == LangTypeTraditional) {
//        lang = @"ZH_CN";
//    }else if (type == LangTypeKorean)
//    {
//        lang = @"KO";
//    }else{
//        lang = @"EN";
//
//    }
//
//    pasteboard.string = self.bouncedView.informationLabel.text;
//}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    [self getShareUrl];
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#1F7E80"];
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight);

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = @"推荐";
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.nameLable;

    self.view.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:self.bouncedView];

//    [self initUI1];
//    [self initUI];
    // Do any additional setup after loading the view.
}


- (void)getShareUrl
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"key"] = @"domainUrl";
    http.isSyComCode = YES;
    [http postWithSuccess:^(id responseObject) {
        [self initUI];
        [self initUI1];

        self.h5String = responseObject[@"data"][@"cvalue"];
        
        self.h5String = [NSString stringWithFormat:@"%@/user/register.html?companyCode=%@&userRefereeKind=C&userReferee=%@",self.h5String,[AppConfig config].companyCode,[TLUser user].userId];
        
        self.qrIV.image =  [SGQRCodeGenerateManager generateWithDefaultQRCodeData:self.h5String imageViewWidth:170];
        self.qrIV1.image =  [SGQRCodeGenerateManager generateWithDefaultQRCodeData:self.h5String imageViewWidth:170];

        self.bouncedView.informationLabel.attributedText = [self ReturnsTheDistanceBetween:[NSString stringWithFormat:@"欢迎使用%@ \n%@",self.h5String,AppName]];
      
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)initUI
{
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-103)/2, kHeight(kNavigationBarHeight + 16), 103, 103)];
    iconImage.contentMode = UIViewContentModeScaleToFill;
    iconImage.image = kImage(@"logo1");
    //    iconImage.backgroundColor = [UIColor redColor];
    [_bgView addSubview:iconImage];

    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),kScreenWidth - kWidth(105), kHeight(52+36))];
    titleBackImage.image = kImage(@"文字背景");
    [_bgView addSubview:titleBackImage];

    UILabel *name = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), kScreenWidth - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];
    
    name.text = AppName;
    [titleBackImage addSubview:name];

    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), name.yy+20, kScreenWidth - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];

    introduceLabel.text = [NSString stringWithFormat:@"邀请您参加橙小贷"];
    [titleBackImage addSubview:introduceLabel];


    UILabel *InviteLinkLabel = [UILabel labelWithFrame:CGRectMake(kWidth(20), kHeight(499+20), 0, kHeight(16)) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    InviteLinkLabel.text = @"复制您的专属邀请链接";
    [self.bgView addSubview:InviteLinkLabel];
    [InviteLinkLabel sizeToFit];
    if (InviteLinkLabel.width >= kScreenWidth - kWidth(72) - kWidth(40)) {
        InviteLinkLabel.frame = CGRectMake(kWidth(20), kHeight(499+20), kScreenWidth - kWidth(72) - kWidth(40), kHeight(16));
    }else
    {
        InviteLinkLabel.frame = CGRectMake(kScreenWidth/2 - InviteLinkLabel.width/2 - kWidth(36), kHeight(499+20), InviteLinkLabel.width, kHeight(16));
    }
   
    UIButton *copyButton = [UIButton buttonWithTitle:@"复制" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:12];
    copyButton.frame = CGRectMake(InviteLinkLabel.xx + kWidth(12) , kHeight(494+20), kWidth(60), kHeight(26));
    kViewBorderRadius(copyButton, 2, 1, kWhiteColor);
    [copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:copyButton];

    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, copyButton.yy+10, kScreenWidth, 1)];
    iconView.backgroundColor = [UIColor colorWithHexString:@"#1FE8FD"];
    [_bgView addSubview:iconView];
//
//    UIImageView *btnBack = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(-1), kScreenWidth - kHeight(91), kScreenWidth + kWidth(2), kHeight(92))];
//    btnBack.image = kImage(@"1-1");
//    kViewBorderRadius(btnBack, 0.01, 1, kWhiteColor);
//    [self.bgView addSubview:btnBack];
//
//    NSArray *nameArray = @[@"保存本地",@"微信",@"朋友圈",@"微博"];
//    NSArray *imgArray = @[@"保存本地 亮色",@"微信 亮色",@"朋友圈 亮色",@"微博 亮色"];
//
//    for (int i = 0; i < 4; i ++) {
        UIButton *shareBtn = [UIButton buttonWithTitle:@"保存至本地" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
        shareBtn.frame = CGRectMake(0, copyButton.yy+20,kScreenWidth , kHeight(41));
        [shareBtn setImage:[UIImage imageNamed:@"auh"] forState:(UIControlStateNormal)];
    

        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        shareBtn.tag = 100 + i;
        [self.view addSubview:shareBtn];
//    }
    


    UIView *codeView = [UIView new];
    [self.bgView addSubview:codeView];
    codeView.backgroundColor = kBackgroundColor;
    codeView.frame = CGRectMake(kScreenWidth/2 - kWidth(90), kHeight(250) + kNavigationBarHeight, kWidth(180), kWidth(180));
    codeView.layer.cornerRadius=5;
    codeView.layer.shadowOpacity = 0.22;// 阴影透明度
    codeView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    codeView.layer.shadowRadius=3;// 阴影扩散的范围控制
    codeView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围

    [self.bgView addSubview:codeView];


    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];
    self.qrIV = qrIV;
    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:self.h5String imageViewWidth:170];
    
    [codeView addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(codeView.mas_top).offset(15);
        make.right.equalTo(codeView.mas_right).offset(-15);
        make.left.equalTo(codeView.mas_left).offset(15);
        make.bottom.equalTo(codeView.mas_bottom).offset(-15);
    }];

    self.bouncedView.informationLabel.attributedText = [self ReturnsTheDistanceBetween:[NSString stringWithFormat:@"%@",self.h5String]];

}


- (void)initUI1
{
    UIView *bgView = [[UIView alloc] init];
    self.bgView1 = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#1F7E80"];
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-103)/2, kHeight(kNavigationBarHeight + 16), 103, 103)];
    iconImage.contentMode = UIViewContentModeScaleToFill;
    iconImage.image = kImage(@"logo1");
    //    iconImage.backgroundColor = [UIColor redColor];
    [self.bgView1 addSubview:iconImage];
    
    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),kScreenWidth - kWidth(105), kHeight(52+36))];
    titleBackImage.image = kImage(@"文字背景");
    [self.bgView1 addSubview:titleBackImage];
    
    UILabel *name = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), kScreenWidth - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];
    
    name.text = @"双龙";
    [titleBackImage addSubview:name];
    
    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), name.yy+20, kScreenWidth - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];
    
    introduceLabel.text = [NSString stringWithFormat:@"邀请您参加橙小贷"];
    [titleBackImage addSubview:introduceLabel];
    
    
//    UILabel *InviteLinkLabel = [UILabel labelWithFrame:CGRectMake(kWidth(20), kHeight(499+20), 0, kHeight(16)) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
//    InviteLinkLabel.text = @"复制您的专属邀请链接";
//    [self.bgView1 addSubview:InviteLinkLabel];
//    [InviteLinkLabel sizeToFit];
//    if (InviteLinkLabel.width >= kScreenWidth - kWidth(72) - kWidth(40)) {
//        InviteLinkLabel.frame = CGRectMake(kWidth(20), kHeight(499+20), kScreenWidth - kWidth(72) - kWidth(40), kHeight(16));
//    }else
//    {
//        InviteLinkLabel.frame = CGRectMake(kScreenWidth/2 - InviteLinkLabel.width/2 - kWidth(36), kHeight(499+20), InviteLinkLabel.width, kHeight(16));
//    }
//
//    UIButton *copyButton = [UIButton buttonWithTitle:@"复制" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:12];
//    copyButton.frame = CGRectMake(InviteLinkLabel.xx + kWidth(12) , kHeight(494+20), kWidth(60), kHeight(26));
//    kViewBorderRadius(copyButton, 2, 1, kWhiteColor);
//    [copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.bgView1 addSubview:copyButton];
//
//    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, copyButton.yy+10, kScreenWidth, 1)];
//    iconView.backgroundColor = [UIColor colorWithHexString:@"#1FE8FD"];
//    [self.bgView1 addSubview:iconView];
    //
    //    UIImageView *btnBack = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(-1), kScreenWidth - kHeight(91), kScreenWidth + kWidth(2), kHeight(92))];
    //    btnBack.image = kImage(@"1-1");
    //    kViewBorderRadius(btnBack, 0.01, 1, kWhiteColor);
    //    [self.bgView addSubview:btnBack];
    //
    //    NSArray *nameArray = @[@"保存本地",@"微信",@"朋友圈",@"微博"];
    //    NSArray *imgArray = @[@"保存本地 亮色",@"微信 亮色",@"朋友圈 亮色",@"微博 亮色"];
    //
    //    for (int i = 0; i < 4; i ++) {
//    UIButton *shareBtn = [UIButton buttonWithTitle:@"保存至本地" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
//    shareBtn.frame = CGRectMake(0, copyButton.yy+20,kScreenWidth , kHeight(41));
//    [shareBtn setImage:[UIImage imageNamed:@"auh"] forState:(UIControlStateNormal)];
//
//
//    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    //        shareBtn.tag = 100 + i;
//    [self.view addSubview:shareBtn];
//    //    }
    
    
    
    UIView *codeView = [UIView new];
    [self.bgView1 addSubview:codeView];
    codeView.backgroundColor = kBackgroundColor;
    codeView.frame = CGRectMake(kScreenWidth/2 - kWidth(90), kHeight(250) + kNavigationBarHeight, kWidth(180), kWidth(180));
    codeView.layer.cornerRadius=5;
    codeView.layer.shadowOpacity = 0.22;// 阴影透明度
    codeView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    codeView.layer.shadowRadius=3;// 阴影扩散的范围控制
    codeView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    
    [self.bgView1 addSubview:codeView];
    
    
    //二维码
    UIImageView *qrIV1 = [[UIImageView alloc] init];
    self.qrIV1 = qrIV1;
    qrIV1.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:self.h5String imageViewWidth:170];
    
    [codeView addSubview:qrIV1];
    [qrIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(codeView.mas_top).offset(15);
        make.right.equalTo(codeView.mas_right).offset(-15);
        make.left.equalTo(codeView.mas_left).offset(15);
        make.bottom.equalTo(codeView.mas_bottom).offset(-15);
    }];
    
  

   

}


//设置行间距
-(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}

//@[@"保存本地",@"微信",@"朋友圈",@"微博"]
-(void)shareBtnClick:(UIButton *)sender
{
//    switch (sender.tag - 100) {
//        case 0:
//        {
            [TLAlert alertWithSucces:@"保存成功!"];

            UIGraphicsBeginImageContextWithOptions(self.bgView1.bounds.size, NO, [[UIScreen mainScreen] scale]);
            [self.bgView1.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

//        }
//            break;
//        case 1:
//        {
//            UIGraphicsBeginImageContextWithOptions(self.bgView1.bounds.size, NO, [[UIScreen mainScreen] scale]);
//            [self.bgView1.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            [TLWXManager wxShareImgWith:@"" scene:0 desc:nil image:viewImage];
//            [[TLWXManager manager] setWxShare:^(BOOL isSuccess, int errorCode) {
//                
//                if (isSuccess) {
//                    
//                    [TLAlert alertWithInfo:@"分享成功"];
//                    
//                } else {
//                    
//                    [TLAlert alertWithInfo:@"分享失败"];
//                    
//                }
//                
//            }];
//        }
//            break;
//        case 2:
//        {
//            UIGraphicsBeginImageContextWithOptions(self.bgView1.bounds.size, NO, [[UIScreen mainScreen] scale]);
//            [self.bgView1.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            [TLWXManager wxShareImgWith:@"" scene:1 desc:nil image:viewImage];
//            [[TLWXManager manager] setWxShare:^(BOOL isSuccess, int errorCode) {
//
//                if (isSuccess) {
//
//                    [TLAlert alertWithInfo:@"分享成功"];
//
//                } else {
//
//                    [TLAlert alertWithInfo:@"分享失败"];
//
//                }
//
//            }];
//        }
//            break;
//        case 3:
//        {
//            UIGraphicsBeginImageContextWithOptions(self.bgView1.bounds.size, NO, [[UIScreen mainScreen] scale]);
//            [self.bgView1.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
////            [TLWBManger sinaShareWithImage:viewImage];
//
//        }
//            break;

//        default:
//            break;
//    }
}

//复制
-(void)copyButtonClick
{
   
    _bouncedView.frame = CGRectMake(kWidth(25), kHeight(140), kScreenWidth - kWidth(50), _bouncedView.pasteButton.yy + kHeight(30));
    [self showPopAnimationWithAnimationStyle:8];
//    [TLAlert alertWithSucces:@"复制成功!"];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = self.h5String;

}
#pragma mark 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
{
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    // 1.初始化
    _popView = [[ZJAnimationPopView alloc] initWithCustomView:_bouncedView popStyle:popStyle dismissStyle:dismissStyle];
    
    // 2.设置属性，可不设置使用默认值，见注解
    // 2.1 显示时点击背景是否移除弹框
    _popView.isClickBGDismiss = ![_bouncedView isKindOfClass:[BouncedPasteView class]];
    //    移除
    _popView.isClickBGDismiss = YES;
    // 2.2 显示时背景的透明度
    _popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    _popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    _popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    _popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    // 4.显示弹框
    [_popView pop];
}


- (void)inviteButtonClick
{
    
    
}

- (void)sendinviteButtonClick
{
    
    
}
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
