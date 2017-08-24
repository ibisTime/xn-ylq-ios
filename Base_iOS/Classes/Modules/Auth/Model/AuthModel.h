//
//  AuthModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class InfoBasic, InfoOccupation, InfoContact, InfoBankcard, InfoIdentifyPic, InfoIdentify, InfoIdentifyFace;

@interface AuthModel : BaseModel

@property (nonatomic, copy) NSString *infoOccupationFlag;   //职业信息

@property (nonatomic, copy) NSString *infoContactFlag;      //联系人

@property (nonatomic, copy) NSString *infoBankcardFlag;     //银行卡

@property (nonatomic, copy) NSString *infoBasicFlag;        //基本信息

@property (nonatomic, copy) NSString *infoIdentifyPicFlag;  //身份认证

@property (nonatomic, copy) NSString *infoIdentifyFaceFlag; //人脸识别


@property (nonatomic, copy) NSString *infoIdentifyFlag;     //身份认证标识

@property (nonatomic, copy) NSString *infoAntifraudFlag;    //	基本信息全部提交标识
@property (nonatomic, copy) NSString *infoZMCreditFlag;     //芝麻分

@property (nonatomic, copy) NSString *infoCarrierFlag;      //运营商

@property (nonatomic, copy) NSString *infoAddressBookFlag;  //通讯录

@property (nonatomic, strong) InfoBasic *infoBasic;

@property (nonatomic, strong) InfoOccupation *infoOccupation;

@property (nonatomic, strong) InfoContact *infoContact;

@property (nonatomic, strong) InfoBankcard *infoBankcard;

@property (nonatomic, strong) InfoIdentifyPic *infoIdentifyPic;

@property (nonatomic, strong) InfoIdentify *infoIdentify;

@property (nonatomic, strong) InfoIdentifyFace *infoIdentifyFace;


@end

@interface InfoBasic : NSObject

@property (nonatomic, copy) NSString *marriage;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *liveTime;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *childrenNum;

@property (nonatomic, copy) NSString *provinceCity;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *email;

@end

@interface InfoOccupation : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *income;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *provinceCity;

@end

@interface InfoContact : NSObject

@property (nonatomic, copy) NSString *familyRelation;

@property (nonatomic, copy) NSString *familyMobile;

@property (nonatomic, copy) NSString *societyRelation;

@property (nonatomic, copy) NSString *societyMobile;

@end

@interface InfoBankcard : NSObject

@property (nonatomic, copy) NSString *bank;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *privinceCity;

@end

@interface InfoIdentifyPic : NSObject

@property (nonatomic, copy) NSString *identifyPic;

@end

@interface InfoIdentify : NSObject

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *realName;

@end

@interface InfoIdentifyFace : NSObject

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *realName;

@end
