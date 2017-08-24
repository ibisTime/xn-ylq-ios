//
//  DataModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, DataType) {//认证类型

    DataTypeSFRZ = 0,       //身份认证
    DataTypeBaseInfo,       //基本信息
    DataTypeZMF,            //芝麻分
    DataTypeYYSRZ,          //运营商认证
    DataTypeTXLRZ,          //通讯录认证
    DataTypeWXRZ,           //微信认证
};

@class SectionModel;

@interface DataModel : BaseModel

@property (nonatomic, copy) NSString *topTitle;

@property (nonatomic, copy) NSString *topImg;

@property (nonatomic, strong) NSArray *contentArr;  //内容

@property (nonatomic, strong) NSArray *imgArr;      //图标

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger num;        //每行分几个

@property (nonatomic, assign) CGFloat topH;         //顶部高度

@property (nonatomic, strong) NSMutableArray <SectionModel *>*sections;

@property (nonatomic, strong) NSArray *typeArr;

//
@property (nonatomic, assign) CGFloat sectionW;

@property (nonatomic, assign) CGFloat sectionH;

@property (nonatomic, assign) CGFloat lineW;

@property (nonatomic, assign) CGFloat lineH;

@end

@interface SectionModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) DataType type;        //认证类型

@property (nonatomic, copy) NSString *flag;         //认证状态

@property (nonatomic, copy) NSString *authStatusStr;

@property (nonatomic, copy) NSString *authStatusImg;


@end
