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
    
    identifierModel.img = @"身份证上传";
    
    identifierModel.authType = AuthStatusTypeCommit;
    
    [self.datas addObject:identifierModel];
    
    SectionModel *faceModel = [SectionModel new];
    
    faceModel.title = @"人脸识别";
    
    faceModel.img = @"人脸识别";
    
    faceModel.authType = AuthStatusTypeCommit;
    
    [self.datas addObject:faceModel];
    
    self.identifierView.datas = self.datas;
}

- (void)initIdentifierView {
    
    BaseWeakSelf;
    
    self.identifierView = [[IdentifierView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    
    self.identifierView.identifierBlock = ^(IdentifierType type) {
        
        if (type == IdentifierTypeIDCard) {
            
            [weakSelf commitIDCard];
            
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

- (void)commitIdentifier {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"623049";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"kCurrentAuthStatus"];
        
        [TLUser user].currentAuth = 0;

        [TLAlert alertWithSucces:@"提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Events
- (void)commitIDCard {

    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                [TLProgressHUD showWithStatus:@""];
                
                QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone2];
                    
                }]];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    //                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    //设置头像
                    
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = @"623044";
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"identifyPic"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"上传成功"];
                        [TLUser user].photo = key;
                        
                        UIImageView *imgView = [weakSelf.identifierView viewWithTag:1300];
                        
                        imgView.image = nil;
                        
                        weakSelf.identifierView.identifierIV.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
