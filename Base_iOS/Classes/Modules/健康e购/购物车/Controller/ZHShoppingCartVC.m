//
//  ZHShoppingCartVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingCartVC.h"
#import "ZHShoppingCartCell.h"
#import "ZHCartGoodsModel.h"
#import "ZHImmediateBuyVC.h"
#import "ZHCartManager.h"

@interface ZHShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shoopingCartTableV;
@property (nonatomic,strong) UIView *clearingView;
@property (nonatomic,strong) NSMutableArray <ZHCartGoodsModel *>*items;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic,strong) UILabel *totalPriceLbl;
@property (nonatomic,strong) UIButton *chooseAllBtn;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHShoppingCartVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)deleteGoods:(ZHCartGoodsModel *)item {

    
    [TLAlert alertWithTitle:nil msg:@"您确定删除该商品?" confirmMsg:@"删除" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808041";
//        http.parameters[@"code"] = item.code;
        http.parameters[@"token"] = [TLUser user].token;
        http.parameters[@"cartCodeList"] = @[item.code];
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"删除成功"];
            
            [self.items removeObject:item];
            [self.shoopingCartTableV reloadData_tl];
            [self caluateTotalMoney];
            
            //
            [ZHCartManager manager].count = [ZHCartManager manager].count - item.quantity;
            
        } failure:^(NSError *error) {
            
        }];
        
    }];


}

- (void)buy { //购买
    
    //遍历选中商品
    NSMutableArray <ZHCartGoodsModel *>*carts = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            [carts addObject:obj];
            
        }
    }];
    
    if (carts.count <= 0) {
        [TLAlert alertWithInfo:@"您还未选择商品"];
        return;
    }
    
    ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
    buyVC.type = ZHIMBuyTypeAll;
    buyVC.postage = @0;
    
    buyVC.cartsRoom = carts;
    [self.navigationController pushViewController:buyVC animated:YES];
}

#pragma mark- 商品数量改变触发的时间
- (void)countChange {
    
    [self caluateTotalMoney];

}

- (void)caluateTotalMoney {

    //1.全选
    //3.删除商品
    //2.更该商品数量
    
    //计算全部商品总价

   __block  long rmb = 0;
    
    //
   [self.items enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (obj.isSelected) {
           
           rmb += obj.totalRMB;
           
       }
   
    }];
    
    double price = rmb/1000.0;
    //
    self.totalPriceLbl.text = [NSString stringWithFormat:@"实付金额: ￥%.2lf", price];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.shoopingCartTableV beginRefreshing];

    if (self.navigationController.childViewControllers.count == 1) {
        
        self.shoopingCartTableV.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight - 49);
        
        self.clearingView.frame = CGRectMake(0, kScreenHeight - 49 - kNavigationBarHeight - kTabBarHeight, kScreenWidth, 49);
        
    } else {
    
        self.shoopingCartTableV.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight);
        
        self.clearingView.frame = CGRectMake(0, kScreenHeight - kTabBarHeight - kNavigationBarHeight, kScreenWidth, 49);

    }
    
    NSLog(@"count == %ld", self.navigationController.childViewControllers.count);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.isAll = NO;
    self.isFirst = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countChange) name:kSelectedCartGoodsCountChangeNotification object:nil];
    //
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.shoopingCartTableV = tableView;
    tableView.rowHeight = [ZHShoppingCartCell rowHeight];
    //结算相关
    [self.view addSubview:self.clearingView];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"购物车还没有商品"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808045"; //分页查询
    helper.limit = 30;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;

    helper.tableView = self.shoopingCartTableV;
    [helper modelClass:[ZHCartGoodsModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.shoopingCartTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.items = objs;
            [weakSelf.shoopingCartTableV reloadData_tl];
            [weakSelf caluateTotalMoney];

            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoopingCartTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.items = objs;
            [weakSelf.shoopingCartTableV reloadData_tl];
            [weakSelf caluateTotalMoney];

        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoopingCartTableV endRefreshingWithNoMoreData_tl];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"innerSelectedChange" object:nil userInfo:@{
                                                                                                            @"sender": [tableView cellForRowAtIndexPath:indexPath]                                                            }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.buyerItems.count;
    return _items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    static NSString *zhShoppingCartCell = @"ZHShoppingCartCellID";
    ZHShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShoppingCartCell];
    if (!cell) {
        
        cell = [[ZHShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShoppingCartCell];
        
        //删除的选项
        cell.deleteFromCart = ^(ZHCartGoodsModel *item){
        
            [weakself deleteGoods:item];
        };
    }
    cell.item = self.items[indexPath.row];
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UIView *)clearingView {
    
    if (!_clearingView) {
        
        _clearingView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kTabBarHeight - kNavigationBarHeight, kScreenWidth, 49)];
        _clearingView.backgroundColor = [UIColor whiteColor];
        
//        UIButton *chooseAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
//        [chooseAllBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];
//        [chooseAllBtn addTarget:self action:@selector(chooseAll) forControlEvents:UIControlEventTouchUpInside];
//        chooseAllBtn.centerY = _clearingView.height/2.0;
//        [_clearingView addSubview:chooseAllBtn];
//        self.chooseAllBtn = chooseAllBtn;
//        
//        //
//        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(chooseAllBtn.xx + 10, 0, 40, _clearingView.height) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
//        [_clearingView addSubview:hintLbl];
//        hintLbl.text = @"全选";
//        hintLbl.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAll)];
//        [hintLbl addGestureRecognizer:tap];
        
        
        //结算按钮
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(_clearingView.width - 120, 0, 120, _clearingView.height)
                                                       title:@"结算"
                                             backgroundColor:[UIColor zh_themeColor]];
        
        [_clearingView addSubview:clearBtn];
        [clearBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UILabel *moneyLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:FONT(15)
                                          textColor:[UIColor zh_themeColor]];
        [_clearingView addSubview:moneyLbl];
        moneyLbl.numberOfLines = 0;
        
        self.totalPriceLbl = moneyLbl;
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_clearingView.mas_left).offset(10);
            make.top.equalTo(_clearingView.mas_top);
            make.bottom.equalTo(_clearingView.mas_bottom);
            make.right.equalTo(clearBtn.mas_left).offset(-5);
        }];
        
    }
    
    return _clearingView;
    
}

#pragma mark- 全选 按时舍去
- (void)chooseAll {

    if (self.isAll) {

     [self.chooseAllBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];

    } else {

      [self.chooseAllBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateNormal];

    }
    self.isAll = !self.isAll;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedAllCartGoodsNotification object:self userInfo:@{
                                                                                                                        @"isAll" : @(self.isAll)}];
    [self caluateTotalMoney];
    
}


@end
