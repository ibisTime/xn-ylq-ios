//
//  MineHeaderView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    MineHeaderSeletedTypeDefault = 0,   //用户资料
    MineHeaderSeletedTypeQuota,         //额度
    MineHeaderSeletedTypeSelectPhoto,   //拍照
    MineHeaderSeletedTypeCoupon,       //优惠券
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIImageView *genderImg;
@property (nonatomic, strong) UIImageView *vipImg;

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;


//
@property (nonatomic, strong) NSString *couponNum;

@property (nonatomic, copy) NSString *quotaNum;

@property (nonatomic, copy) NSArray <NSNumber *>*numberArray;

- (void)reset;

@end
