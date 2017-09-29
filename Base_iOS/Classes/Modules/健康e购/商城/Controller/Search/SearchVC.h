//
//  SearchVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SearchVCType){
    
    SearchVCTypeShop = 0,       //店铺
    SearchVCTypeDefaultGoods,   //商品
    SearchVCTypeHotel,          //智慧民宿
};

@interface SearchVC : BaseViewController

@property (nonatomic,assign) SearchVCType type;

@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;

@end
