//
//  BankCardAuthResultVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/2.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface BankCardAuthResultVC : BaseViewController

@property (nonatomic, assign) BOOL result;              //认证结果

@property (nonatomic, copy) NSString *failureReason;    //失败原因

@property (nonatomic, copy) NSString *realName;         //真实姓名

@property (nonatomic, copy) NSString *idCard;           //身份证号码

@property (nonatomic, copy) NSString *mobile;           //手机号

@property (nonatomic, copy) NSString *bankCardId;       //银行卡号

@end
