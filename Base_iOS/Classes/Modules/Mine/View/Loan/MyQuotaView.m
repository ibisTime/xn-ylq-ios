//
//  MyQuotaView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyQuotaView.h"

@interface MyQuotaView ()

@property (nonatomic, strong) UILabel *totalLbl;    //额度

@property (nonatomic, strong) UILabel *contentLbl;   //失效时间


@end

@implementation MyQuotaView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];

    }
    
    return self;
}

#pragma markv - Init
- (void)initSubviews {
    
    UILabel *textLbl = [UILabel labelWithText:@"当前信用分" textColor:kWhiteColor textFont:12.0];
    
    textLbl.frame = CGRectMake(0, 50, 100, 14);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.centerX = kScreenWidth/2.0;
    
    [self addSubview:textLbl];
    
    self.totalLbl = [UILabel labelWithText:@"0" textColor:kWhiteColor textFont:32];
    
    self.totalLbl.frame = CGRectMake(0, textLbl.yy + 12, 200, 33);
    
    self.totalLbl.textAlignment = NSTextAlignmentCenter;
    
    self.totalLbl.centerX = kScreenWidth/2.0;
    
    [self addSubview:self.totalLbl];
    
    //半圆
    
    self.contentLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:13.0];
    
    self.contentLbl.frame = CGRectMake(0, self.totalLbl.yy + 20, kScreenWidth, 15);
    
    self.contentLbl.centerX = kScreenWidth/2.0;
    
    self.contentLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.contentLbl];
    
    [self createDottedLine];
}

- (void)drawArc {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    
    CGPoint aPoints[2];
    
    aPoints[0] = CGPointMake(100, 50);
    aPoints[1] = CGPointMake(130, 50);
    
    CGContextAddLines(context, aPoints, 2);
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(self.width/2.0, self.totalLbl.yy - 10) radius:75 startAngle:M_PI endAngle:0 clockwise:YES];
    
    path.lineWidth = 2;
    
    [[UIColor whiteColor] setStroke];
    
    [path stroke];
    
}

-(void)createDottedLine
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
      [NSNumber numberWithInt:3],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);

    CGPathAddArc(path, &transform, self.width/2.0, self.totalLbl.yy - 10, 67, M_PI, 0, NO);
        
//    CGPathMoveToPoint(path, NULL, 0, 89);
//    CGPathAddLineToPoint(path, NULL, 320,89);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
}


-(void)setModel:(QuotaModel *)Model
{
    _Model = Model;
    self.totalLbl.text = [Model.sxAmount convertRealMoney];

}

#pragma mark - Setting
- (void)setQuotaModel:(QuotaModel *)quotaModel {

    _quotaModel = quotaModel;
    
    self.totalLbl.text = [_quotaModel.sxAmount convertRealMoney];
    
    NSInteger flag = [self.quotaModel.flag integerValue];
    
    NSString *promptStr = @"";
    
    switch (flag) {
        case 0:
        {
            
            promptStr = @"未认证";
            self.totalLbl.text = @"0";
        }break;
            
        case 1:
        {
            promptStr = @"认证中";
            self.totalLbl.text = @"0";

        }break;
            
        case 2:
        {
            
            promptStr = @"待审核";
            self.totalLbl.text = @"0";

        }break;
        case 3:
        {
            
            promptStr = @"核准失败";
            self.totalLbl.text = @"0";
            
        }break;
        case 4:
        {
            
            promptStr = @"已核准";
            self.totalLbl.text = [_quotaModel.sxAmount convertRealMoney];

            if ([[_quotaModel.sxAmount convertToSimpleRealMoney] isEqualToString:@"0"]) {
                promptStr = @"已核准";
                
                
            } else {
                
                promptStr = [NSString stringWithFormat:@"还有%ld天，当前信用分失效", _quotaModel.validDays];

            }
        }break;
        case 5:
        {
            
            promptStr = @"信用分失效";
            self.totalLbl.text = [_quotaModel.sxAmount convertRealMoney];
            
        }break;
        case 6:
        {
            
            promptStr = @"重新申请";
            self.totalLbl.text = [_quotaModel.sxAmount convertRealMoney];
            
        }break;
        default:
            break;
    }
    
    self.contentLbl.text = promptStr;
    
}

@end
