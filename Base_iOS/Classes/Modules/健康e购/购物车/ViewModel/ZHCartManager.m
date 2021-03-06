//
//  ZHCartManager.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCartManager.h"
#import "ZHCartGoodsModel.h"

 NSString *const kShoopingCartCountChangeNotification = @"zh_kShoopingCartCountChangeNotification";

@implementation ZHCartManager
{
    NSNumber *_postage;

}
+ (instancetype)manager {

    static ZHCartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ZHCartManager alloc] init];
        
        //此处有崩溃历史，由于在set方法中会post notification,,这时还没有完成该对象初始化--会出现严重后果
//        manager.count = 0;
        
    });

    return manager;
}


- (void)setCount:(NSInteger)count {

    if (count < 0) {
        _count = 0;
    } else {
    
         _count = count;
    }
   

    [[NSNotificationCenter defaultCenter] postNotificationName:kShoopingCartCountChangeNotification object:nil];
    
}

- (void)reset {

    self.count = 0;

}

- (void)getCartCount {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = @"808047";
    
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            NSArray *arr = responseObject[@"data"];
            
            NSArray <ZHCartGoodsModel *> *goods = [ZHCartGoodsModel mj_objectArrayWithKeyValuesArray:arr];
            
           __block NSInteger totalCount = 0;
            [goods enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                totalCount  = totalCount + obj.quantity;
            }];
            
            self.count = totalCount;
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }

}

+ (void)getPostage:(void(^)(NSNumber *))success failure:(void(^)())failure {

    //
    //获取邮费
    TLNetworking *http = [TLNetworking new];
    http.showView = [UIApplication sharedApplication].keyWindow;
    http.code = @"808917";
    http.parameters[@"key"] = @"SP_YUNFEI";
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            NSString *postageStr = responseObject[@"data"][@"cvalue"];
            success(@([postageStr intValue]*1000));
        }
        
    } failure:^(NSError *error) {
        
        
    }];


}


@end
