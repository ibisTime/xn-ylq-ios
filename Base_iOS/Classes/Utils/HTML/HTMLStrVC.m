//
//  HTMLStrVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HTMLStrVC.h"
#import <WebKit/WebKit.h>

@interface HTMLStrVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HTMLStrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self requestContent];
}

#pragma mark - Data

- (void)requestContent {
    
    NSString *name = @"";
    
    NSString *ckey = @"";
    
    switch (self.type) {
            
        case HTMLTypeAboutUs: {
            
            ckey = @"aboutUs";
            
            name = @"关于我们";
            
        } break;
            
        case HTMLTypeRegProtocol: {
            
            ckey = @"regProtocol";
            
            name = @"借款服务与隐私协议";
            
        } break;
            
        case HTMLTypeHelpCenter: {
            
            ckey = @"helpCenter";
            
            name = @"帮助中心";
            
        } break;
            
        case HTMLTypeCouponExplain: {
            
            ckey = @"couponExplain";
            
            name = @"优惠券说明";
            
        } break;
            
        case HTMLTypeBorrowProtocol: {
            
            ckey = @"borrowProtocol";
            
            name = @"借款协议";
            
        } break;
            
        case HTMLTypeAuthProtocol: {
            
            ckey = @"addressBookProtocol";
            
            name = @"通讯录授权协议";
            
        } break;
        
        case HTMLTypeInfoRule: {
            
            ckey = @"infoCollectRule";
            
            name = @"信息收集及使用规则";
            
        } break;
            
        case HTMLTypeContactCustomer: {
            
            ckey = @"customerService";
            
            name = @"联系客服";
            
        } break;
    }

    self.navigationItem.titleView = [UILabel labelWithTitle:name];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = ckey;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init

- (void)initWebView {

    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) configuration:wkConfig];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
