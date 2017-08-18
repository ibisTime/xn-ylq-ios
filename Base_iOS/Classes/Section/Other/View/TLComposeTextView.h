//
//  TLComposeTextView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPOSE_ORG_HEIGHT 40

@interface TLComposeTextView : UITextView

@property (nonatomic,strong) UILabel *placeholderLbl;

@property (nonatomic, copy) NSMutableString *copyText;

@property (nonatomic, copy) NSString *placholder;

@end
