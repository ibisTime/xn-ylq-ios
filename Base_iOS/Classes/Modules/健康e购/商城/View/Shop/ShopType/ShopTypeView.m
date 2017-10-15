//
//  ShopTypeView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopTypeView.h"

@implementation ShopTypeView

- (instancetype)initWithFrame:(CGRect)frame funcName:(NSString *)funcName {
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgView = self;
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (kScreenWidth/4.0 - 50)/2.0, 30, 30)];
        
        [funcBtn setEnlargeEdge:20];
        [bgView addSubview:funcBtn];
        funcBtn.centerX = bgView.width/2.0;
        [funcBtn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
        
        [funcBtn setEnlargeEdge:135];
        self.funcBtn = funcBtn;
        
        CGFloat h = [[UIFont thirdFont] lineHeight];
        
        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor textColor]];
        nameLbl.centerX = funcBtn.centerX;
        nameLbl.text = funcName;
        [bgView addSubview:nameLbl];
        
        CGFloat margin = 0.5;
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.width - margin, 0, margin, bgView.height)];
        
        rightLine.backgroundColor = kLineColor;
        
        [bgView addSubview:rightLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height - margin, bgView.width, margin)];
        
        bottomLine.backgroundColor = kLineColor;
        
        [bgView addSubview:bottomLine];
    }
    
    return self;
    
}

//--//
- (void)selectedAction {
    
    if (self.selected) {
        self.selected(self.index);
    }
    
}

@end
