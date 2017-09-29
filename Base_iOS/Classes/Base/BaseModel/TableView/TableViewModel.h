//
//  TableViewModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface TableViewModel : BaseModel

@property (nonatomic, assign) CGFloat headerSectionHeight;

@property (nonatomic, assign) CGFloat footerSectionHeight;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, assign) NSInteger rowNum;


@end
