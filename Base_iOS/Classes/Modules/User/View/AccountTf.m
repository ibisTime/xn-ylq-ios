//
//  AccountTf.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountTf.h"

@implementation AccountTf

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, frame.size.height)];
        
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
        _leftIconView.contentMode = UIViewContentModeCenter;
        _leftIconView.centerY = leftBgView.height/2.0;
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
        [leftBgView addSubview:_leftIconView];
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
    
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //白色边界线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.7, 18)];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.centerY = frame.size.height/2.0;
        lineView.centerX = leftBgView.width;
        
        [leftBgView addSubview:lineView];
        self.tintColor = kAppCustomMainColor;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame leftType:(LeftType)leftType {
    
    if (self = [super initWithFrame:frame]) {
        
        _leftType = leftType;
        
        UIView *leftBgView = [[UIView alloc] init];
        
        if (leftType == LeftTypeTitle) {
            
            leftBgView.frame = CGRectMake(0, 0, 80, frame.size.height);
            _leftLabel = [[UILabel alloc] init];
            
            _leftLabel.textColor = kBlackColor;
            
            _leftLabel.font = Font(14.0);
            
            [leftBgView addSubview:_leftLabel];
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.width.mas_lessThanOrEqualTo(80);
                make.height.mas_equalTo(frame.size.height);
                
            }];
            
        } else {
            
            leftBgView.frame = CGRectMake(0, 0, 46, frame.size.height);
            
            _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
            //        _leftIconView.contentMode = UIViewContentModeCenter;
            _leftIconView.centerY = leftBgView.height/2.0;
            _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
            //_leftIconView.backgroundColor = [UIColor orangeColor];
            [leftBgView addSubview:_leftIconView];
        }
        
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder
{
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleWidth, frame.size.height)];
        
        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleWidth - 20, frame.size.height)];
        leftLbl.text = leftTitle;
        leftLbl.textAlignment = NSTextAlignmentLeft;
        leftLbl.font = [UIFont secondFont];
        leftLbl.textColor = [UIColor colorWithHexString:@"#484848"];
        [leftBgView addSubview:leftLbl];
        self.leftView = leftBgView;
        
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:15];
        
        
    }
    return self;
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = [placeHolder copy];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_placeHolder attributes:@{
                                                                                                          NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbbbbb"]
                                                                                                          }];
    self.attributedPlaceholder = attrStr;
    
}



//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    
//    return [self newRect:bounds];
//}
//
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    
//    return [self newRect:bounds];
//}
//
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    
//    return [self newRect:bounds];
//}
//
//- (CGRect)newRect:(CGRect)oldRect {
//    
//    CGRect newRect = oldRect;
//    newRect.origin.x = newRect.origin.x + 64;
//    return newRect;
//}

#pragma mark --处理复制粘贴事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.isSecurity){
        
        return NO;
        
    } else{
        return [super canPerformAction:action withSender:sender];
    }
    //    if (action == @selector(paste:))//禁止粘贴
    //        return NO;
    //    if (action == @selector(select:))// 禁止选择
    //        return NO;
    //    if (action == @selector(selectAll:))// 禁止全选
    //        return NO;
}

@end
