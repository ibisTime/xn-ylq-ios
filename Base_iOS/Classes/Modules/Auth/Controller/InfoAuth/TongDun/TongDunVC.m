//
//  TongDunVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TongDunVC.h"

#import <WebKit/WebKit.h>
#import "AuthModel.h"

@interface TongDunVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TongDunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运营商认证";
    
    [self initWebView];

}

#pragma mark - Init
- (void)initWebView {
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
    NSString *token = @"5613A6F334DC4E12944AF748EE11FDEA";
    
    NSString *htmlStr = [NSString stringWithFormat:@"https://open.shujumohe.com/box/yys?box_token=%@&real_name=%@&identity_code=%@&user_mobile=%@", token, [TLUser user].realName,[TLUser user].idNo, [TLUser user].mobile];
    
    [self loadWebWithUrl:[htmlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (void)loadWebWithUrl:(NSString *)url {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [_webView loadRequest:urlRequest];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [TLProgressHUD showWithStatus:@"加载失败"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme]; //webView尝试访问链接时，会被此处拦截处理
    if ([scheme isEqualToString:@"somescheme"]) {
        NSString *host = [URL host];
        //判断host
        if ([host isEqualToString:@"somehost"]) {
            //拦截后做处理

            NSLog(@"拦截了");
        }
        //返回NO,阻止页面继续跳转到不存在的url地址
        decisionHandler(WKNavigationActionPolicyCancel);

    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
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
