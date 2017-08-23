//
//  AppMacro.h
//  LetWeCode
//
//  Created by 蔡卓越 on 15/10/28.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#pragma mark - ToolsMacros

// 如果数据为NULL，设为nil
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

// 处理nil，为空字符串@""
#define STRING_NIL_NULL(x) if(x == nil || [x isKindOfClass:[NSNull class]]){x = @"";}

//
#define ARRAY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @[];}


#define BaseWeakSelf  __weak typeof(self) weakSelf = self;

// 统一处理打印日志
#ifdef DEBUG
#define DLog(format, ...)  NSLog(format, __VA_ARGS__)
#else
#define DLog(...)
#endif

#define ArtDEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - Image

#define USER_PLACEHOLDER_SMALL [UIImage imageNamed:@"icon"]
#define PLACEHOLDER_SMALL @"头像"
#define kCancelIcon @"cancel"


#define kDateFormmatter @"MMM dd, yyyy hh:mm:ss aa"

#pragma mark - 开发中

//YES  开发中， NO 开发完成
#define kInDevelopment NO

#pragma mark - 轮播图

#define kCarouselHeight (kScreenWidth/5*3)

#pragma mark - HttpMacros


#endif /* AppMacro_h */
