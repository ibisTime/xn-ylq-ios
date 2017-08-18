//
//  MXOperatorAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MXOperatorAuthVC.h"

#import "MoxieSDK.h"
#import <WebKit/WebKit.h>

@interface MXOperatorAuthVC ()<MoxieSDKDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *htmlStr;

@end

@implementation MXOperatorAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIBarButtonItem addRightItemWithTitle:@"重新导入" frame:CGRectMake(0, 0, 70, 30) vc:self action:@selector(reloadUser)];
    
    [self initMXSDK];
    
    [self initWebView];

}

#pragma mark - Init
- (void)initMXSDK {
    
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].mxUserId = kMoXieUserID;
    [MoxieSDK shared].mxApiKey = kMoXieApiKey;
    [MoxieSDK shared].fromController = self;
    //    [MoxieSDK shared].cacheDisable = YES;
    
    [MoxieSDK shared].backImageName = @"返回";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
}

- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
//    NSString *htmlStr = [NSString stringWithFormat:@"https://tenant.51datakey.com/carrier/report_data?data=%@", [TLUser user].message];
//    
//    [self loadWebWithString:htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    [_webView loadHTMLString:string baseURL:nil];
}

#pragma mark - Events
- (void)reloadUser {

    [MoxieSDK shared].taskType = @"carrier";
    
    [[MoxieSDK shared] startFunction];
}

#pragma mark - MoxieSDKDelegate

-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary {
    
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
    NSString *searchId = resultDictionary[@"searchId"];
    NSString *message = resultDictionary[@"message"];
    NSString *account = resultDictionary[@"account"];
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,searchId:%@,message:%@,account:%@",code,taskType,taskId,searchId,message,account);
    
//    [TLUser user].message = message;
//    
//    NSDictionary *userInfo = @{@"message": message};
//    
//    [[TLUser user] saveUserInfo:userInfo];
    
    if(code == 2) {
        //继续查询该任务进展
        
        [TLAlert alertWithInfo:@"继续查询该任务进展"];
        
    } else if(code == 1) {
        
        //code是1则成功

        [TLProgressHUD show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"623048";
            http.parameters[@"userId"] = [TLUser user].userId;
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLProgressHUD dismiss];
                
                [TLAlert alertWithSucces:@"认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                });
                
            } failure:^(NSError *error) {
                
                
            }];
            
        });
        
    } else if(code == -1) {
        //用户没有做任何操作
        
        //        [TLAlert alertWithInfo:@"用户没有做任何操作"];
        
    } else if(code == -2) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"平台方服务问题"];
        
    } else if(code == -3) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"魔蝎数据服务异常"];
        
    }else if(code == -4) {
        //用户没有做任何操作
        
        [TLAlert alertWithInfo:@"用户输入出错"];
        
    }else {
        
        //该任务失败按失败处理
        [TLAlert alertWithError:@"查询失败"];
    }
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
