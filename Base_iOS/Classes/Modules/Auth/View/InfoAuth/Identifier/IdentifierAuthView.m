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

#define kIVWidth 165
#define kIVHeight 120

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(20), kScreenWidth,450)];
    bgView.tag = 1390 ;
    
    bgView.userInteractionEnabled = YES;
    
    [self.scrollView addSubview:bgView];
    for (int i = 0; i < titleArr.count; i++) {
        
        CGFloat centerX = self.width/2.0;
        
        
   
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIV:)];
        
        [bgView addGestureRecognizer:tapGR];
        UIImageView *bgIV;
        if (i==0) {
            bgIV  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kWidth(kIVWidth), kWidth(kIVHeight))];
        }else if(i == 1){
             bgIV  = [[UIImageView alloc] initWithFrame:CGRectMake(15*3+kIVWidth, 15, kWidth(kIVWidth), kWidth(kIVHeight))];
        }else{
            
            
             bgIV  = [[UIImageView alloc] initWithFrame:CGRectMake(15, kIVHeight+30+30+30, kScreenWidth-30, kHeight(175))];
        }
   
        
//        bgIV.centerX = centerX;
        
        [bgView addSubview:bgIV];
        if (i==1) {
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, bgIV.yy + 40, kScreenWidth, 10)];
            line1.backgroundColor = [UIColor zh_lineColor];
            [bgView addSubview:line1];
        }
        //画虚线
        [bgIV drawAroundLine:3 lineSpacing:3 lineColor:kLineColor];
        
        CGFloat imageW = 165;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.contentMode = UIViewContentModeScaleAspectFit;
        
        iv.image = kImage(imgArr[i]);
        
        iv.frame = CGRectMake(15, 15, kWidth(165), kWidth(120));
        UILabel *label = [UILabel labelWithText:titleArr[i] textColor:kTextColor textFont:kWidth(14.0)];
        
        if (i==0) {
            
            iv.frame  = CGRectMake(0, 0, kWidth(kIVWidth), kWidth(kIVHeight));
            label.frame = CGRectMake(0, bgIV.yy+4 , kIVWidth, 22);

        }else if(i == 1){
            iv.frame  = CGRectMake(0, 0, kWidth(kIVWidth), kWidth(kIVHeight));
            label.frame = CGRectMake(kIVWidth+45, bgIV.yy+4 , kIVWidth, 22);

        }else{
            iv.frame  = CGRectMake(0, 0, kScreenWidth-30, kHeight(175));
            label.frame = CGRectMake(0, bgIV.yy+4 , kScreenWidth-30, 22);

        }
        iv.tag = 1400 + i;
        
        [bgIV addSubview:iv];
        
        [self.ivArr addObject:iv];
        
      
        
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 1410 + i;
        
        [bgView addSubview:label];
        
        [self.labelArr addObject:label];
        
    }
    
//    bgView = [self viewWithTag:1400 + titleArr.count ];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    commitBtn.frame = CGRectMake(leftMargin, bgView.yy , kScreenWidth - 2*leftMargin, btnH);
    
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
