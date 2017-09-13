//
//  IdentifierVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdentifierVC.h"

#import "IdentifierView.h"
#import "TLImagePicker.h"

#import "ZMAuthVC.h"
#import "IdentifierAuthVC.h"

#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"
#import "AuthModel.h"

@interface IdentifierVC ()

@property (nonatomic, strong) IdentifierView *identifierView;

@property (nonatomic, strong) NSMutableArray <SectionModel *>*datas;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, strong) AuthModel *authModel;

@end

@implementation IdentifierVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initModel];
    
    [self requestAuthStatus];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    
    [self initIdentifierView];
}

#pragma mark - Init

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

- (void)initModel {
    
    self.datas = [NSMutableArray array];
    
    SectionModel *identifierModel = [SectionModel new];
    
    identifierModel.title = @"身份证上传";
    
    identifierModel.flag = @"0";

    identifierModel.type = DataTypeSCSFZ;
    
    identifierModel.authStatusType = @"0";

    [self.datas addObject:identifierModel];
    
    SectionModel *faceModel = [SectionModel new];
    
    faceModel.title = @"人脸识别";
    
    faceModel.flag = @"0";

    faceModel.type = DataTypeRLSB;
    
    faceModel.authStatusType = @"0";
    
    [self.datas addObject:faceModel];
    
    self.identifierView.datas = self.datas;
}

- (void)initIdentifierView {
    
    BaseWeakSelf;
    
    self.identifierView = [[IdentifierView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    self.identifierView.identifierBlock = ^(IdentifierType type) {
        
        if (type == IdentifierTypeIDCard) {
            
            IdentifierAuthVC *authVC = [IdentifierAuthVC new];
                        
            [weakSelf.navigationController pushViewController:authVC animated:YES];
            
        } else if (type == IdentifierTypeFaceRecognition) {
            
            ZMAuthVC *authVC = [ZMAuthVC new];
            
            authVC.title = @"芝麻认证";
            
            authVC.authModel = weakSelf.authModel;
            
            [weakSelf.navigationController pushViewController:authVC animated:YES];
            
        } else if (type == IdentifierTypeCommit) {
        
            [weakSelf commitIdentifier];
            
        }
        
    };
    
    [self.view addSubview:self.identifierView];
    
}

#pragma mark - Data
- (void)requestAuthStatus {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"623050";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.authModel = [AuthModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.identifierView.authModel = self.authModel;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events

- (void)commitIdentifier {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623049";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kCurrentAuthStatus"];
        
        [TLUser user].currentAuth = 0;
        
//        [TLAlert alertWithSucces:@"提交成功"];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        });
        
        [TLAlert alertWithTitle:@"" message:@"身份认证成功" confirmMsg:@"OK" confirmAction:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }];
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
