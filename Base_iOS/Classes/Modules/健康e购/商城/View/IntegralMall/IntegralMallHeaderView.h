//
//  IntegralMallHeaderView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IntegralBtnEvents)();

@interface IntegralMallHeaderView : UIView

@property (nonatomic, copy) IntegralBtnEvents btnEvnets;

@property (nonatomic, copy) NSString *jfNum;

- (instancetype)initWithFrame:(CGRect)frame btnEvnets:(IntegralBtnEvents)btnEvnets;

- (void)changeInfo;

- (void)logout;

@end
