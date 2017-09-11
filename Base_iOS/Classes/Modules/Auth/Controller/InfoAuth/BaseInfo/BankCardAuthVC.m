//
//  BankCardAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BankCardAuthVC.h"

#import "BankCardAuthResultVC.h"
#import "LoanVC.h"

#import "AddressPickerView.h"
#import "PickerTextField.h"

#import "KeyValueModel.h"

@interface BankCardAuthVC ()

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*bankArr;

@property (nonatomic, copy) NSString *selectBank;

@property (nonatomic, strong) PickerTextField *bankName;    //开户行

@property (nonatomic, strong) TLTextField *address;      //开户省市

@property (nonatomic, strong) TLTextField *bankCard;    //银行卡

@property (nonatomic, strong) TLTextField *mobile;      //预留手机号

@property (nonatomic,strong) AddressPickerView *addressPicker;  //省市区

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@end

@implementation BankCardAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];

    [self requestBankName];
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
            
            weakSelf.address.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (void)initSubviews {
    
    BaseWeakSelf;
    
    InfoBankcard *bankCard = self.authModel.infoBankcard;
    
    CGFloat leftMargin = 15;
    
    self.bankName = [[PickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"开户行" titleWidth:105 placeholder:@"请选择开户行"];
    
    self.bankName.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.bankArr[index];
        
        weakSelf.selectBank = model.dkey;
    };
    
    [self.view addSubview:self.bankName];
    
    self.address = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.bankName.yy + 1, kScreenWidth, 50) leftTitle:@"开户省市" titleWidth:105 placeholder:@"请选择开户省市"];
    
    self.address.text = bankCard.privinceCity;
    
    [self.view addSubview:self.address];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.address.bounds];
    
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];

    [self.address addSubview:btn];
    
    self.mobile = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.address.yy + 1, kScreenWidth, 50) leftTitle:@"预留手机号" titleWidth:105 placeholder:@"请输入银行预留手机号"];
    
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    
    self.mobile.text = bankCard.mobile;
    
    [self.view addSubview:self.mobile];
    
    self.bankCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.mobile.yy + 1, kScreenWidth, 50) leftTitle:@"银行卡号" titleWidth:105 placeholder:@"请输入银行卡号"];
    
    self.bankCard.keyboardType = UIKeyboardTypeNumberPad;

    self.bankCard.text = bankCard.cardNo;
    
    [self.view addSubview:self.bankCard];
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:kTextColor3 textFont:11.0];
    
    promptLbl.frame = CGRectMake(0, self.bankCard.yy + 15, kScreenWidth, 16);
    
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    NSAttributedString *promptAttrStr = [NSAttributedString getAttributedStringWithImgStr:@"禁止学生贷款" index:0 string:[NSString stringWithFormat:@" %@", @"必须使用本人名下借记卡, 暂不支持信用卡"] labelHeight:promptLbl.height];
    
    promptLbl.attributedText = promptAttrStr;
    
    [self.view addSubview:promptLbl];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"绑定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:45/2.0];
    
    confirmBtn.frame = CGRectMake(leftMargin, promptLbl.yy + 32, kScreenWidth - 2*leftMargin, 45);
    
    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
}

#pragma mark - Data
- (void)requestBankName {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"bank";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.bankArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoBankcard *infoBankcard = self.authModel.infoBankcard;
        
        for (KeyValueModel *model in arr) {
            
            [self.bankArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            if ([model.dkey isEqualToString:infoBankcard.bank]) {
                
                self.selectBank = model.dkey;
                
                self.bankName.text = model.dvalue;
            }
        }
        
        self.bankName.tagNames = titleArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)confirmIDCard:(UIButton *)sender {
    
    if (![self.bankName.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择开户行"];
        return;
    }
    
    if (![self.address.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择开户省市"];
        return;
    }
    
    if (![self.bankCard.text valid]) {
        [TLAlert alertWithInfo:@"请输入银行卡号"];
        return;
    }
    
    if (![self.bankCard.text isBankCardNo]) {
        
        [TLAlert alertWithInfo:@"请输入正确格式的银行卡号"];
        return;
    }
    
    if (self.mobile.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号"];
        
        return;
    }
    
    if (!(self.province && self.city && self.area)) {
        
        [TLAlert alertWithInfo:@"请选择省市区"];
        return;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.isShowMsg = NO;

    http.code = @"623043";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"bank"] = self.selectBank;
    http.parameters[@"cardNo"] = self.bankCard.text;
    http.parameters[@"mobile"] = self.mobile.text;
    http.parameters[@"privinceCity"] = self.address.text;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"绑定成功"];
        
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

- (void)next:(UITextField *)sender {
    
    [self.address becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
