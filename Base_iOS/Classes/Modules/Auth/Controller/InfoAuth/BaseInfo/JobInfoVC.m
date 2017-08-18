//
//  JobInfoVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "JobInfoVC.h"

#import "PickerTextField.h"
#import "AddressPickerView.h"

#import "KeyValueModel.h"

@interface JobInfoVC ()

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*jobArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*incomeArr;

@property (nonatomic, strong) PickerTextField *jobTF;  //职业

@property (nonatomic, strong) PickerTextField *incomeTF;  //月收入

@property (nonatomic, strong) TLTextField *companyNameTF;   //子女个数

@property (nonatomic, strong) TLTextField *provinceTF;  //所在省市

@property (nonatomic,strong) AddressPickerView *addressPicker;  //省市区
@property (nonatomic, strong) TLTextField *addressTF;       //详细地址

@property (nonatomic, strong) TLTextField *mobileTF;      //居住时长

@property (nonatomic, copy) NSString *selectJob;

@property (nonatomic, copy) NSString *selectIncome;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@end

@implementation JobInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self requestJob];
    
    [self requestIncome];
    
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
            
            weakSelf.provinceTF.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (void)initSubviews {
    
    BaseWeakSelf;
    
    InfoOccupation *infoOccupation = self.authModel.infoOccupation;
    
    CGFloat titleWidth = 90;
    
    //职业
    self.jobTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"职业" titleWidth:titleWidth placeholder:@"请选择职业"];
    
    self.jobTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.jobArr[index];
        
        weakSelf.selectJob = model.dkey;
    };
    
    [self.view addSubview:self.jobTF];
    
    //月收入
    self.incomeTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, self.jobTF.yy + 1, kScreenWidth, 45) leftTitle:@"月收入" titleWidth:titleWidth placeholder:@"请选择月收入"];
    
    self.incomeTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.incomeArr[index];
        
        weakSelf.selectIncome = model.dkey;
    };
    
    [self.view addSubview:self.incomeTF];
    
    //单位名称
    self.companyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.incomeTF.yy + 1, kScreenWidth, 45) leftTitle:@"单位名称" titleWidth:titleWidth placeholder:@"请输入单位名称"];
    
    self.companyNameTF.text = infoOccupation.company;
    
    [self.view addSubview:self.companyNameTF];
    
    //所在省市
    self.provinceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.companyNameTF.yy + 1, kScreenWidth, 45) leftTitle:@"所在省市" titleWidth:titleWidth placeholder:@"请选择单位所在省市"];
    
    self.provinceTF.text = infoOccupation.provinceCity;
    
    [self.view addSubview:self.provinceTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.provinceTF.bounds];
    
    [self.provinceTF addSubview:btn];
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //常住地址
    self.addressTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.provinceTF.yy + 1, kScreenWidth, 45) leftTitle:@"详细地址" titleWidth:titleWidth placeholder:@"请输入详细地址"];
    
    self.addressTF.text = infoOccupation.address;
    
    [self.view addSubview:self.addressTF];
    
    //单位电话
    
    self.mobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.addressTF.yy + 1, kScreenWidth, 45) leftTitle:@"单位电话" titleWidth:titleWidth placeholder:@"区号+号码"];
    
    self.mobileTF.text = infoOccupation.phone;
    
    [self.view addSubview:self.mobileTF];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, self.mobileTF.yy + 50, kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitBtn];
    
}

#pragma mark - Data
- (void)requestJob {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"occupation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.jobArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoOccupation *infoOccupation = self.authModel.infoOccupation;
        
        for (KeyValueModel *model in arr) {
            
            [self.jobArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            if ([model.dkey isEqualToString:infoOccupation.occupation]) {
                
                self.selectJob = model.dkey;
                
                self.jobTF.text = model.dvalue;
                
            }
        }
        
        self.jobTF.tagNames = titleArr;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestIncome {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"income";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.incomeArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoOccupation *infoOccupation = self.authModel.infoOccupation;
        
        for (KeyValueModel *model in arr) {
            
            [self.incomeArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            if ([model.dkey isEqualToString:infoOccupation.income]) {
                
                self.selectIncome = model.dkey;
                
                self.incomeTF.text = model.dvalue;
                
            }
        }
        
        self.incomeTF.tagNames = titleArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickCommit {
    
    if (![self.jobTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择职业"];
        return;
    };
    
    if (![self.incomeTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择月收入"];
        
        return;
    }
    
    if (![self.companyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入单位名称"];
        
        return;
    }
    
    if (![self.provinceTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择单位所在省市"];
        
        return;
    }
    
    if (![self.addressTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入详细地址"];
        
        return;
    }
    
    if (![self.mobileTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入单位电话号码"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623041";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"address"] = self.addressTF.text;
    http.parameters[@"company"] = self.companyNameTF.text;
    http.parameters[@"income"] = self.selectIncome;
    http.parameters[@"occupation"] = self.selectJob;
    http.parameters[@"phone"] = self.mobileTF.text;
    http.parameters[@"provinceCity"] = self.provinceTF.text;
    
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
