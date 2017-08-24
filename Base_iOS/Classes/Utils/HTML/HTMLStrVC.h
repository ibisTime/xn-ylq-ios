//
//  HTMLStrVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, HTMLType) {
    HTMLTypeAboutUs = 0,    //关于我们
    HTMLTypeRegProtocol,    //注册协议
    HTMLTypeHelpCenter,     //帮助中心
    HTMLTypeCouponExplain,  //优惠券说明
    HTMLTypeBorrowProtocol, //借款协议
    HTMLTypeAuthProtocol,   //通讯录授权协议
    HTMLTypeInfoRule,       //信息收集及使用规则
};

@interface HTMLStrVC : TLBaseVC

@property (nonatomic, assign) HTMLType type;

//@property (nonatomic, copy) NSString *ckey;

@end
