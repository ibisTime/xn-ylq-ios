//
//  PayFuncModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger,PayType){
    
    PayTypeAlipay = 0,
    PayTypeWeChat,
    PayTypeBaoFu,       //银行卡
    PayTypeOther,
};

@interface PayFuncModel : BaseModel

@property (nonatomic,copy) NSString *payImgName;
@property (nonatomic,copy) NSString *payName;
@property (nonatomic,assign) PayType payType;
@property (nonatomic,assign) BOOL isSelected;

@end
