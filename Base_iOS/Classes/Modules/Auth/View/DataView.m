//
//  DataView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "DataView.h"
#import "BaseAuthView.h"
#import "OptionAuthView.h"

#import "NSAttributedString+add.h"

@interface DataView ()

@property (nonatomic, strong) NSMutableArray <DataModel *>*datas;

@property (nonatomic, strong) NSMutableArray *viewArr;

@end

@implementation DataView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kPaleGreyColor;
        
        self.datas = [NSMutableArray array];
        
        self.viewArr = [NSMutableArray array];
        
        [self initData];
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initData {

    NSArray *topTitleArr = @[@"信息认证", @"可选认证"];
    
    NSArray *contentArr = @[@[@"身份认证", @"个人信息", @"芝麻分", @"运营商认证"], @[@"通讯录认证", @"微信认证", @""]];
    
    NSArray *unAuthImgArr = @[@[@"身份认证未认证", @"个人信息未认证", @"芝麻分未认证", @"运营商认证未认证"], @[@"通讯录未认证", @"微信未认证", @""]];
    
    NSArray *typeArr = @[@[@(DataTypeSFRZ), @(DataTypeBaseInfo), @(DataTypeZMF), @(DataTypeYYSRZ)], @[@(DataTypeTXLRZ), @(DataTypeWXRZ), @(DataTypeWXRZ)]];
    
    for (int i = 0; i < topTitleArr.count; i++) {
        
        DataModel *dataModel = [DataModel new];
        
        dataModel.topTitle = topTitleArr[i];
        
        dataModel.contentArr = contentArr[i];
        
        dataModel.imgArr = unAuthImgArr[i];
        
        dataModel.typeArr = typeArr[i];
        
        dataModel.row = dataModel.contentArr.count;
        
        dataModel.num = i == 0 ? 2: 3;
        
        dataModel.topH = i == 0 ? 0: kHeight(45);
        
        dataModel.sectionW = kScreenWidth/(dataModel.num*1.0);
        
        dataModel.sectionH = i == 0 ? kHeight(275/2.0): kHeight(107);
        
        dataModel.lineW = 1;
        
        dataModel.lineH = 1;
        
        NSMutableArray *sections = [NSMutableArray array];
        //导入图片和文字
        for (int i = 0; i < dataModel.contentArr.count; i++) {
            
            SectionModel *section = [SectionModel new];
            
            section.title = dataModel.contentArr[i];
            
            section.img = dataModel.imgArr[i];
            
            section.type = [dataModel.typeArr[i] integerValue];
            
            section.authType = AuthStatusTypeAuthentication;
            
            [sections addObject:section];
            
        }
        
        dataModel.sections = sections;
        
        [self.datas addObject:dataModel];

    }
    
}

- (void)initSubviews {
    
    CGFloat sectionH = 0;

    for (int j = 0; j < self.datas.count; j++) {
        
        DataModel *data = self.datas[j];
        
        CGFloat leftMargin = kScreenWidth - data.sectionW*data.num;
        
        CGFloat viewH = data.topH + data.row/2*(data.sectionH + data.lineH);

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 10*j+ sectionH, kScreenWidth - 2*leftMargin, viewH)];
        
        if (j > 0) {
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, kScreenWidth - 2*leftMargin, data.topH)];
            
            topView.backgroundColor = kWhiteColor;
            
            [bgView addSubview:topView];
            
            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(kWidth(15), (data.topH - 18)/2.0, 3, 18)];
            
            leftLine.backgroundColor = kAppCustomMainColor;
            
            [topView addSubview:leftLine];
            
            UILabel *textLabel = [UILabel labelWithText:data.topTitle textColor:kTextColor textFont:kWidth(14.0)];
            
            [topView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(leftLine.mas_right).mas_equalTo(6);
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(16);
                
            }];
        }
        
        for (int i = 0; i < data.sections.count; i++) {
            
            NSInteger num = data.num;
            
            CGFloat viewW = data.sectionW;
            
            CGFloat viewH = data.sectionH;
            
            CGFloat lineW = data.lineW;
            
            CGFloat lineH = data.lineH;
            
            if (j == 0) {
                
                BaseAuthView *baseAuthView = [[BaseAuthView alloc] initWithFrame:CGRectMake(i%num*(viewW + lineW), i/num*(viewH + lineH) + data.topH, viewW, viewH)];
                
                baseAuthView.tag = 2000 + 100*j + i;
                
                baseAuthView.backgroundColor = kWhiteColor;
                
                baseAuthView.section = data.sections[i];
                
                [bgView addSubview:baseAuthView];
                
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTestType:)];
                
                [baseAuthView addGestureRecognizer:tapGR];
                
                [self.viewArr addObject:baseAuthView];

            } else if (j == 1) {
            
                OptionAuthView *optionAuthView = [[OptionAuthView alloc] initWithFrame:CGRectMake(i%num*(viewW + lineW), i/num*(viewH + lineH) + data.topH, viewW, viewH)];
                
                optionAuthView.tag = 2000 + 100*j + i;
                
                optionAuthView.backgroundColor = kWhiteColor;
                
                optionAuthView.imgW = i == 0 ? 26: 35;
                
                optionAuthView.imgH = i == 0 ? 33: 29;

                if (i != 2) {
                    
                    optionAuthView.section = data.sections[i];

                }
                
                [bgView addSubview:optionAuthView];
                
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTestType:)];
                
                [optionAuthView addGestureRecognizer:tapGR];
                
                [self.viewArr addObject:optionAuthView];

            }
            
            UIView *wLine = [[UIView alloc] initWithFrame:CGRectMake(i%num*viewW, (i/num)*viewH + data.topH, viewW, lineH)];
            
            wLine.backgroundColor = kPaleGreyColor;
            
            [bgView addSubview:wLine];
            
            UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake((i%num+1)*viewW, i/num*viewH + data.topH, lineW, viewH)];
            
            hLine.backgroundColor = kPaleGreyColor;
            
            [bgView addSubview:hLine];
            
        }
        
        sectionH += viewH;

        [self addSubview:bgView];
    }
    
    self.height = sectionH + 10*(self.datas.count - 1);
    
}

#pragma mark - Setting

- (void)setAuthModel:(AuthModel *)authModel {

    _authModel = authModel;
    
    for (int i = 0; i < 7; i++) {
        
        switch (i) {
            case 0:
            {
                BaseAuthView *view = self.viewArr[i];

                SectionModel *section = view.section;

                section.flag = authModel.infoIdentifyFlag;
                
                section.type = DataTypeSFRZ;
                
                view.section = section;
                
            }
                break;
                
            case 1:
            {
                BaseAuthView *view = self.viewArr[i];
                
                SectionModel *section = view.section;
                
                section.flag = [authModel.infoAntifraudFlag isEqualToString:@"1"] ? @"3": authModel.infoAntifraudFlag;
                
                section.type = DataTypeBaseInfo;
                
                view.section = section;
            }
                break;
                
            case 2:
            {
                BaseAuthView *view = self.viewArr[i];
                
                SectionModel *section = view.section;
                
                section.flag = authModel.infoZMCreditFlag;
                
                section.type = DataTypeZMF;
                
                view.section = section;

            }
                break;
                
            case 3:
            {
                BaseAuthView *view = self.viewArr[i];
                
                SectionModel *section = view.section;
                
                section.flag = authModel.infoCarrierFlag;

                section.type = DataTypeYYSRZ;
                
                view.section = section;

            }
                break;
                
            case 4:
            {
                OptionAuthView *view = self.viewArr[i];
                
                SectionModel *section = view.section;
                
                section.flag = @"0";
                
                section.type = DataTypeTXLRZ;
                
                view.section = section;
            }
                break;
                
            case 5:
            {
                OptionAuthView *view = self.viewArr[i];
                
                SectionModel *section = view.section;
                
                section.flag = @"0";
                
                section.type = DataTypeWXRZ;
                
                view.section = section;
                
            }
                break;
                
            case 6:
            {
                OptionAuthView *view = self.viewArr[i];
                
                view.textLabel.text = @"";
                
            }
                break;
                
            default:
                break;
        }

    }

}

#pragma mark - Events

- (void)selectTestType:(UITapGestureRecognizer *)sender {
    
//    BOOL isIdent = [self.authModel.infoIdentifyFlag boolValue];
//    
//    BOOL isBasic = [self.authModel.infoBasicFlag boolValue];
//    
//    BOOL isZMScore = [self.authModel.infoZMCreditFlag boolValue];
//    
//    BOOL isYYS = [self.authModel.infoCarrierFlag boolValue];

//
//    NSInteger i;
//    
//    NSInteger j;
//    
//    if (isBasic == YES && isIdent == YES && isZMScore == YES && isYYS == YES) {
//        
//        i = sender.view.tag%100;
//        
//        j = (sender.view.tag-2000)/100;
//        
//    } else if (isIdent == NO) {
//    
//        j = 0;
//        
//        i = 0;
//        
//    }else {
//    
//        j = 0;
//    
//        i = [[TLUser user] currentAuth] + 1;
//    }
//    
//    DataModel *dataModel = self.datas[j];
//    
//    SectionModel *section = dataModel.sections[i];
//    
//    if (_dataBlock) {
//        
//        _dataBlock(section);
//    }
    
    
    NSInteger i = sender.view.tag%100;
    
    NSInteger j = (sender.view.tag-2000)/100;
    
    DataModel *dataModel = self.datas[j];
    
    SectionModel *section = dataModel.sections[i];
    
    if (_dataBlock) {
        
        _dataBlock(section);
    }

}

@end
