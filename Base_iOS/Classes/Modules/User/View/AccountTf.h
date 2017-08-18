//
//  AccountTf.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LeftType) {
    
    LeftTypeImage = 0,
    LeftTypeTitle,
    
};

@interface AccountTf : UITextField

@property (nonatomic,strong) UIImageView *leftIconView;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic,copy) NSString *placeHolder;

@property (nonatomic, assign) LeftType leftType;

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

- (instancetype)initWithFrame:(CGRect)frame leftType:(LeftType)leftType;

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder;
@end
