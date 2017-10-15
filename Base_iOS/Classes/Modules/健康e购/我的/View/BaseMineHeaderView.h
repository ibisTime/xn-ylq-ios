//
//  BaseMineHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    MineHeaderSeletedTypeDefault = 0,   //用户资料
    MineHeaderSeletedTypeIntregalFlow,          //积分流水
    MineHeaderSeletedTypeSelectPhoto,   //拍照
    MineHeaderSeletedTypeRMBFlow,       //人民币流水
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx;

@end

@interface BaseMineHeaderView : UIView

@property (nonatomic, strong) UIImageView *userPhoto;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIImageView *genderImg;
@property (nonatomic, strong) UIImageView *vipImg;

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;

//
@property (nonatomic, strong) NSString *rmbNum;

@property (nonatomic, copy) NSString *jfNumText;

@property (nonatomic, copy) NSArray <NSNumber *>*numberArray;

- (void)reset;

@end
