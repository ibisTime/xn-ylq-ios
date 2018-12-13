//
//  IDCardVC.m
//  Base_iOS
//
//  Created by shaojianfei on 2018/11/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IDCardVC.h"
#import "TLTextField.h"
#import "IdentifierAuthView.h"
#import "TLImagePicker.h"
#import <QNUploadManager.h>
#import <QNConfiguration.h>
#import "TLUploadManager.h"
#import "ZQFaceAuthEngine.h"
#import "ZQOCRScanEngine.h"
@interface IDCardVC ()<ZQFaceAuthDelegate,ZQOcrScanDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
}
@property (nonatomic ,strong) TLTextField *realName;

@property (nonatomic ,strong) TLTextField *cardNo;

@property (nonatomic, strong) IdentifierAuthView *identifierView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) TLImagePicker *imagePicker;
@property (nonatomic, assign) IdentifierAuthType type;          //照片类型

@property (nonatomic, copy) NSString *positivePic;              //正面照

@property (nonatomic, copy) NSString *otherSidePic;             //反面照

@property (nonatomic, copy) NSString *handheldPic;              //手持照
@end

@implementation IDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self postRequest];
//    self.view.backgroundColor = kWhiteColor;
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"开始检测" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:22];
    self.confirmBtn = confirmBtn;
    [confirmBtn addTarget:self action:@selector(idCardAuth) forControlEvents:UIControlEventTouchUpInside];
//    [self initSubViews];
//    [self initIdentifierView];
}
- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.imageType = ImageTypeCamera;
        
        _imagePicker.allowsEditing = NO;
        
    }
    return _imagePicker;
}

- (void)postRequest
{
    ZQOCRScanEngine *engine = [[ZQOCRScanEngine alloc] init];
    engine.delegate = self;
    engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
    engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
    [engine startOcrScanIdCardInViewController:self];
    
}
#pragma mark - ZQFaceAuthDelegate

- (void)faceAuthFinishedWithResult:(ZQFaceAuthResult)result UserInfo:(id)userInfo{
    
    NSLog(@"OC authFinish");
    UIImage * livingPhoto = [userInfo objectForKey:@"livingPhoto"];
    
    if(result  == ZQFaceAuthResult_Done && livingPhoto !=nil){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜您，已完成活体检测！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        //        [alertView show];
        TLUploadManager *manager = [TLUploadManager manager];
        NSData *imgData = UIImageJPEGRepresentation(livingPhoto, 0.6);
        manager.imgData = imgData;
        manager.image = livingPhoto;
        [manager getTokenAuthShowView:self.view succes:^(NSString *key) {
            
            str3 = key;
            
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"623044";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"frontImage"] = str1;
            http.parameters[@"backImage"] = str2;
            http.parameters[@"faceImage"] = str3;
                    //            QUERY
            [http postWithSuccess:^(id responseObject) {
                
                [TLUser user].realName = self.realName.text;
                [[TLUser user] updateUserInfo];
                [TLAlert alertWithSucces:@"身份证提交成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error) {
                [self.navigationController popViewControllerAnimated:YES];

            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)faceAuthFinishedWithResult:(NSInteger)result userInfo:(id)userInfo{
    
    NSLog(@"Swift authFinish");
}

- (void)idCardOcrScanFinishedWithResult:(ZQFaceAuthResult)result userInfo:(id)userInfo{
    NSLog(@"OC OCR Finish");
    
    UIImage *frontcard = [userInfo objectForKey:@"frontcard"];
    UIImage *portrait = [userInfo objectForKey:@"portrait"];
    UIImage *backcard = [userInfo objectForKey:@"backcard"];
    if(result  == ZQFaceAuthResult_Done && frontcard != nil && portrait != nil && backcard !=nil){
        
        
        NSData *imgData = UIImageJPEGRepresentation(frontcard, 0.6);
        NSData *imgData1 = UIImageJPEGRepresentation(backcard, 0.6);
        //进行上传
        TLUploadManager *manager = [TLUploadManager manager];
        
        manager.imgData = imgData;
        manager.image = frontcard;
        [manager getTokenAuthShowView:self.view succes:^(NSString *key) {
            
            str1 = key;
            TLUploadManager *manager1 = [TLUploadManager manager];
            
            manager1.imgData = imgData1;
            manager1.image = backcard;
            [manager1 getTokenAuthShowView:self.view succes:^(NSString *key) {
                
                str2 = key;
                ZQFaceAuthEngine * engine = [[ZQFaceAuthEngine alloc]init];
                engine.delegate = self;
                engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
                engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
                [engine startFaceAuthInViewController:self];
                
            } failure:^(NSError *error) {
                
            }];
        } failure:^(NSError *error) {
            
        }];
    }
    
}





- (void)initSubViews {
    
    TLTextField *realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 45) leftTitle:@"真实姓名" titleWidth:100 placeholder:@"请输入真实姓名"];
    [self.view addSubview:realName];
    self.realName = realName;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, realName.yy + 1, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor zh_lineColor];
    [self.view addSubview:line];
    
    TLTextField *cardNo = [[TLTextField alloc] initWithFrame:CGRectMake(0, line.yy, kScreenWidth, 45) leftTitle:@"身份证" titleWidth:100 placeholder:@"请输入身份证号"];
    [self.view addSubview:cardNo];
    self.cardNo = cardNo;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, cardNo.yy + 1, kScreenWidth, 10)];
    line1.backgroundColor = [UIColor zh_lineColor];
    [self.view addSubview:line1];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:22];
    self.confirmBtn = confirmBtn;
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self.view addSubview:confirmBtn];
    //    confirmBtn.frame = CGRectMake(30, cardNo.yy+50, kScreenWidth-60, 45);
}

- (void)initIdentifierView {
    
    BaseWeakSelf;
    
    self.identifierView = [[IdentifierAuthView alloc] initWithFrame:CGRectMake(0, self.cardNo.yy+20, kScreenWidth, kSuperViewHeight)];
    
    self.identifierView.identifierBlock = ^(IdentifierAuthType type) {
        
        if (type == IdentifierAuthTypeCommit) {
            
            //            [weakSelf commitIdentifier];
            [weakSelf idCardAuth];
            
        }else {
            
            weakSelf.type = type;
            
            [weakSelf commitIDCard];
            
        }
        
    };
    
    [self.view addSubview:self.identifierView];
    
}
- (void)idCardAuth
{
    
    //    if (![self.positivePic valid]) {
    //
    //        [TLAlert alertWithInfo:@"请上传身份证正面照"];
    //        return ;
    //    }
    //
    //    if (![self.otherSidePic valid]) {
    //
    //        [TLAlert alertWithInfo:@"请上传身份证反面照"];
    //        return ;
    //    }
    //
    //    if (![self.handheldPic valid]) {
    //
    //        [TLAlert alertWithInfo:@"请上传手持身份证照"];
    //        return ;
    //    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623044";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"identifyPic"] = @"111";
    http.parameters[@"identifyPicReverse"] = @"22";
    http.parameters[@"identifyPicHand"] = @"22";
    http.parameters[@"realName"] = self.realName.text;
    http.parameters[@"idNo"] = self.cardNo.text;
    
    //    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        [TLUser user].realName = self.realName.text;
        [[TLUser user] updateUserInfo];
        [TLAlert alertWithSucces:@"身份证照片提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)commitIDCard {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone2];
                    
                }]];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                //                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    //                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    //设置头像
                    UIImageView *imgView = [weakSelf.identifierView viewWithTag:1400 + self.type];
                    
                    imgView.frame = CGRectMake(0, 0, kWidth(140), kWidth(140));
                    
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    
                    imgView.image = image;
                    
                    [TLProgressHUD dismiss];
                    
                    switch (weakSelf.type) {
                        case IdentifierAuthTypeIDCardPositive:
                        {
                            weakSelf.positivePic = key;
                            
                        }break;
                            
                        case IdentifierAuthTypeIDCardOtherSide:
                        {
                            weakSelf.otherSidePic = key;
                            
                        }break;
                            
                        case IdentifierAuthTypeIDCardHandheld:
                        {
                            weakSelf.handheldPic = key;
                            
                        }break;
                            
                        default:
                            break;
                    }
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}


@end
