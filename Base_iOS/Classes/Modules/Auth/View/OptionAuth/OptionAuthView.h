//
//  OptionAuthView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface OptionAuthView : UIView

@property (nonatomic, strong) SectionModel *section;

@property (nonatomic, assign) CGFloat imgW;

@property (nonatomic, assign) CGFloat imgH;

@property (nonatomic, strong) UILabel *textLabel;

@end
