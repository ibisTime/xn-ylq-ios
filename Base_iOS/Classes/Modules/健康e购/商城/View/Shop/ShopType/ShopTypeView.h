//
//  ShopTypeView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTypeView : UIView

@property (nonatomic,copy)  void(^selected)(NSInteger index);

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) UIButton *funcBtn;

- (instancetype)initWithFrame:(CGRect)frame funcName:(NSString *)funcName;

@end
