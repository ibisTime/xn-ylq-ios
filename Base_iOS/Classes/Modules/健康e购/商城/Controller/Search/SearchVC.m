//
//  SearchVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SearchVC.h"
#import "ShopCell.h"
#import "GoodListCell.h"

#import "ShopModel.h"
#import "GoodModel.h"

#import "ShopDetailVC.h"
#import "ZHGoodsDetailVC.h"

@interface SearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

//搜索店铺结果
@property (nonatomic,strong) NSMutableArray <ShopModel *>*shops;

//搜索智慧民宿结果
@property (nonatomic,strong) NSMutableArray <ShopModel *>*hotels;

//普通商品搜索
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic,strong) TLTableView *searchTableView;

@end

@implementation SearchVC

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    CGFloat searchH = 50;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchH)];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    searchBar.backgroundColor = [UIColor colorWithHexString:@"#f1f4f7"];
    searchBar.placeholder = @"输入关键字搜索";
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    //
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, searchH, kScreenWidth, kScreenHeight - kNavigationBarHeight - searchH) delegate:self dataSource:self];
    
    if (_type == SearchVCTypeDefaultGoods) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodListCell class]) bundle:nil] forCellReuseIdentifier:@"GoodListCell"];
    }
    
    [self.view addSubview:tableView];
    
    self.searchTableView = tableView;
    
    if (self.type == SearchVCTypeShop) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:@"店铺搜索"];
        tableView.rowHeight = [ShopCell rowHeight];
        
    } else if(self.type == SearchVCTypeDefaultGoods) { //店铺支付
        
        self.navigationItem.titleView = [UILabel labelWithTitle:@"商品搜索"];
        tableView.rowHeight = [GoodListCell rowHeight];
        
    } else if (self.type == SearchVCTypeHotel) {
    
        self.navigationItem.titleView = [UILabel labelWithTitle:@"民宿搜索"];
        tableView.rowHeight = [ShopCell rowHeight];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    TLNetworking *http = [TLNetworking new];

    http.showView = self.view;

    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10000";
    http.parameters[@"name"] = searchBar.text;

    if (self.type == SearchVCTypeShop) {
        
        http.code = @"808217";
        
        http.parameters[@"status"] = @"2";
        http.parameters[@"level"] = @"1";

        if (self.lat) {
            http.parameters[@"longitude"] = self.lon;
            http.parameters[@"latitude"] = self.lat;
        }
        
        http.parameters[@"userId"] = [TLUser user].userId;

        [http postWithSuccess:^(id responseObject) {
            
            self.shops = [ShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];

            if (self.shops.count == 0) {
                
                self.searchTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无结果"];
            }
            
            [self.searchTableView reloadData_tl];

            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }  else if(self.type == SearchVCTypeDefaultGoods) { //
        
        
        http.code = @"808028";
        http.parameters[@"status"] = @"3";
        
        http.isShowMsg = NO;
        [http postWithSuccess:^(id responseObject) {
            
            self.goods = [GoodModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];

            if (self.goods && self.goods.count > 0) {
                
                [self.view endEditing:YES];
                
            } else {
            
                self.searchTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无结果"];
            }
            
            [self.searchTableView reloadData_tl];

        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (self.type == SearchVCTypeHotel) {
        
        http.code = @"808217";

        http.parameters[@"status"] = @"2";
        http.parameters[@"level"] = @"2";

        if (self.lat) {
            http.parameters[@"longitude"] = self.lon;
            http.parameters[@"latitude"] = self.lat;
        }
        
        http.parameters[@"userId"] = [TLUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            self.hotels = [ShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];

            if (self.hotels.count == 0) {
                
                self.searchTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无结果"];
            }
            
            [self.searchTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == SearchVCTypeShop) {
        
        ShopModel *shop = self.shops[indexPath.row];

//        ShopDetailVC *detailVC = [[ShopDetailVC alloc] init];
//
//        detailVC.shop = shop;
//
//        detailVC.detaileType = [shop.type isEqualToString:@"mingsu"] ? DetailTypeHotel: DetailTypeDefault;
//
//        //
//        [self.navigationController pushViewController:detailVC animated:YES];
        
        
    } else if(self.type == SearchVCTypeDefaultGoods) { //
        
        ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
        
        detailVC.goods = self.goods[indexPath.row];
        detailVC.detailType = ZHGoodsDetailTypeDefault;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if (self.type == SearchVCTypeHotel) {
    
//        ShopDetailVC *detailVC = [[ShopDetailVC alloc] init];
//
//        detailVC.shop = self.hotels[indexPath.row];
//
//        detailVC.detaileType = DetailTypeHotel;
//
//        detailVC.detaileType = DetailTypeHotel;
//
//        //
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark- dasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.type == SearchVCTypeShop) {
        
        return self.shops.count;
        
    } else if (self.type == SearchVCTypeDefaultGoods) { //店铺搜索
        
        return self.goods.count;
        
    } else {
    
        return self.hotels.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.type == SearchVCTypeShop) {
        
        static NSString *shopCellId = @"ShopCellId";
        ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
        if (!cell) {
            
            cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCellId];
            
        }
        cell.shop = self.shops[indexPath.row];
        return cell;
        
    }  else if (self.type == SearchVCTypeDefaultGoods) {
        
        static NSString *zhGoodsCellId = @"GoodListCell";
        GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:zhGoodsCellId];

        cell.goodModel = self.goods[indexPath.row];
        return cell;
        
    } else {
    
        static NSString *shopCellId = @"ShopCellId";
        ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
        if (!cell) {
            
            cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCellId];
            
        }
        cell.shop = self.hotels[indexPath.row];
        return cell;
    }
    
    static NSString *shopCellId = @"ShopCellId";
    
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
    
    if (!cell) {
        
        cell = [[ShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCellId];
        
    }
    
    cell.shop = self.shops[indexPath.row];
    
    return cell;
    
}


@end
