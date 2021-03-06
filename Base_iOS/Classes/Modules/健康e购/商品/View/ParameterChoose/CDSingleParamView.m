//
//  CDSingleParamView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDSingleParamView.h"



//
@implementation CDSingleParamView


- (void)unSelected {

    self.backgroundColor = [UIColor backgroundColor];
    self.contentLbl.textColor = [UIColor textColor];
    
}

- (void)selected {

    self.backgroundColor = [UIColor themeColor];
    self.contentLbl.textColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
//        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor clearColor]
                                             font:SINGLE_CONTENT_FONT
                                        textColor:[UIColor textColor]];
        [self addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;
        
        //
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY).offset(0);
//            make.right.equalTo(self.mas_right).offset(-10);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            
        }];
        
        
        //
        
    }
    return self;
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    //
//    if (self.contentLbl) {
//       
//         self.contentLbl.frame = CGRectMake(SINGLE_CONTENT_MARGIN, SINGLE_CONTENT_MARGIN, self., <#CGFloat height#>)
//    }
//   
//}

@end
