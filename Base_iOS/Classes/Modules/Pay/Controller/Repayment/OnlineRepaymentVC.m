//
//  OnlineRepaymentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OnlineRepaymentVC.h"

#import "PayInfoCell.h"
#import "PayFuncModel.h"

#import "TLWXManager.h"
#import "TLAlipayManager.h"
#import <WebKit/WebKit.h>
@interface OnlineRepaymentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WKNavigationDelegate>

@property (nonatomic,strong) TLTextField *amountTf;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic,strong) TLTextField *accountNmme;

@property (nonatomic,strong) TLTextField *accountNameCn;

@property (nonatomic,strong) TLTextField *accountremark;

@property (nonatomic,strong) TLTextField *receiveTf;

@property (nonatomic, copy) NSString *htmlStr;


@property (nonatomic,strong) TLTableView *tableView;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) NSMutableArray <PayFuncModel *>*pays;

@end

@implementation OnlineRepaymentVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"还款";
    
//    [self beginLoad];
    
    [self initSubviews];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

#pragma mark - Init

- (TLTextField *)amountTf {
    
    if (!_amountTf) {
        
        _amountTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:@"还款金额" titleWidth:100 placeholder:@""];
        
        _amountTf.backgroundColor = [UIColor whiteColor];
        _amountTf.delegate = self;
        _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
        
        _amountTf.text = [self.order.totalAmount convertToSimpleRealMoney];
        
        _amountTf.enabled = NO;
    }
    return _amountTf;
    
}

- (void)initSubviews {
    

    self.accountNmme = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:@"还款金额:" titleWidth:100 placeholder:@""];
    self.accountNmme.text = [self.order.totalAmount convertToSimpleRealMoney];

    self.accountNmme.backgroundColor = [UIColor whiteColor];
    self.accountNmme.textColor = [UIColor orangeColor];

    self.accountNmme.delegate = self;
    if (self.renewalModel) {
        self.accountNmme.text = [self.renewalModel.amount convertToSimpleRealMoney];
        [self loadUrl];
    }else{
        [self loadUrl];

        self.accountNmme.text = [self.order.totalAmount convertToSimpleRealMoney];

    }
    
    [self.view addSubview:self.accountNmme];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, self.accountNmme.yy, kScreenWidth, 0.5);
    line.backgroundColor = kLineColor;
    [self.view addSubview:line];
    
    self.accountNameCn = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.accountNmme.yy+2, kScreenWidth, 50) leftTitle:@"还款期数:" titleWidth:100 placeholder:@""];
    self.accountNameCn.text = [self.order.totalAmount convertToSimpleRealMoney];
    
    self.accountNameCn.backgroundColor = [UIColor whiteColor];
    self.accountNameCn.delegate = self;
    self.accountNameCn.textColor = [UIColor orangeColor];
    if (self.renewalModel) {
        self.accountNameCn.text = self.renewalModel.remark ;

    }else{
        self.accountNameCn.hidden = YES;

    }
    
    [self.view addSubview:self.accountNameCn];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kLineColor;

    line1.frame = CGRectMake(0, self.accountNameCn.yy, kScreenWidth, 0.5);
    [self.view addSubview:line1];
   
    UIButton *payBtn = [UIButton buttonWithTitle:@"确定还款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    CGFloat f ;
    self.payBtn = payBtn;
    
    [payBtn addTarget:self action:@selector(repayment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:payBtn];
    return;

    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    [self.view addSubview:self.tableView];
    
    self.tableView .tableHeaderView = self.amountTf;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //按钮
   
    
    self.tableView.tableFooterView = footerView;
    
}

- (void)loadUrl
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"key"] = @"repayOfflineAccount";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    if (self.renewalModel) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.accountNameCn.yy+10, kScreenWidth, 100) configuration:wkConfig];
        self.payBtn.frame = CGRectMake(15, self.webView.yy+30, kScreenWidth - 30, 45);

    }else{
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.accountNmme.yy+10, kScreenWidth, 100) configuration:wkConfig];
        self.payBtn.frame = CGRectMake(15, self.webView.yy +30, kScreenWidth - 30, 45);

    }
   
  
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
    [self loadWebWithString:self.htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
}

#pragma mark - Events

- (void)beginLoad {
    
    //--//
//    NSArray *imgs = @[@"weixin",@"alipay"];

//    payNames  = @[@"微信支付",@"支付宝"]; //余额(可用100)
//
//    NSArray *payType = @[@(PayTypeWeChat),@(PayTypeAlipay)];
//    NSArray <NSNumber *>*status = @[@(YES),@(NO)];
    
    NSArray *imgs = @[@"alipay", @"baofu"];
    
    NSArray *payNames;
    payNames  = @[@"支付宝", @"银行卡"]; //余额(可用100)
    
    NSArray *payType = @[@(PayTypeAlipay), @(PayTypeBaoFu)];
    NSArray <NSNumber *>*status = @[@(YES), @(NO)];
    
    self.pays = [NSMutableArray array];
    
    NSInteger count = imgs.count;
    
    
    //全部转换为支付模型
    for (NSInteger i = 0; i < count; i ++) {
        
        PayFuncModel *zhPay = [[PayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
    
}

- (void)repayment {
    
    __block PayType type;
    
    [self.pays enumerateObjectsUsingBlock:^(PayFuncModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            type = obj.payType;
            *stop = YES;
        }
        
    }];
    
    
    
    NSString *payType;
    
    switch (type) {
            
        case PayTypeBaoFu: {
            
            payType = @"5";
            
        }break;
            
        case PayTypeAlipay: {
            
            payType = @"3";
            
        }break;
            
        case PayTypeWeChat: {
            
            payType = @"2";
            
        }break;
            
        case PayTypeOther: {
            
            payType = @"1";
            
        }break;
            
    }
    
    [self shopPay:payType payPwd:nil];
    
}

#pragma mark- 优店支付, 余额支付需要支付密码
- (void)shopPay:(NSString *)payType payPwd:(nullable NSString *)pwd {
//    [self checkMoney];
//    return;
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    if (self.renewalModel) {
        http.parameters[@"stagingCode"] = self.renewalModel.stageCode;
        http.code = @"623182";

    }else{
        http.parameters[@"orderCode"] = self.order.code;
        http.code = @"623180";

    }
    
    [http postWithSuccess:^(id responseObject) {
        

            [TLAlert alertWithSucces:@"还款成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
//            if (self.paySucces) {
//                self.paySucces();
//            }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)checkMoney
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623181";
    //    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"code"] = @"RA2018112314561249036343";
    http.parameters[@"approver"] = @"test";
    http.parameters[@"approveResult"] = @"1";
    http.parameters[@"approveNote"] = self.order.code;

    [http postWithSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    [TLAlipayManager manager];
    
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"还款成功"];
            
            if (weakSelf.paySucces) {
                weakSelf.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"还款失败"];
        }
        
    }];
    
    
}

- (void)wxPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    NSDictionary *dict = info;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"wechatPackage"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]){
        
    } else {
        
        [TLAlert alertWithError:@"还款失败"];
    }
    //回调
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                [TLAlert alertWithSucces:@"还款成功"];
                
                if (weakSelf.paySucces) {
                    
                    weakSelf.paySucces();
                }
                
            } else {
                
                [TLAlert alertWithError:@"还款失败"];
            }
            
        });
        
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pays.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * payInfoCellID = @"PayInfoCell";
    PayInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:payInfoCellID];
    if (!cell) {
        cell = [[PayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payInfoCellID];
    }
    cell.pay = self.pays[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PayInfoCell class]]) {
        
        //----不是余额把 支付密码隐藏掉----//
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return [self payFuncHeaderView];
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)payFuncHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, kScreenWidth - 35, headView.height)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor zh_textColor]];
    lbl.text = @"支付方式";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = kLineColor;
    
    [headView addSubview:lineView];
    
    return headView;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
