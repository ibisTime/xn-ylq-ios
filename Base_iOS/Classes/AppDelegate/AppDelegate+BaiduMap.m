//
//  AppDelegate+BaiduMap.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AppDelegate+BaiduMap.h"

@implementation AppDelegate (BaiduMap)

- (void)configMapKit {
    
    self.locationManage = [[CLLocationManager alloc] init];
    self.locationManage.distanceFilter = 10;
    self.locationManage.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManage.delegate = self;
    
    // 请求定位授权
    [self.locationManage requestWhenInUseAuthorization];
    
    //启动LocationService
    if (![CLLocationManager locationServicesEnabled]) {
        
        [TLAlert alertWithTitle:@"提示" msg:@"定位失败，请前往“设置->九州宝->位置“中开启定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [TLAuthHelper openSetting];
        }];
        
    }else {
        
        [self.locationManage startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = locations.lastObject;
    self.myCoordinate = currentLocation.coordinate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationPlaceNotification object:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败: %@", error);
}

@end
