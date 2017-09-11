//
//  EmergencyContactVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EmergencyContactVC.h"

#import "PickerTextField.h"

#import "KeyValueModel.h"

@interface EmergencyContactVC ()

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*familyArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*societyArr;

@property (nonatomic, strong) PickerTextField *familyRelationTF;        //亲属关系

@property (nonatomic, strong) TLTextField *familyNameTF;                //亲属姓名

@property (nonatomic, strong) TLTextField *familyMobileTF;              //亲属联系方式

@property (nonatomic, strong) PickerTextField *societyRelationTF;       //社会关系

@property (nonatomic, strong) TLTextField *societyNameTF;               //社会联系人姓名
@property (nonatomic, strong) TLTextField *societyMobileTF;             //社会联系方式

@property (nonatomic, copy) NSString *selectFamily;

@property (nonatomic, copy) NSString *selectSociety;

@end

@implementation EmergencyContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self requestFamilyRelation];
    
    [self requestSocietyRelation];

}

#pragma mark - Init
- (void)initSubviews {
    
    BaseWeakSelf;
    
    InfoContact *infoContact = self.authModel.infoContact;
    
    CGFloat titleWidth = 90;
    
    //亲属关系
    self.familyRelationTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"亲属关系" titleWidth:titleWidth placeholder:@"请选择亲属关系"];
    
    self.familyRelationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.familyArr[index];
        
        weakSelf.selectFamily = model.dkey;
    };
    
    [self.view addSubview:self.familyRelationTF];
    
    //亲属姓名
    self.familyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.familyRelationTF.yy + 1, kScreenWidth, 45) leftTitle:@"姓名" titleWidth:titleWidth placeholder:@"请输入亲属姓名"];
    
    self.familyNameTF.text = infoContact.familyName;
    
    [self.view addSubview:self.familyNameTF];
    
    //亲属联系方式
    self.familyMobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.familyNameTF.yy + 1, kScreenWidth, 45) leftTitle:@"联系方式" titleWidth:titleWidth placeholder:@"请输入亲属手机号"];
    
    self.familyMobileTF.text = infoContact.familyMobile;
    
    self.familyMobileTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.familyMobileTF];
    
    
    
    //社会关系
    
    self.societyRelationTF = [[PickerTextField alloc] initWithFrame:CGRectMake(0, self.familyMobileTF.yy + 11, kScreenWidth, 45) leftTitle:@"社会关系" titleWidth:titleWidth placeholder:@"请选择社会关系"];
    
    self.societyRelationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.societyArr[index];
        
        weakSelf.selectSociety = model.dkey;
    };
    
    [self.view addSubview:self.societyRelationTF];
    
    //社会联系人姓名
    self.societyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.societyRelationTF.yy + 1, kScreenWidth, 45) leftTitle:@"姓名" titleWidth:titleWidth placeholder:@"请输入社会联系人姓名"];
    
    self.societyNameTF.text = infoContact.societyName;
    
    [self.view addSubview:self.societyNameTF];
    
    //社会联系方式
    self.societyMobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.societyNameTF.yy + 1, kScreenWidth, 45) leftTitle:@"联系方式" titleWidth:titleWidth placeholder:@"请输入社会联系人手机号"];
    
    self.societyMobileTF.text = infoContact.societyMobile;
    
    self.societyMobileTF.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.societyMobileTF];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIColor *bgColor = [_authModel.infoAntifraudFlag isEqualToString:@"1"] ? kGreyButtonColor: kAppCustomMainColor;

    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:bgColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, self.societyMobileTF.yy + 50, kScreenWidth - 2*leftMargin, btnH);
    
    commitBtn.enabled = [_authModel.infoAntifraudFlag isEqualToString:@"1"] ? NO: YES;

    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitBtn];
}

#pragma mark - Data
- (void)requestFamilyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"family_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.familyArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoContact *infoContact = self.authModel.infoContact;
        
        for (KeyValueModel *model in arr) {
            
            [self.familyArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            //key/Value转换
            if ([model.dkey isEqualToString:infoContact.familyRelation]) {
                
                self.selectFamily = model.dkey;
                
                self.familyRelationTF.text = model.dvalue;
                
            }
        }
        
        self.familyRelationTF.tagNames = titleArr;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestSocietyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623907";
    
    http.parameters[@"parentKey"] = @"society_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.societyArr = [NSMutableArray array];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        InfoContact *infoContact = self.authModel.infoContact;
        
        for (KeyValueModel *model in arr) {
            
            [self.societyArr addObject:model];
            
            [titleArr addObject:model.dvalue];
            
            //key/Value转换
            if ([model.dkey isEqualToString:infoContact.societyRelation]) {
                
                self.selectSociety = model.dkey;
                
                self.societyRelationTF.text = model.dvalue;
                
            }
        }
        
        self.societyRelationTF.tagNames = titleArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickCommit {
    
    if (![self.familyRelationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择亲属关系"];
        return;
    };
    
    if (![self.familyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入亲属姓名"];
        return;
    }
    
    if (![self.familyMobileTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入亲属联系人手机号"];
        return;
    }
    
    if (self.familyMobileTF.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号"];
        
        return;
    }
    
    if (![self.societyRelationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择社会关系"];
        return;
    }
    
    if (![self.societyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入社会联系人姓名"];
        return;
    }
    
    if (![self.societyMobileTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入社会联系人手机号"];
        return;
    }
    
    if (self.societyMobileTF.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"623042";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"familyRelation"] = self.selectFamily;
    http.parameters[@"familyName"] = self.familyNameTF.text;
    http.parameters[@"familyMobile"] = self.familyMobileTF.text;
    
    http.parameters[@"societyRelation"] = self.selectSociety;
    http.parameters[@"societyName"] = self.societyNameTF.text;
    http.parameters[@"societyMobile"] = self.societyMobileTF.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
