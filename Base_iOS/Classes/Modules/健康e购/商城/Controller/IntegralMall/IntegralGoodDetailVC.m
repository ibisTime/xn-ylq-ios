//
//  IntegralGoodDetailVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralGoodDetailVC.h"
#import "TLBannerView.h"
#import "ZHStepView.h"
#import "ZHTreasureInfoView.h"
#import "ShareView.h"
#import "CDGoodsParameterChooseView.h"
#import "BaseDetailWebView.h"

#import "ConfirmOrderVC.h"
#import "ZHEvaluateListVC.h" //评价列表
#import "ZHSingleDetailVC.h" //详情列表
#import "ZHShoppingCartVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "MJRefresh.h"
#import "AppConfig.h"
#import "CDGoodsParameterModel.h"

@interface IntegralGoodDetailVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,weak) TLBannerView *bannerView;
@property (nonatomic, strong) UIScrollView *goodsDetailTypeScrollView;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *advLbl;
@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *stockLbl;  //库存

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

//
@property (nonatomic,strong) UIView *switchView;
@property (nonatomic, strong) UIView *switchSubView;
@property (nonatomic, assign) BOOL switchByTap;


//顶部切换相关
@property (nonatomic, strong) UIView *switchLine;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *evaluateViwe;

@property (nonatomic, copy) NSArray <CDGoodsParameterModel *> *parameterModelArr;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation IntegralGoodDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bannerView.timer invalidate];
    self.bannerView.timer = nil;
}

- (void)tl_placeholderOperation {
    
    //先查询规格
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808037";
    http.parameters[@"productCode"] = self.goods.code;
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        
        self.parameterModelArr = [CDGoodsParameterModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self setUpUI];
        [self addEvent];
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        
    }];
    //
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self tl_placeholderOperation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.switchView;

    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];

}

- (void)addEvent {
    
    //
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    //拍普通商品，价格在上面
    NSArray *imgUrls = [self.goods.pic componentsSeparatedByString:@"||"];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSString *url in imgUrls) {
        
        [images addObject:[url convertImageUrl]];
        
    }
    
    self.bannerView.imgUrls = images.copy;
    
    CDGoodsParameterModel *model = self.parameterModelArr[0];
    
    //---//
    self.nameLbl.text = self.goods.name;
    self.advLbl.text = self.goods.slogan;
    self.priceLbl.text = [NSString stringWithFormat:@"%@ 积分", [[model.price1 stringValue] convertToRealMoney]];
    
    self.stockLbl.text = [NSString stringWithFormat:@"库存: %ld", [model.quantity integerValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treasureSuccess) name:@"dbBuySuccess" object:nil];
    
}

#pragma mark- 顶部切换事件
- (void)switchConten:(UIButton *)btn {
    
    
    if ([_lastBtn isEqual:btn]) {
        return;
    }
    
    self.switchByTap = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.switchByTap = NO;
        
    });
    
    NSInteger tag = btn.tag - 100;
    
    switch (tag) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
        
//        case 2 :
//            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
//            
//            break;
            
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;
    
    
    //
    [self.goodsDetailTypeScrollView setContentOffset:CGPointMake(self.goodsDetailTypeScrollView.width*tag, 0) animated:YES];
    
}

#pragma mark- 商品详情切换的scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    return;
    
    if (self.switchByTap) {
        
        return;
    }
    
    NSInteger tag =  scrollView.contentOffset.x/kScreenWidth + 100;
    
    if (tag < 0) {
        return;
    }
    
    
    UIButton *btn = (UIButton *)[self.switchSubView viewWithTag:tag];
    if (!btn) {
        return;
    }
    
    switch (tag - 100) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
            
//        case 2 :
//            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
//            
//            break;
            
    }
    
    if (!btn || [self.lastBtn isEqual:btn]) {
        return;
    }
    
    //
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;
    
    
}


-(void)share {
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
    }];
    
    shareView.shareTitle = @"健康e购";
    //    shareView.shareDesc = self.shop.name;
    //    shareView.shareURL = [NSString stringWithFormat:@"%@/share/store.html?code=%@",[AppConfig config].shareBaseUrl,self.shop.code];
    
    NSString *shareImgStr = nil;
    
    shareView.shareImgStr = shareImgStr;
    
    [self.view addSubview:shareView];
    
}


- (void)treasureSuccess{
    
    [self.bgScrollView.mj_header beginRefreshing];
}

#pragma mark- 一元夺宝刷新
- (void)refresh {
    
    [self.bgScrollView.mj_header endRefreshing];
}

#pragma mark - Events

#pragma mark- 购买
- (void)buy {
    
    //
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            
            [weakSelf buy];
        };
        return;
    }
    
    CDGoodsParameterModel *goodModel = self.parameterModelArr[0];
    
    if ([goodModel.quantity integerValue] == 0) {
        
        [TLAlert alertWithInfo:@"该商品库存不足"];
        return;
    }
    
    ConfirmOrderVC *buyVC = [[ConfirmOrderVC alloc] init];
    buyVC.type = ZHIMBuyTypeSingle;
    buyVC.postage = @0;
    //
    self.goods.currentCount = 1;
    
    CDGoodsParameterModel *model = self.goods.productSpecsList[0];
    
    self.goods.currentParameterPriceRMB = model.price1;

    self.goods.selectedParameter = model;
    
    buyVC.goodsRoom = @[self.goods];
    [self.navigationController pushViewController:buyVC animated:YES];
    
}

- (UIView *)detailView {
    
    if (!_detailView) {
        
//        BaseWeakSelf;
        BaseDetailWebView *wkWebView = [[BaseDetailWebView alloc] initWithFrame:CGRectOffset(self.bgScrollView.frame, kScreenWidth, 0)];
        
        [wkWebView loadWebWithString:_goods.desc];
        
        _detailView = wkWebView;
    }
    return _detailView;
    
}

-(UIView *)evaluateViwe {
    
    if (!_evaluateViwe ) {
        
        ZHEvaluateListVC *evaluateListVC = [[ZHEvaluateListVC alloc] init];
        
        evaluateListVC.goodsCode = self.goods.code;
        evaluateListVC.peopleNum = self.goods.boughtCount;
        evaluateListVC.view.frame = CGRectOffset(self.bgScrollView.frame, kScreenWidth*2, 0);
        [self addChildViewController:evaluateListVC];
        [self.view addSubview:evaluateListVC.view];
        
        _evaluateViwe = evaluateListVC.view;
        
    }
    
    return _evaluateViwe;
    
}

- (void)setUpUI {
    
//    [UIBarButtonItem addRightItemWithImageName:@"购物车" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(openShopCar)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //底部负责左右切换的背景
    self.goodsDetailTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    [self.view addSubview:self.goodsDetailTypeScrollView];
    self.goodsDetailTypeScrollView.pagingEnabled = YES;
    self.goodsDetailTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.goodsDetailTypeScrollView.backgroundColor = [UIColor zh_backgroundColor];
    self.goodsDetailTypeScrollView.delegate = self;
    self.goodsDetailTypeScrollView.contentSize = CGSizeMake(self.goodsDetailTypeScrollView.width*2, self.goodsDetailTypeScrollView.height);
    
    //商品信息背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.goodsDetailTypeScrollView addSubview: self.bgScrollView];
    
    CGFloat w = kScreenWidth;
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, w, 49) title:@"立即兑换" backgroundColor:kAppCustomMainColor];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = FONT(18);
    [self.view addSubview:buyBtn];
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.8)];
    [self.bgScrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    
    //
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(1));
    }];
    
    //名字
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(16)
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.numberOfLines = 0;
    [self.bgScrollView addSubview:self.nameLbl];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.top.equalTo(self.bannerView.mas_bottom).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));
        
    }];
    
    
    //广告语
    //    CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, 10)
    self.advLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
    [self.bgScrollView addSubview:self.advLbl];
    self.advLbl.numberOfLines = 0;
    [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));
    }];
    
    //价格
    //    CGRectMake(self.nameLbl.x, self.advLbl.yy + 11, self.nameLbl.width, 10)
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(16)
                                  textColor:[UIColor zh_themeColor]];
    [self.bgScrollView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.equalTo(@(200));
    }];
    
    //库存
    
    self.stockLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor2] textFont:13.0];
    
    self.stockLbl.textAlignment = NSTextAlignmentRight;
    [self.bgScrollView addSubview:self.stockLbl];
    [self.stockLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.advLbl.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18.0);
        make.left.mas_equalTo(kScreenWidth - 15 - 150);
        
    }];
    
    //
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priceLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(1));
        
    }];
    
}

#pragma mark- 顶部切换UI
- (UIView *)switchView {
    
    if (!_switchView) {
        
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 160, 34)];
        _switchView.backgroundColor = kClearColor;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _switchView.width, 40)];
        self.switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 2, 40, 2)];
        self.switchLine.backgroundColor = [UIColor zh_themeColor];
        [bgView addSubview:self.switchLine];
        self.switchSubView = bgView;
        
        NSArray *types = @[@"商品",@"详情"];
        for (NSInteger i = 0; i < types.count; i ++) {
            
            CGFloat x = _switchView.width/types.count;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*x, 2, x, 28) title:types[i] backgroundColor:kClearColor];
            btn.titleLabel.font = FONT(17);
            [bgView addSubview:btn];
            
            [btn addTarget:self action:@selector(switchConten:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            
            btn.tag = i + 100;
            
            if (i == 0) {
                btn.titleLabel.font = FONT(18);
                self.switchLine.centerX = btn.centerX;
                [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
                self.lastBtn = btn;
            }
            
        }
        
        [_switchView addSubview:bgView];
    }
    return _switchView;
    
}

@end
