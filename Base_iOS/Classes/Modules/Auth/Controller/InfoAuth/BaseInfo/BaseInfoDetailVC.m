//
//  BaseInfoDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoDetailVC.h"

#import "PickerTextField.h"
#import "AddressPickerView.h"

#import "KeyValueModel.h"

@interface BaseInfoDetailVC ()

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*edcationArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*timeArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*marriageArr;

@property (nonatomic, strong) PickerTextField *edcationTF;  //学历

@property (nonatomic, strong) PickerTextField *marriageTF;  //婚姻

@property (nonatomic, strong) TLTextField *childernNumTF;   //子女个数

@property (nonatomic, strong) TLTextField *liveProvinceTF;  //居住省市

@property (nonatomic,strong) AddressPickerView *addressPicker;  //省市区

@property (nonatomic, strong) TLTextField *addressTF;       //详细地址

@property (nonatomic, strong) PickerTextField *liveTimeTF;      //居住时长

@property (nonatomic, strong) TLTextField *qqTF;            //QQ

@property (nonatomic, strong) TLTextField *emailTF;         //email

@property (nonatomic, copy) NSString *selectEdcation;

@property (nonatomic, copy) NSString *selectLiveTime;

@property (nonatomic, copy) NSString *selectMarriage;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@end

@implementation BaseInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self requestEducation];
    
    [self requestLiveTime];
    
    [self requestMarriage];
    
}

#pragma mark - Init

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
            weakSelf.liveProvinceTF.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (void)initSubviews {
    
    BaseWeakSelf;
    
    InfoBasic *infoBasic = self.authModel.infoBasic;
    
    CGFloat titleWidth = 90;
    
    //学历
    self.edcationTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"学历" titleWidth:titleWidth placeholder:@"请选择学历"];
    
    self.edcationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.edcationArr[index];
        
        weakSelf.selectEdcation = model.dkey;
    };
    
    [self.view addSubview:self.edcationTF];
    
    //婚姻
    self.marriageTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, self.edcationTF.yy + 1, kScreenWidth, 45) leftTitle:@"婚姻" titleWidth:titleWidth placeholder:@"请选择婚姻状态"];
    
    self.marriageTF.text = infoBasic.marriage;
    
    self.marriageTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.marriageArr[index];
        
        weakSelf.selectMarriage = model.dkey;
    };
    
    [self.view addSubview:self.marriageTF];
    
    //子女个数
    self.childernNumTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.marriageTF.yy + 1, kScreenWidth, 45) leftTitle:@"子女个数" titleWidth:titleWidth placeholder:@"请输入子女数量"];
    
    
//    self.childernNumTF.text = [NSString stringWithFormat:@"%ld", infoBasic.childrenNum];
    self.childernNumTF.text = infoBasic.childrenNum;
    
    self.childernNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.childernNumTF];
    
    //居住省市
    self.liveProvinceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.childernNumTF.yy + 1, kScreenWidth, 45) leftTitle:@"居住省市" titleWidth:titleWidth placeholder:@"请输入居住省市"];
    
    self.liveProvinceTF.text = infoBasic.provinceCity;
    
    [self.view addSubview:self.liveProvinceTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.liveProvinceTF.bounds];
    
    [self.liveProvinceTF addSubview:btn];
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //常住地址
    self.addressTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.liveProvinceTF.yy + 1, kScreenWidth, 45) leftTitle:@"常住地址" titleWidth:titleWidth placeholder:@"请输入常住地址"];
    
    self.addressTF.text = infoBasic.address;
    
    [self.view addSubview:self.addressTF];
    
    //居住时长
    self.liveTimeTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, self.addressTF.yy + 1, kScreenWidth, 45) leftTitle:@"居住时长" titleWidth:titleWidth placeholder:@"请选择居住时长"];
    
    self.liveTimeTF.text = infoBasic.liveTime;
    
    self.liveTimeTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.timeArr[index];
        
        weakSelf.selectLiveTime = model.dkey;
    };
    
    [self.view addSubview:self.liveTimeTF];
    
    //QQ
    self.qqTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.liveTimeTF.yy + 1, kScreenWidth, 45) leftTitle:@"QQ" titleWidth:titleWidth placeholder:@"请输入QQ号码"];
    
    self.qqTF.text = infoBasic.qq;
    
    self.qqTF.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.qqTF];
    
    //电子邮箱
    self.emailTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.qqTF.yy + 1, kScreenWidth, 45) leftTitle:@"电子邮箱" titleWidth:titleWidth placeholder:@"请输入电子邮箱"];
    
    self.emailTF.text = infoBasic.email;
    
    [self.view addSubview:self.emailTF];

    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, self.emailTF.yy + 50, kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitBtn];
    
}

#pragma mark - Data
- (void)requestEducation {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"education";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.edcationArr = [NSMutableArray array];

        NSMutableArray *titleArr = [NSMutableArray array];

        InfoBasic *infoBasic = self.authModel.infoBasic;

        for (KeyValueModel *model in arr) {
            
            [self.edcationArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            if ([model.dkey isEqualToString:infoBasic.education]) {
                
                self.selectEdcation = model.dkey;
                
                self.edcationTF.text = model.dvalue;

            }
        }
        
        self.edcationTF.tagNames = titleArr;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestLiveTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"live_time";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.timeArr = [NSMutableArray array];

        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoBasic *infoBasic = self.authModel.infoBasic;

        for (KeyValueModel *model in arr) {
            
            [self.timeArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            if ([model.dkey isEqualToString:infoBasic.liveTime]) {
                
                self.selectLiveTime = model.dkey;
                
                self.liveTimeTF.text = model.dvalue;
            }
        }
        
        self.liveTimeTF.tagNames = titleArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestMarriage {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"marriage";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.marriageArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];

        InfoBasic *infoBasic = self.authModel.infoBasic;

        for (KeyValueModel *model in arr) {
            
            [self.marriageArr addObject:model];
            
            [titleArr addObject:model.dvalue];

            if ([model.dkey isEqualToString:infoBasic.marriage]) {
                
                self.selectMarriage = model.dkey;
                
                self.marriageTF.text = model.dvalue;
            }
        }
        
        self.marriageTF.tagNames = titleArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickCommit {
    
    if (![self.edcationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择学历"];
        return;
    };
    
    if (![self.marriageTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择婚姻状态"];
        
        return;
    }
    
    if (![self.childernNumTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入子女数量"];

        return;
    }
    
    if (![self.liveProvinceTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入居住省市"];
        
        return;
    }
    
    if (![self.addressTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入常住地址"];
        
        return;
    }
    
    if (![self.liveTimeTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入居住时长"];
        
        return;
    }
    
    if (![self.qqTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入QQ号码"];
        
        return;
    }
    
    if (![self.emailTF.text isValidateEmail]) {
        
        [TLAlert alertWithInfo:@"请输入正确邮箱格式"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623040";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"address"] = self.addressTF.text;
    http.parameters[@"childrenNum"] = self.childernNumTF.text;
    http.parameters[@"education"] = self.selectEdcation;
    http.parameters[@"email"] = self.emailTF.text;
    http.parameters[@"liveTime"] = self.selectLiveTime;
    http.parameters[@"marriage"] = self.selectMarriage;
    http.parameters[@"provinceCity"] = self.liveProvinceTF.text;
    http.parameters[@"qq"] = self.qqTF.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)chooseAddress {

    [self.view endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
