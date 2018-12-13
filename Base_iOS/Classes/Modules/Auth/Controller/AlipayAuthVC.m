//
//  AlipayAuthVC.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/11/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AlipayAuthVC.h"
#import "TLTextField.h"
#import <MoxieSDK.h>
@interface AlipayAuthVC ()<MoxieSDKDelegate>
@property (nonatomic ,strong) TLTextField *realName;

@property (nonatomic ,strong) TLTextField *cardNo;
@end

@implementation AlipayAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self initSubViews];
}
#pragma MoxieSDK Result Delegate
//魔蝎SDK --- 回调数据结果
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    return;
    //任务结果code，详细参考文档
    int code = [resultDictionary[@"code"] intValue];
    //是否登录成功
    BOOL loginDone = [resultDictionary[@"loginDone"] boolValue];
    //任务类型
    NSString *taskType = resultDictionary[@"taskType"];
    //任务Id
    NSString *taskId = resultDictionary[@"taskId"];
    //描述
    NSString *message = resultDictionary[@"message"];
    //当前账号
    NSString *account = resultDictionary[@"account"];
    //用户在该业务平台上的userId，例如支付宝上的userId（目前支付宝，淘宝，京东支持）
    NSString *businessUserId = resultDictionary[@"businessUserId"]?resultDictionary[@"businessUserId"]:@"";
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,message:%@,account:%@,loginDone:%d，businessUserId:%@",code,taskType,taskId,message,account,loginDone,businessUserId);
    //【登录中】假如code是2且loginDone为false，表示正在登录中
    if(code == 2 && loginDone == false){
        NSLog(@"任务正在登录中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【采集中】假如code是2且loginDone为true，已经登录成功，正在采集中
    else if(code == 2 && loginDone == true){
        NSLog(@"任务已经登录成功，正在采集中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【采集成功】假如code是1则采集成功（不代表回调成功）
    else if(code == 1){
        NSLog(@"任务采集成功，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【未登录】假如code是-1则用户未登录
    else if(code == -1){
        NSLog(@"用户未登录");
    }
    //【任务失败】该任务按失败处理，可能的code为0，-2，-3，-4
    else{
        NSLog(@"任务失败");
    }
}
- (void)initSubViews {
    TLTextField *realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"支付宝账号" titleWidth:100 placeholder:@"请输入支付宝账号"];
    [self.view addSubview:realName];
    self.realName = realName;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, realName.yy + 1, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor zh_lineColor];
    [self.view addSubview:line];
    
    TLTextField *cardNo = [[TLTextField alloc] initWithFrame:CGRectMake(0, line.yy, kScreenWidth, 45) leftTitle:@"支付宝密码" titleWidth:100 placeholder:@"请输入支付宝密码"];
    [self.view addSubview:cardNo];
    cardNo.secureTextEntry = YES;
    self.cardNo = cardNo;
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:22];
    
    [confirmBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(30, cardNo.yy+50, kScreenWidth-60, 45);
}


- (void)submit
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623057";
    if (![self.realName.text valid]) {
        [TLAlert alertWithInfo:@"请输入支付宝账号"];
        return ;
    }
    if (![self.cardNo.text valid]) {
        [TLAlert alertWithInfo:@"请输入支付宝登录密码"];
        return ;
    }
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"accountNumber"] = self.realName.text;
    http.parameters[@"password"] = self.cardNo.text;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithInfo:@"认证成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}
@end
