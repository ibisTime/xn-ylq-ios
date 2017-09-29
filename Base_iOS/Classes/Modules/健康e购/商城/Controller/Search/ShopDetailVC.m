//
//  ShopDetailVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopDetailVC.h"
#import <WebKit/WebKit.h>

#import "ZHShopInfoCell.h"
#import "ZHTextDetailCell.h"
#import "ZHImageCell.h"
#import "CircleGuideView.h"
#import "ShareView.h"
#import <PYPhotoBrowseView.h>

#import "ZHPayVC.h"
#import "TLUserLoginVC.h"
//#import "HotelVC.h"
//#import "ShopAddressVC.h"

#import "ZHCurrencyModel.h"
#import "AppConfig.h"
//#import "ShopApi.h"
#import "WXApi.h"

#define kCarouselHeight (kScreenWidth/5*3)

@interface ShopDetailVC ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (nonatomic,strong) UILabel *shopNameLbl;
@property (nonatomic, strong) UILabel *advLbl;
@property (nonatomic, strong) UIButton *zanBtn;

@property (nonatomic, assign) BOOL isDZ;//是否点赞

@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) CircleGuideView *guideView;   //轮播图

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) CGFloat webHeight;
//是否扫码进入
@property (nonatomic, assign) BOOL isScan;

@property (nonatomic, strong) NSMutableArray *imageViewArr;

@end

@implementation ShopDetailVC

static char imgUrlArrayKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"店铺详情"];

    if (_isScan) {
        
        [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(clickBack)];
    }
}

#pragma mark - Init

- (UILabel *)shopNameLbl {
    
    if (!_shopNameLbl) {
        
        _shopNameLbl = [UILabel labelWithFrame:CGRectMake(15, 15, kScreenWidth - 15 -80, 15) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(14)
                                     textColor:[UIColor zh_textColor]];
    }
    return _shopNameLbl;
    
}

- (void)initCheckBtn {

    UIView *bgView = [UIView new];
    
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(0);
        
    }];
    
    self.checkBtn = [UIButton buttonWithTitle:@"我要入住" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    [self.checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth - 30);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-10);
        
    }];
}

- (void)initTableView {

    CGFloat h = self.detaileType == DetailTypeHotel? 60: 0;
    
    UITableView *shopDetailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - h) style:UITableViewStyleGrouped];
    shopDetailTV.delegate = self;
    shopDetailTV.dataSource = self;
    shopDetailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:shopDetailTV];
    
    self.tableView = shopDetailTV;
    
    NSMutableArray *imgNames = [NSMutableArray array];
    
    for (NSString *img in self.shop.detailPics) {
        
        [imgNames addObject:[img convertImageUrl]];
    }
    
    self.guideView = [[CircleGuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCarouselHeight) imageNames:imgNames];
    
    shopDetailTV.tableHeaderView = self.guideView;
    
    self.shopNameLbl.text = self.shop.name;
    
}

- (void)initWithWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) configuration:wkConfig];
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    _tableView.tableFooterView = _webView;
    
    if (_shop.descriptionShop != nil) {
        
        NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, _shop.descriptionShop];
        
        [_webView loadHTMLString:html baseURL:nil];
    }


}

- (UIView *)detailHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    topView.backgroundColor = kPaleGreyColor;
    
    [headView addSubview:topView];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 10, kScreenWidth - 35, 42) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(13) textColor:[UIColor zh_textColor]];
    lbl.text = @"图文详情";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 51.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
}

- (UIView *)addressHeaderView {
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    
    [headView addSubview:self.shopNameLbl];
    
    self.advLbl = [UILabel labelWithText:@"" textColor:[UIColor zh_textColor] textFont:12.0];
    self.advLbl.numberOfLines = 0;
    
    [headView addSubview:self.advLbl];
    
    [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_shopNameLbl.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(self.shop.sloganHeight);
    }];
    
    self.advLbl.text = self.shop.slogan;
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, 60 + self.shop.sloganHeight);
    
    //点赞
    
    self.zanBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@" %ld", self.shop.totalDzNum] titleColor:[UIColor textColor] backgroundColor:kClearColor titleFont:11.0];
    
    [self.zanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    
    [self.zanBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
    
    self.zanBtn.selected = _shop.isDZ == YES? YES: NO;
    
    [self.zanBtn addTarget:self action:@selector(doZan:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:self.zanBtn];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.shopNameLbl.mas_top).mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(15);
    }];
    
    return headView;
}

- (NSMutableAttributedString *)getAttributedStringWithImgStr:(NSString *)imgStr bounds:(CGRect)bounds num:(NSString *)num {
    
    NSAttributedString *string = [NSAttributedString convertImg:[UIImage imageNamed:imgStr] bounds:bounds];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:num];
    
    [attrStr insertAttributedString:string atIndex:0];
    
    return attrStr;
}

#pragma mark - Setting

- (void)setShop:(ShopModel *)shop {

    _shop = shop;
    
    if (!_shop.name) {
        
        _isScan = YES;
    }
    
    [self requestShopInfo];

}

#pragma mark - Events

- (void)doZan:(UIButton *)sender {
    
//    if (![TLUser user].userId) {
//
//        [self showReLoginVC];
//
//        return;
//    }
//
//    if (!sender.selected) {
//
//        [ShopApi dzShopWithCode:self.shop.code user:[TLUser user].userId success:^{
//
//            [TLAlert alertWithSucces:@"点赞成功"];
//
//            self.shop.totalDzNum += 1;
//            [sender setTitle:[NSString stringWithFormat:@" %ld", self.shop.totalDzNum] forState:UIControlStateNormal];
//            sender.selected = YES;
////            [self.shopTableView reloadData_tl];
//
//        } failure:^{
//
//            [TLAlert alertWithError:@"点赞失败"];
//        }];
//
//    } else {
//
//        [ShopApi cancleDzShopWithCode:self.shop.code user:[TLUser user].userId success:^{
//
//            [TLAlert alertWithSucces:@"取消点赞成功"];
//
//            self.shop.totalDzNum -= 1;
//            [sender setTitle:[NSString stringWithFormat:@" %ld", self.shop.totalDzNum] forState:UIControlStateNormal];
//
//            sender.selected = NO;
//
//        } failure:^{
//
//            [TLAlert alertWithError:@"取消点赞失败"];
//
//        }];
//    }
}

- (void)clickBack {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickCheckBtn:(UIButton *)sender {
    
    if (![TLUser user].userId) {
        
        [self showReLoginVC];
        
        return;
    }
    
//    HotelVC *hotelVC = [HotelVC new];
//
//    hotelVC.shop = self.shop;
//    hotelVC.name = self.shop.name;
//
//    [self.navigationController pushViewController:hotelVC animated:YES];
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
    shareView.shareDesc = self.shop.name;
    shareView.shareURL = [NSString stringWithFormat:@"%@/share/store.html?code=%@",[AppConfig config].shareBaseUrl,self.shop.code];
    
    NSString *shareImgStr = nil;
    
    shareView.shareImgStr = shareImgStr;
    
    [self.view addSubview:shareView];
    
    
}

#pragma mark - 买单
- (void)buy {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self  presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    ZHPayVC *payVC = [[ZHPayVC alloc] init];
    payVC.shop = self.shop;
    payVC.paySucces = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)callMobile {

    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.shop.bookMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (void)clickAddress:(UITapGestureRecognizer *)tapGR {

//    ShopAddressVC *addressVC = [ShopAddressVC new];
//
//    addressVC.shop = self.shop;
//
//    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)onResp:(BaseResp*)resp{
    
    
}

#pragma mark - Data
- (void)requestShopInfo {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808218";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"code"] = self.shop.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        _shop = [ShopModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if ([_shop.status isEqualToString:@"2"]) {
            
            [self initTableView];
            
            //web内容页
            [self initWithWebView];
            
            //入住
            if (self.detaileType == DetailTypeHotel) {
                
                [self initCheckBtn];
            }
            
        } else {
        
            [TLAlert alertWithInfo:@"店铺处于未上架状态，请联系商家"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];

            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString * reCellId = @"ZHShopInfoCellID";
    ZHShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellId];
    if (!cell) {
        
        cell = [[ZHShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellId];
        
    }
    
    cell.shop = self.shop;
    
    cell.buyBtn.hidden = _detaileType == DetailTypeHotel ? YES: NO;
    
    [cell.buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.mobileBtn addTarget:self action:@selector(callMobile) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddress:)];
    
    [cell addGestureRecognizer:tapGR];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 40 + self.shop.sloganHeight;
        
    } else {
        
        return 42;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        
        return 52;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [ZHShopInfoCell rowHeight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self addressHeaderView];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [self detailHeaderView];
    
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    //通过js获取htlm中图片url
    
    [self getImageUrlByJS:webView];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    _tableView.tableFooterView = _webView;
    
    [_webView sizeToFit];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark - 查看大图

- (void)setMethod:(NSArray *)imgUrlArray {
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray {
    
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}

/*
 
 *通过js获取htlm中图片url
 
 */

-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView

{
    
    //js方法遍历图片添加点击事件返回图片个数
    
    static  NSString * const jsGetImages = @"function getImages(){var objs = document.getElementsByTagName(\"img\");var imgUrlStr='';for(var i=0;i<objs.length;i++){if(i==0){if(objs[i].alt==''){imgUrlStr=objs[i].src;}}else{if(objs[i].alt==''){imgUrlStr+='#'+objs[i].src;}}objs[i].onclick=function(){ if(this.alt==''){document.location=\"myweb:imageClick:\"+this.src;}};};return imgUrlStr;};";
    
    //用js获取全部图片
    
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js___Result==%@",Result);
        
        NSLog(@"js___Error -> %@", error);
        
    }];
    
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js2__Result==%@",Result);
        
        NSLog(@"js2__Error -> %@", error);
        
        NSString *result=[NSString stringWithFormat:@"%@",Result];
        
        if([result hasPrefix:@"#"])
            
        {
            result = [result substringFromIndex:1];
        }
        
        NSLog(@"result===%@",result);
        
        array = [result componentsSeparatedByString:@"#"];
        
        NSLog(@"array====%@",array);
        
        [self setMethod:array];
        
        //创建图片视图数组
        self.imageViewArr = [NSMutableArray array];
        
        for (int i = 0; i < array.count; i++) {
            
            UIImageView *sourceIV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[array[i] convertImageUrl]]]]];
            
            [self.imageViewArr addObject:sourceIV];
        }
        
    }];
    
    return array;
    
}

//显示大图

-(BOOL)showBigImage:(NSURLRequest *)request {
    
    //将url转换为string
    
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSLog(@"image url------%@", imageUrl);
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        
        //当前选择哪张图片
        NSInteger index=0;
        
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            
            if([imageUrl isEqualToString:imgUrlArr[i]]) {
                
                index=i;
                
                break;
            }
        }
        
        //创建图片浏览器
        PYPhotoBrowseView *photoBrowseView = [[PYPhotoBrowseView alloc] init];
        
        //frameFormWindow
        photoBrowseView.frameFormWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
        //frameToWindow
        photoBrowseView.frameToWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
        
        photoBrowseView.imagesURL = imgUrlArr;

//        photoBroseView.sourceImgageViews = [self.imageViewArr copy];
        
        photoBrowseView.currentIndex = index;
        
        [photoBrowseView show];
        
        return NO;
        
    }
    
    return YES;
    
}

@end
