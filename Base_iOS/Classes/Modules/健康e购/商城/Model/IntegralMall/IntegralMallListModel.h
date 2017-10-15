//
//  IntegralMallListModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntegralInfo;

@interface IntegralMallListModel : UIView

@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, strong) NSArray<IntegralInfo *> *productSpecsList;

@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, assign) NSInteger boughtCount;

@end

@interface IntegralInfo : NSObject

@property (nonatomic, strong) NSNumber *price1;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, strong) NSNumber *originalPrice;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *systemCode;

@end

