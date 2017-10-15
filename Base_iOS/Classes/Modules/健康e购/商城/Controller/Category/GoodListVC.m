//
//  GoodListVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/15.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "GoodListVC.h"
#import "GoodListCell.h"
#import "TLPageDataHelper.h"
#import "ZHGoodsDetailVC.h"

@interface GoodListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) TLTableView *goodTableView;
//公告view
@property (nonatomic,strong) NSMutableArray *goods;

@end

@implementation GoodListVC

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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.goodTableView beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"商品列表"];
    [self initTableView];
    
    [self requestData];
}

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) delegate:self dataSource:self];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodListCell class]) bundle:nil] forCellReuseIdentifier:@"GoodCellId"];
    [self.view addSubview:tableView];
    self.goodTableView = tableView;
    self.goodTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"没有发现商品"];
    
}

#pragma mark - Data
- (void)requestData {
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808025";

    helper.parameters[@"type"] = self.type;
    helper.parameters[@"status"] = @"3";
    helper.parameters[@"kind"] = @"1";
    
    helper.tableView = self.goodTableView;
    [helper modelClass:[GoodModel class]];
    
    __weak typeof(self) weakSelf = self;
    [self.goodTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.goodTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.goodTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.goodTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.goodTableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodModel *good = self.goods[indexPath.row];
    
    ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
    detailVC.goods = good;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark- datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goods.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhgoodCellId = @"GoodCellId";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:zhgoodCellId];
    
    cell.goodModel = self.goods[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
