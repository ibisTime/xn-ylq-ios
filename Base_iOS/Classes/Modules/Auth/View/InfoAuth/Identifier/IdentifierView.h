//
//  IdentifierView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataView.h"
#import "AuthModel.h"

typedef NS_ENUM(NSInteger, IdentifierType) {

    IdentifierTypeIDCard = 0,       //身份证
    IdentifierTypeFaceRecognition,  //人脸识别
    IdentifierTypeCommit,           //提交
};

typedef void(^IdentifierBlock)(IdentifierType type);

@interface IdentifierView : UIView

@property (nonatomic, assign) IdentifierType identifierType;

@property (nonatomic, copy) IdentifierBlock identifierBlock;

@property (nonatomic, strong) NSMutableArray <SectionModel *>*datas;

@property (nonatomic, strong) AuthModel *authModel;

@end
