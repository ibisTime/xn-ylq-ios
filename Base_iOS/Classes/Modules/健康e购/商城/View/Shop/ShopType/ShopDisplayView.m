//
//  ShopDisplayView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "ShopDisplayView.h"
#import "ShopDisplayCell.h"

#define MARGIN 1

@interface ShopDisplayView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ShopDisplayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat margin = 1;
        
        CGFloat w = (kScreenWidth - 3*margin)/4.0;
        
        CGFloat selfHeight = 2*margin + margin + 2*w;
        
        self.frame = CGRectMake(0, 0, kScreenWidth, selfHeight);
        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        
        //
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(w, w);
        
        flowLayout.minimumLineSpacing = margin;
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, margin, self.width, self.height - 2*margin) collectionViewLayout:flowLayout];
        [self addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        
        
        //注册cell
        [collectionView registerClass:[ShopDisplayCell class] forCellWithReuseIdentifier:@"ShopDisplayCellID"];
        
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopDisplayCellID" forIndexPath:indexPath];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage new]];
    cell.nameLbl.text = @"美食";
    
    return cell;
}

@end
