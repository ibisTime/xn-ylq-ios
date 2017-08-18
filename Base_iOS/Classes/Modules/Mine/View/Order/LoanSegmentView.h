//
//  LoanSegmentView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoanSegmentViewDelegate <NSObject>

- (BOOL)segmentSwitch:(NSInteger)idx;

@end

@interface LoanSegmentView : UIView

@property (nonatomic,copy) NSArray *tagNames;
@property (nonatomic,weak) id<LoanSegmentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

//更新tagName
- (void)reloadTagNameWithArray:(NSArray *)tagNames;

@end
