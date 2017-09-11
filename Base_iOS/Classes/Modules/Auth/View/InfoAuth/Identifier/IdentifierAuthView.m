//
//  IdentifierAuthView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/4.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdentifierAuthView.h"
#import "NSAttributedString+add.h"
#import "UIView+Custom.h"

#define kIVWidth 140

@interface IdentifierAuthView ()

@property (nonatomic, strong) NSMutableArray *ivArr;

@property (nonatomic, strong) NSMutableArray *labelArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation IdentifierAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        [self initScrollView];
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initScrollView {

    self.ivArr = [NSMutableArray array];
    
    self.labelArr = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
}

- (void)initSubviews {
    
    NSArray *titleArr = @[@"身份证正面照", @"身份证反面照", @"手持身份证照"];
    
    NSArray *imgArr = @[@"身份证正面", @"身份证反面", @"持证自拍"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        CGFloat centerX = self.width/2.0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(i*220), kScreenWidth, kWidth(220))];
        
        bgView.tag = 1390 + i;
        
        bgView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:bgView];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIV:)];
        
        [bgView addGestureRecognizer:tapGR];
        
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWidth(36), kWidth(kIVWidth), kWidth(kIVWidth))];
        
        bgIV.centerX = centerX;
        
        [bgView addSubview:bgIV];
        //画虚线
        [bgIV drawAroundLine:3 lineSpacing:3 lineColor:kLineColor];
        
        CGFloat imageW = 110;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.contentMode = UIViewContentModeScaleAspectFit;
        
        iv.image = kImage(imgArr[i]);
        
        iv.frame = CGRectMake(15, 15, kWidth(imageW), kWidth(imageW));
        
        iv.tag = 1400 + i;
        
        [bgIV addSubview:iv];
        
        [self.ivArr addObject:iv];
        
        UILabel *label = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:kWidth(14.0)];
        
        label.frame = CGRectMake(0, bgIV.yy + kWidth(30), 110, 15);
        
        label.centerX = centerX;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 1410 + i;
        
        [bgView addSubview:label];
        
        [self.labelArr addObject:label];
        
    }
    
    UIView *bgView = [self viewWithTag:1390 + titleArr.count - 1];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, bgView.yy + kWidth(40), kScreenWidth - 2*leftMargin, btnH);
    
    [commitBtn addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:commitBtn];
    
    self.commitBtn = commitBtn;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, commitBtn.yy + kWidth(40));
}

#pragma mark - Setting;

- (void)setAuthModel:(AuthModel *)authModel {
    
    _authModel = authModel;
    
    InfoIdentifyPic *picFlag = self.authModel.infoIdentifyPic;
    
    if (picFlag) {
        
        for (int i = 0; i < 3; i++) {
            
            NSString *imageStr = @"";
            
            switch (i) {
                    
                case 0:
                {
                    imageStr = picFlag.identifyPic;
                    
                }break;
                    
                case 1:
                {
                    imageStr = picFlag.identifyPicReverse;
                    
                }break;
                    
                case 2:
                {
                    imageStr = picFlag.identifyPicHand;
                    
                }break;
                    
                default:
                    break;
            }
            
            if (![imageStr isEqualToString:@""]) {
                
                UIImageView *imgView = [self viewWithTag:1400 + i];
                
                imgView.frame = CGRectMake(0, 0, kWidth(kIVWidth), kWidth(kIVWidth));
                
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:[imageStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@""]];
            }
            
        }

    }
    
    self.commitBtn.enabled = [_authModel.infoIdentifyFlag isEqualToString:@"1"] ? NO: YES;
    
    UIColor *bgColor = [_authModel.infoIdentifyFlag isEqualToString:@"1"] ? kGreyButtonColor: kAppCustomMainColor;
    
    [self.commitBtn setBackgroundColor:bgColor];
    
    self.commitBtn.layer.cornerRadius = 22.5;
    self.commitBtn.clipsToBounds = YES;
}

#pragma mark - Events

- (void)clickIV:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag - 1390;
    
    if (_identifierBlock) {
        
        _identifierBlock(index);
    }
}

- (void)clickCommit {
    
    if (_identifierBlock) {
        
        _identifierBlock(IdentifierAuthTypeCommit);
    }
}

@end
