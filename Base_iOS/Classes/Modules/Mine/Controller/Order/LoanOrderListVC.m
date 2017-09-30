//
//  LoanOrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoanOrderListVC.h"
#import "OrderModel.h"
#import "LoanOrderDetailVC.h"
#import "LoanOrderListCell.h"

@interface LoanOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation LoanOrderListVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestOrderList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPlaceHolderView];

    [self initTableView];
    
}

#pragma mark - Init
- (void)initTableView {
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 100;
    
    self.tableView = tableView;
    tableView.placeHolderView = self.placeHolderView;
}

- (void)initPlaceHolderView {

    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40)];

    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"您还没有借款记录" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

#pragma mark - Data
- (void)requestOrderList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"623087";
//    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"applyUser"] = [TLUser user].userId;
//    helper.parameters[@"type"] = @"1";
    
    helper.isDeliverCompanyCode = NO;
    
    NSArray *statusList;
    
    switch (self.status) {
        case LoanOrderStatusWillAudit:
        {
            statusList = @[@"0"];
        }break;
          
        case LoanOrderStatusWillLoan:
        {
            statusList = @[@"1"];
            
        }break;
        
        case LoanOrderStatusAuditFailure:
        {
            statusList = @[@"2"];
            
        }break;
            
        case LoanOrderStatusDidLoan:
        {
            statusList = @[@"3"];
            
        }break;
            
        case LoanOrderStatusDidRepayment:
        {
            statusList = @[@"4"];
            
        }break;
            
        case LoanOrderStatusDidOverdue:
        {
            statusList = @[@"5"];
            
        }break;
            
        case LoanOrderStatusMoneyFailure:
        {
            statusList = @[@"7"];

        }break;
            
        default:
            break;
    }
    
    helper.parameters[@"statusList"] = statusList;
    
    helper.tableView = self.tableView;
    [helper modelClass:[OrderModel class]];
    
    //-----//
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.orderGroups = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
//    [self.tableView addRefreshAction:^{
//        
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            
//            weakSelf.orderGroups = objs;
//            [weakSelf.tableView reloadData_tl];
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//        
//    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *loanOrderListCellID = @"LoanOrderListCellID";
    
    LoanOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:loanOrderListCellID];
    if (!cell) {
        
        cell = [[LoanOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loanOrderListCellID];
        
    }
    
    cell.orderModel = self.orderGroups[indexPath.section];
    
    return cell;
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanOrderDetailVC *vc = [[LoanOrderDetailVC alloc] init];
    
    vc.order = self.orderGroups[indexPath.section];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //50
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrderNum:model.code date:nil];
    
}

- (UIView *)headerViewWithOrderNum:(NSString *)num date:(NSString *)date {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    
    v.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];
    [headerV addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.top.equalTo(headerV.mas_top).offset(10);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"订单编号: %@", num];
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];;
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    lbl2.text = [date convertDate];
    
    //
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerV.height - 0.7, kScreenWidth, 0.7)];
    line.backgroundColor = kLineColor;
    [headerV addSubview:line];
    
    return headerV;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
