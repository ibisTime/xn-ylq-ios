//
//  HealthMallVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "HealthMallVC.h"
#import "TLPageDataHelper.h"

#import "TLBannerView.h"
#import "GoodListCell.h"
#import "ShopTypeView.h"
#import "ShopDisplayView.h"
#import "GoodSelectView.h"

#import "SearchVC.h"
#import "NavigationController.h"
#import "GoodCategoryVC.h"
#import "ZHGoodsDetailVC.h"
#import "ZHShoppingCartVC.h"
#import "TLUserLoginVC.h"
#import "IntegralMallVC.h"
#import "SpecialMallVC.h"
#import "TLWebVC.h"

#import "BannerModel.h"
#import "GoodModel.h"
#import "ShopTypeModel.h"

#import "Masonry.h"
#import "UIButton+WebCache.h"

#define kIntegralHeight 75

@interface HealthMallVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic,strong) TLTableView *shopTableView;
@property (nonatomic, strong) UIPageControl *shopTypePageCtrl;

@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
//公告view
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic,strong) UILabel *cityLbl;
@property (nonatomic,strong) TLBannerView *bannerView;

@property (nonatomic, strong) UIScrollView *shopTypeScrollView;
//
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*intregalRoom;

@property (nonatomic,strong) NSMutableArray <ShopTypeView *>*shopTypeViewRooms;

@property (nonatomic,strong) NSMutableArray *bannerPics; //图片

@property (nonatomic,strong) NSMutableArray *intregalPics; //积分图片

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIButton *integralBtn;

@property (nonatomic, assign) CGFloat scrollHeight;
//
@property (nonatomic, strong) GoodSelectView *selectView;

@property (nonatomic, strong) NSArray *itemTitles;

@end

@implementation HealthMallVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
    // Do any additional setup after loading the view.
    
    [UIBarButtonItem addLeftItemWithImageName:@"" frame:CGRectMake(0, 0, 100, 30) vc:self action:nil];

//    //关闭侧滑手势（可行）
//    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
//    [self.view addGestureRecognizer:pan];
    
    //购物车
    [self setUpShoppingCart];
    
    //搜索 及 位置信息
    [self setUpSearchView];
    
    //顶部 banner 和 店铺类型选择
    [self setUpTableViewHeader];
    
    //积分商城
    [self setUpIntegralMall];
    
    //特价商品
    [self setUpSpecialMall];
    
    //精品商品
    [self setUpTableView];
    
    //获取商品列表
    [self requesGoodList];
    
    [self.shopTableView beginRefreshing];

    
}

#pragma mark - Init

- (NSMutableArray<ShopTypeView *> *)shopTypeViewRooms {
    
    if (!_shopTypeViewRooms) {
        
        _shopTypeViewRooms = [[NSMutableArray alloc] init];
    }
    
    return _shopTypeViewRooms;
    
}

- (void)setUpShoppingCart {
    
    [UIBarButtonItem addRightItemWithImageName:@"购物车" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(openShopCar)];
}

- (void)setUpSearchView {
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    //搜索
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    searchBgView.layer.masksToBounds = YES;
    searchBgView.layer.cornerRadius = 3;
    searchBgView.backgroundColor = [UIColor colorWithHexString:@"#f1f4f7"];
    searchBgView.userInteractionEnabled = YES;
    [self.headerView addSubview:searchBgView];
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    //搜索按钮
    UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:[UIColor textColor] backgroundColor:kWhiteColor titleFont:15.0 cornerRadius:15.0];
    
    [btn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth - 30);
        make.height.mas_equalTo(30);
    }];
    
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 15, 5, kScreenWidth - 45)];
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(14)
                                       textColor:[UIColor textColor2]];
    [searchBgView addSubview:searchLbl];
    searchLbl.text = @"请输入你感兴趣的商品";
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left).offset(20);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];
    
}

- (void)setUpTableViewHeader {
    
    BaseWeakSelf;
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 180)];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        TLWebVC *webVC = [TLWebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    [self.headerView addSubview:bannerView];
    
    self.bannerView = bannerView;

    //中部分类
    CGFloat h = (kScreenWidth - 1.5)/4.0;
    
    CGFloat margin = 0.5;
    //
    UIScrollView *shopTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bannerView.yy, kScreenWidth, h)];
//    shopTypeScrollView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    shopTypeScrollView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:shopTypeScrollView];
    shopTypeScrollView.pagingEnabled = YES;
    shopTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.shopTypeScrollView = shopTypeScrollView;
    self.shopTypeScrollView.delegate = self;

    //可能出现pageCtrl
    UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, shopTypeScrollView.yy + 1, 20, 20)];
    pageCtrl.backgroundColor = [UIColor whiteColor];
    pageCtrl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
    pageCtrl.currentPageIndicatorTintColor = kAppCustomMainColor;
    [self.headerView addSubview:pageCtrl];
    
    self.shopTypePageCtrl = pageCtrl;
}

- (void)setUpIntegralMall {
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.shopTypeScrollView.yy, kScreenWidth, kIntegralHeight)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:whiteView];
    
    self.whiteView = whiteView;
    
    UIView *lineView = [UIView new];
    
    lineView.backgroundColor = kPaleGreyColor;
    [whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    self.integralBtn = [UIButton buttonWithImageName:PLACEHOLDER_SMALL];
    
    self.integralBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.integralBtn addTarget:self action:@selector(clickToIntegralBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:self.integralBtn];
    [self.integralBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0.5);
        make.height.mas_equalTo(kWidth(kIntegralHeight));
        make.width.mas_equalTo(kScreenWidth);
        
    }];
}

- (void)setUpSpecialMall {

    _itemTitles = @[@"今日特价", @"人气推荐", @"超值热卖"];
    
    CGFloat space = 10;
    
    CGFloat w = (kScreenWidth - 4*space)/3.0;
    
    CGFloat h = w+10+10+10+16+40;
    
    _selectView = [[GoodSelectView alloc] initWithFrame:CGRectMake(0, self.whiteView.yy + 5, kScreenWidth, h) itemTitles:_itemTitles btnWidth:80];
    
    [_selectView setTitlePropertyWithTitleColor:kBlackColor titleFont:Font(14.0) selectColor:[UIColor colorWithHexString:@"#45a74f"]];
    
    [_selectView setLinePropertyWithLineColor:kAppCustomMainColor lineSize:CGSizeMake(56, 2)];
    
    [self.headerView addSubview:_selectView];
    
    for (NSInteger i = 0; i < _itemTitles.count; i++) {
        
        SpecialMallVC *childVC = [SpecialMallVC new];
        
        childVC.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, h - 40);
        
        childVC.goodType = i;
        
        [self addChildViewController:childVC];

        [_selectView.scrollView addSubview:childVC.view];
        
        [childVC startLoadData];
        
    }

}

- (void)setUpTableView {
    
    //
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0,0, kScreenWidth, kSuperViewHeight - kTabBarHeight) delegate:self dataSource:self];
    
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品" topMargin:42];
    
    [tableView registerClass:[GoodListCell class] forCellReuseIdentifier:@"GoodCellId"];
    
    [self.view addSubview:tableView];
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, self.selectView.yy + 5);
    
    tableView.tableHeaderView = self.headerView;
    
    self.shopTableView = tableView;
    
    self.goods = [NSMutableArray array];
}

#pragma mark - Data

- (void)requestIntegralMallImg {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"806052";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"2";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.intregalRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.intregalPics = [NSMutableArray array];
        
        //取出图片
        [self.intregalRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.intregalPics addObject:[obj.pic convertImageUrl]];
        }];
        
        if (self.intregalPics.count == 0) {
            
            return ;
        }
        
        [self.integralBtn sd_setImageWithURL:[NSURL URLWithString:self.intregalPics[0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808025";
    
    helper.parameters[@"status"] = @"3";
    helper.parameters[@"kind"] = @"1";
    helper.parameters[@"location"] = @"1";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.shopTableView;
    [helper modelClass:[GoodModel class]];
    
    self.pageDataHelper = helper;
    
    [self.shopTableView addRefreshAction:^{
        
        //广告图
        [weakSelf getBanner];
        
        //获取商品类型
        [weakSelf getType];
        
        //获取积分商城入口图
        [weakSelf requestIntegralMallImg];
        
        //刷新特价商品
        for (UIViewController *vc in weakSelf.childViewControllers) {
            
            SpecialMallVC *mallVC = (SpecialMallVC *)vc;
            
            [mallVC startLoadData];
        }
        
        //店铺数据
        [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            [weakSelf.shopTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }];
    
    
    [self.shopTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.shopTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    //--//
    [self.shopTableView endRefreshingWithNoMoreData_tl];
    
    //异步更新用户信息
    if ([TLUser user].userId) {
        [[TLUser user] updateUserInfo];
    }
}

#pragma mark- 获得店铺类型
- (void)getType {
    
    //presentCode: 0一级分类  1二级分类
    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"1";
    http.parameters[@"parentCode"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        //1.获取数据
        NSArray <ShopTypeModel *>* models = [ShopTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //2.先移除原来的
        if (self.shopTypeViewRooms.count > 0) {
            
            [self.shopTypeViewRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shopTypeViewRooms removeAllObjects];
        }
        
        //计算几页
        NSInteger pageCount = models.count/9 + 1;
        //
        _scrollHeight = (models.count/5 + 1)*(kScreenWidth - 1.5)/4.0;
        
        self.shopTypePageCtrl.numberOfPages = pageCount;
        //        [self.shopTypePageCtrl updateCurrentPageDisplay];
        self.shopTypePageCtrl.defersCurrentPageDisplay = YES;
        self.shopTypePageCtrl.hidden = pageCount == 1 ? YES: NO;

        CGRect frame = self.shopTypeScrollView.frame;

        self.shopTypeScrollView.contentSize = CGSizeMake(pageCount*kScreenWidth, _scrollHeight);
        
        self.shopTypeScrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, _scrollHeight);
        
        //3.然后添加新的
        CGFloat margin = 0;
        
        //
        CGFloat w = (kScreenWidth - 3*margin)/4.0;
        CGFloat h = w;
        NSInteger modulesNum = models.count > 4? 8: 4;
        
        __weak typeof(self) weakSelf = self;
        for (NSInteger i = 0; i < models.count; i ++) {
            
            //i 无要求
            CGFloat x = (w + margin)*(i%4) + kScreenWidth *(i/modulesNum);
            
            CGFloat y = (h + margin)*((i - modulesNum*(i/modulesNum))/4) + 0.5;
            
            ShopTypeView *shopTypeView = [[ShopTypeView alloc] initWithFrame:CGRectMake(x, y, w, h)
                                                                    funcName:models[i].name];
            [self.shopTypeScrollView addSubview:shopTypeView];
            
            [self.shopTypeViewRooms addObject:shopTypeView];
            [shopTypeView.funcBtn sd_setImageWithURL:[NSURL URLWithString:[models[i].pic convertImageUrl]] forState:UIControlStateNormal];
            shopTypeView.index = i;
            shopTypeView.selected = ^(NSInteger index) {
                
                [weakSelf selectedShopType:models[index].code index:index];
                
            };
            
        }
        
        self.shopTypePageCtrl.y = self.shopTypeScrollView.yy + 1;
        
        CGFloat y = pageCount == 1 ? self.shopTypeScrollView.yy + 1: self.shopTypeScrollView.yy + 21;

        self.whiteView.y = y;
        
        self.selectView.y = self.whiteView.yy + 1;
        
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, self.selectView.yy + 5);

        self.shopTableView.tableHeaderView = self.headerView;
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)getBanner {
    
    //广告图
    //location: 0周边  1商城
    __weak typeof(self) weakSelf = self;
    TLNetworking *http = [TLNetworking new];
    http.code = @"806052";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"1";
    http.parameters[@"longitude"] = self.lon;
    http.parameters[@"latitude"] = self.lat;
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - Events

//- (void)clickShoppingCart {
//
//    ZHShoppingCartVC *shoppingCartVC = [ZHShoppingCartVC new];
//
//    [self.navigationController pushViewController:shoppingCartVC animated:YES];
//}

- (void)openShopCar {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            
            ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return;
    }
    
    ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)search {
    
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.type = SearchVCTypeDefaultGoods;
    searchVC.lon = self.lon;
    searchVC.lat = self.lat;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)selectedShopType:(NSString *)code index:(NSInteger)index {
    
    GoodCategoryVC *categoryVC = [GoodCategoryVC new];
    
    categoryVC.selectIndex = index;
    
    [self.navigationController pushViewController:categoryVC animated:YES];
    
}

- (void)clickToIntegralBtn:(UIButton *)sender {
    
//    BaseWeakSelf;
//    if (![TLUser user].isLogin) {
//        
//        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
//        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:nav animated:YES completion:nil];
//        loginVC.loginSuccess = ^(){
//            
//            IntegralMallVC *mallVC = [IntegralMallVC new];
//            
//            [weakSelf.navigationController pushViewController:mallVC animated:YES];
//        };
//        return;
//    }
    
    IntegralMallVC *mallVC = [IntegralMallVC new];
    
    [self.navigationController pushViewController:mallVC animated:YES];
}

#pragma mark - UITableViewSatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goods.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GoodCellId = @"GoodCellId";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodCellId forIndexPath:indexPath];
    
    GoodModel *goodModel = self.goods[indexPath.row];
    
    cell.goodModel = goodModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodModel *good = self.goods[indexPath.row];
    
    ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
    detailVC.goods = good;
    detailVC.detailType = ZHGoodsDetailTypeDefault;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth, 42) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(15) textColor:[UIColor zh_textColor]];
    lbl.text = @"精品推荐";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
    
}

- (UIView *)funcViewWithFrame:(CGRect) frame imageName:(NSString *)imgName funcName:(NSString *)funcName {
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 45, 45)];
    [bgView addSubview:funcBtn];
    funcBtn.centerX = bgView.width/2.0;
    [funcBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    CGFloat h = [[UIFont thirdFont] lineHeight];
    UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor textColor]];
    nameLbl.centerX = funcBtn.centerX;
    nameLbl.text = funcName;
    [bgView addSubview:nameLbl];
    
    return bgView;
    
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.shopTypeScrollView]) {
        
        self.shopTypePageCtrl.currentPage = scrollView.contentOffset.x/self.shopTypeScrollView.width;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
