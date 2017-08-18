//
//  ShareView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/26.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShareView.h"

typedef void (^ShareViewTypeBlock) (NSString *title);

@interface ShareView : UIView

@property (nonatomic , copy) ShareViewTypeBlock shareBlock;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *shareURL;

@property (nonatomic, copy) NSString *shareImgStr;

@property (nonatomic, copy) NSString *shareDesc;

- (void)customShareViewButtonAction:(CustomShareView *)shareView title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame shareBlock:(ShareViewTypeBlock)shareBlock vc:(UIViewController *)vc;

@end
