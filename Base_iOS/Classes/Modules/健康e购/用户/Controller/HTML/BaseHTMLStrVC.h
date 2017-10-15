//
//  BaseHTMLStrVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSUInteger, HTMLType) {
    HTMLTypeAboutUs = 0,    //关于我们
    HTMLTypeRegProtocol,    //注册协议
    HTMLTypeIntregalRule,   //积分规则
    HTMLTypePostBan,        //发帖禁令
    
};

@interface BaseHTMLStrVC : TLBaseVC

@property (nonatomic, assign) HTMLType type;

@end
