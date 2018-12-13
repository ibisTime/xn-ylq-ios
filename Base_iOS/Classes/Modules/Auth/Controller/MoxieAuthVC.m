//
//  MoxieAuthVC.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/12/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MoxieAuthVC.h"
#import <MoxieSDK.h>
@interface MoxieAuthVC ()<MoxieSDKDelegate>

@end

@implementation MoxieAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].taskType = @"carrier";
    MXLoginCustom *loginCustom = [MXLoginCustom new];
    if (self.userInfoIsRight == YES) {
        loginCustom.loginParams = @{
                                    @"phone":[NSString stringWithFormat:@"%@",[TLUser user].mobile],
                                    @"name":[NSString stringWithFormat:@"%@",[TLUser user].realName],
                                    @"idcard":[NSString stringWithFormat:@"%@",[TLUser user].idNo]
                                    };
        [MoxieSDK shared].loginCustom = loginCustom;
    }

    [[MoxieSDK shared] start];
    // Do any additional setup after loading the view.
}
#pragma MoxieSDK Result Delegate
//魔蝎SDK --- 回调数据结果
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    //任务结果code，详细参考文档
    return;
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
