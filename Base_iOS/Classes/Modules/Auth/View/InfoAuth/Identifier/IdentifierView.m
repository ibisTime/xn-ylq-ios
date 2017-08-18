//
//  IdentifierView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdentifierView.h"
#import "NSAttributedString+add.h"

#define kIVWidth 100

@interface IdentifierView ()

@property (nonatomic, strong) NSMutableArray *ivArr;

@property (nonatomic, strong) NSMutableArray *labelArr;

@property (nonatomic, strong) NSMutableArray *textLabelArr;

@end

@implementation IdentifierView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        [self initData];

        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initData {
    
    self.ivArr = [NSMutableArray array];
    
    self.labelArr = [NSMutableArray array];
    
    self.textLabelArr = [NSMutableArray array];

}

- (void)initSubviews {

    for (int i = 0; i < 2; i++) {
        
        CGFloat centerX = self.width/2.0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(i*220), kScreenWidth, kWidth(220))];
        
        bgView.tag = 1290 + i;
        
        bgView.userInteractionEnabled = YES;

        [self addSubview:bgView];

        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIV:)];
        
        [bgView addGestureRecognizer:tapGR];
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.frame = CGRectMake(0, kWidth(30), kWidth(kIVWidth), kWidth(kIVWidth));
        
        iv.centerX = centerX;
        
        iv.tag = 1300 + i;
        
        [bgView addSubview:iv];
        
        [self.ivArr addObject:iv];
        
        UILabel *label = [UILabel labelWithText:@"" textColor:kTextColor textFont:kWidth(14.0)];
        
        label.frame = CGRectMake(0, iv.yy + kWidth(23), 110, 15);
        
        label.centerX = centerX;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 1310 + i;
        
        [bgView addSubview:label];
        
        [self.labelArr addObject:label];
        
        UILabel *textLabel = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:kWidth(11.0)];
        
        textLabel.frame = CGRectMake(0, label.yy + 6, 100, kWidth(15));
        
        textLabel.centerX = centerX;
        
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        textLabel.tag = 1320 + i;
        
        [bgView addSubview:textLabel];
        
        [self.textLabelArr addObject:textLabel];
    }
    
    UIView *bgView = [self viewWithTag:1291];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, bgView.yy + kWidth(40), kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:commitBtn];
}

- (void)setDatas:(NSMutableArray<SectionModel *> *)datas {

    _datas = datas;

    for (int i = 0; i < _datas.count; i++) {
        
        SectionModel *section = _datas[i];
        
        UIImageView *iv = self.ivArr[i];
        
        iv.image = [UIImage imageNamed:section.img];
        
        UILabel *label = self.labelArr[i];
        
        label.text = section.title;
        
    }
}

#pragma mark - Setting;

- (void)setAuthModel:(AuthModel *)authModel {

    _authModel = authModel;
    
    InfoIdentifyPic *picFlag = self.authModel.infoIdentifyPic;
    
    UIImageView *imgView = [self viewWithTag:1300];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[picFlag.identifyPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"身份证上传"]];
    
    AuthStatusType identifierType = [authModel.infoIdentifyPicFlag isEqualToString:@"0"] ? AuthStatusTypeAuthentication: AuthStatusTypeCommit;
    
    AuthStatusType faceType = [authModel.infoIdentifyFaceFlag isEqualToString:@"0"] ? AuthStatusTypeAuthentication: AuthStatusTypeAuthenticated;
    
    for (int i = 0; i < _datas.count; i++) {
        
        SectionModel *section = _datas[i];
        
        section.authType = i == 0 ? identifierType: faceType;
        
        UILabel *textLabel = self.textLabelArr[i];
        
        NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:section.authStatusImg index:section.authStatusStr.length + 1 string:[NSString stringWithFormat:@"%@  ", section.authStatusStr]];
        
        textLabel.attributedText = authAttrStr;
        
    }
    
}

#pragma mark - Events

- (void)clickIV:(UITapGestureRecognizer *)sender {

    NSInteger index = sender.view.tag - 1290;
    
    if (_identifierBlock) {
        
        _identifierBlock(index);
    }
}

- (void)clickCommit {

    if (_identifierBlock) {
        
        _identifierBlock(IdentifierTypeCommit);
    }
}

@end
