//
//  IdentifierView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdentifierView.h"
#import "NSAttributedString+add.h"
#import "UIView+Custom.h"

#define kIVWidth 140

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
        
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWidth(36), kWidth(kIVWidth), kWidth(kIVWidth))];
        
        bgIV.centerX = centerX;

        [bgView addSubview:bgIV];
        //画虚线
        [bgIV drawAroundLine:3 lineSpacing:3 lineColor:kLineColor];
        
        if (i == 0) {
            
            self.identifierIV = bgIV;
        }
        
        CGFloat ivH = i == 0 ? 56: 70;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.frame = CGRectMake(kWidth(35), kWidth((140 - ivH)/2.0), kWidth(70), kWidth(ivH));
        
        iv.tag = 1300 + i;
        
        [bgIV addSubview:iv];
        
        [self.ivArr addObject:iv];
        
        UILabel *label = [UILabel labelWithText:@"" textColor:kTextColor textFont:kWidth(14.0)];
        
        label.frame = CGRectMake(0, bgIV.yy + kWidth(23), 110, 15);
        
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
        
        UILabel *textLabel = self.textLabelArr[i];
        
        NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:section.authStatusImg index:section.authStatusStr.length + 1 string:[NSString stringWithFormat:@"%@  ", section.authStatusStr] labelHeight:textLabel.height];
        
        textLabel.attributedText = authAttrStr;
        
        textLabel.textColor = section.color;
        
    }
}

#pragma mark - Setting;

- (void)setAuthModel:(AuthModel *)authModel {

    _authModel = authModel;
    
    InfoIdentifyPic *picFlag = self.authModel.infoIdentifyPic;
    
    if (picFlag.identifyPic) {
        
        UIImageView *imgView = [self viewWithTag:1300];
        
        imgView.image = nil;
    }

    [self.identifierIV sd_setImageWithURL:[NSURL URLWithString:[picFlag.identifyPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@""]];
    
    for (int i = 0; i < _datas.count; i++) {
        
        SectionModel *section = _datas[i];
        
        section.flag = i == 0 ? authModel.infoIdentifyPicFlag: authModel.infoIdentifyFaceFlag;
        
        UILabel *textLabel = self.textLabelArr[i];
        
        NSAttributedString *authAttrStr = [NSAttributedString getAttributedStringWithImgStr:section.authStatusImg index:section.authStatusStr.length + 1 string:[NSString stringWithFormat:@"%@  ", section.authStatusStr] labelHeight:textLabel.height];
        
        textLabel.attributedText = authAttrStr;
        
        textLabel.textColor = section.color;
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
