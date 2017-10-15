//
//  SpecialMallVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/11.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SpecialMallVC.h"

#import "GoodModel.h"

#import "ZHGoodsDetailVC.h"
#import "NSNumber+TLAdd.h"

@interface SpecialMallVC ()

@property (nonatomic, strong) NSArray <GoodModel *>*goods;

@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SpecialMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    
}

#pragma mark - Init
- (void)initScrollView {

    CGFloat space = 10;

    NSInteger count = _goods.count;

    CGFloat w = (kScreenWidth - 4*space)/3.0;
    
    CGFloat h = w+10+10+10+16;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,
                                                                     h)];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(count*w+(count+1)*space, h);
    
    for (int i = 0; i < count; i++) {
        
        GoodModel *goodModel = _goods[i];
        
        CDGoodsParameterModel *productInfo = goodModel.productSpecsList[0];
        
        UIView *view = [[UIView alloc] init];
        
        view.tag = 1350 + i;
        
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(space + i*(w+space));
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(h);
            make.top.mas_equalTo(0);
            
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGood:)];
        
        [view addGestureRecognizer:tapGR];
        
        //商品图片
        UIImageView *imgView = [[UIImageView alloc] init];
        
        NSString *advPic = [goodModel.advPic componentsSeparatedByString:@"||"][0];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(w);
            
        }];
        
        NSString *currentPrice = [NSString stringWithFormat:@"￥%@", [productInfo.price1 convertToSimpleRealMoney]];
        
        UILabel *currentPriceLabel = [UILabel labelWithText:currentPrice textColor:kOrangeRedColor textFont:13.0];
        
        [view addSubview:currentPriceLabel];
        [currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(imgView.mas_bottom).mas_equalTo(10);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(16);
            
        }];
        
        NSString *originPrice = [NSString stringWithFormat:@"￥%@", [productInfo.originalPrice convertToSimpleRealMoney]];
        
        UILabel *oldPriceLabel = [UILabel labelWithText:originPrice textColor:[UIColor textColor2] textFont:11.0];
        
        [view addSubview:oldPriceLabel];
        [oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(currentPriceLabel.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(imgView.mas_bottom).mas_equalTo(10);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(16);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = [UIColor textColor2];
        
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(oldPriceLabel.mas_centerY);
            make.left.mas_equalTo(oldPriceLabel.mas_left);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(oldPriceLabel.mas_right).mas_equalTo(2);
            
        }];
    }
}

#pragma makr - Data
- (void)startLoadData {
    
    [self requestSpecialGoods];
    
}

- (void)requestSpecialGoods {

    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808025";
    
    helper.parameters[@"status"] = @"3";
    helper.parameters[@"kind"] = @"1";
    helper.parameters[@"location"] = [NSString stringWithFormat:@"%ld", _goodType+2];
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[GoodModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        [self.scrollView removeFromSuperview];

//        self.scrollView = nil;
//        
//        self.placeholderView = nil;
        
        [self.placeholderView removeFromSuperview];

        if (weakSelf.goods.count > 0) {
            
            [self initScrollView];
            
        } else {
            
            self.placeholderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品" topMargin:0];
            
            [self.view addSubview:self.placeholderView];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - Events

- (void)selectGood:(UITapGestureRecognizer *)tapGR {

    NSInteger index = tapGR.view.tag - 1350;
    
    GoodModel *good = self.goods[index];
    
    ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
    detailVC.goods = good;
    detailVC.detailType = ZHGoodsDetailTypeDefault;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
