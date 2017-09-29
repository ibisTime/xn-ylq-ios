//
//  SelectScrollView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

@end
