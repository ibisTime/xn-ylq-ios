//
//  IntegralOrderDetailVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralOrderDetailVC.h"
#import "ZHOrderGoodsCell.h"
#import "BaseAddressChooseView.h"
#import "ZHCartManager.h"
#import "IntegralPayVC.h"
#import "IntegralOrderVC.h"

@interface IntegralOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderDetailTableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic,strong) UILabel *orderCodeLbl;
@property (nonatomic,strong) UILabel *orderTimeLbl;
@property (nonatomic,strong) UILabel *orderStatusLbl;
//@property (nonatomic, strong) UILabel *parameterLbl;
@property (nonatomic, strong) UILabel *noteLabel;   //备注

@property (nonatomic,strong) BaseAddressChooseView *addressView;

@property (nonatomic,strong) UILabel *expressNameLbl;
@property (nonatomic,strong) UILabel *expressCodeLbl;

@end

@implementation IntegralOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.dataSource = self;
    tableV.delegate = self;
    [self.view addSubview:tableV];
    self.orderDetailTableView = tableV;
    
    //
    tableV.backgroundColor = [UIColor zh_backgroundColor];
    tableV.rowHeight = [ZHOrderGoodsCell rowHeight];
    
    //创建headerView
    [self orderHeaderView];
    
    //********headerView 数据
    ZHOrderDetailModel *detailModel = self.order.productOrderList[0];
    
    self.orderCodeLbl.text = [NSString stringWithFormat:@"订单号：    %@",self.order.code];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[self.order.applyDatetime convertToDetailDate]];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"订单状态：%@",[self.order getStatusName]];
    
    
//    self.parameterLbl.lineBreakMode = NSLineBreakByCharWrapping;
    
//    self.parameterLbl.text = [NSString stringWithFormat:@"产品规格：%@",detailModel.productSpecsName];
    self.noteLabel.text = [NSString stringWithFormat:@"备注：       %@", [self.order.applyNote valid]? self.order.applyNote: @"无"];

    self.addressView.nameLbl.text = [@"收货人：" add:self.order.receiver];
    self.addressView.mobileLbl.text = self.order.reMobile;
    self.addressView.addressLbl.text = [@"收货地址：" add:self.order.reAddress];
    //********headerView 数据
    
    
    [self.tableViewHeaderView layoutIfNeeded];
    
    self.tableViewHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.addressView.yy);
    self.orderDetailTableView.tableHeaderView = self.tableViewHeaderView;
    
    if ([self.order.status isEqualToString:@"3"] || [self.order.status isEqualToString:@"4"]) {// 已发货
        
        //footer
        tableV.tableFooterView = [self footerView];
        
        NSString *name = [self.order.logisticsCompany getExpressName];

        self.expressNameLbl.text = [@"快递公司：" add:name];
        self.expressCodeLbl.text = [@"快递单号：" add:self.order.logisticsCode];
        
        if ([self.order.status isEqualToString:@"3"]) {
            
            //收货按钮
            tableV.height = tableV.height - kTabBarHeight;
            UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, kScreenWidth, 49) title:@"收货" backgroundColor:kAppCustomMainColor];
            
            [self.view addSubview:shBtn];
            [shBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    } else if([self.order.status isEqualToString:@"1"]) { //待支付，可取消
        
        tableV.height = tableV.height - kTabBarHeight;
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableV.yy, kScreenWidth/2.0, 49) title:@"取消订单" backgroundColor:kAppCustomMainColor];
        
        [self.view addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancleBtn .xx + 1, tableV.yy, kScreenWidth/2.0 -  1, 49) title:@"支付" backgroundColor:kAppCustomMainColor];
        [self.view addSubview:shBtn];
        [shBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


#pragma mark- 支付
- (void)pay {
    
    BaseWeakSelf;
    
    //商品购买
    IntegralPayVC *payVC = [[IntegralPayVC alloc] init];
    payVC.goodsCodeList = @[self.order.code];
    
    ZHOrderDetailModel *detailModel = _order.productOrderList[0];
    
    NSNumber *rmb = detailModel.price1;
    payVC.rmbAmount = @([rmb longLongValue]*[detailModel.quantity longLongValue]);
    
    //不加邮费的价格
    payVC.amoutAttr = [TLCurrencyHelper calculatePriceWithQBB:detailModel.price3
                                                          GWB:detailModel.price1
                                                          RMB:detailModel.price1
                                                        count:[detailModel.quantity integerValue]];
    
    
    payVC.paySucces = ^(){
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[IntegralOrderVC class]]) {
                
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
            
        }
        
        if (weakSelf.paySuccess) {
            
            weakSelf.paySuccess();
        }
    };
    
    payVC.type = ZHPayViewCtrlTypeNewGoods;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}


#pragma mark- 取消订单
- (void)cancle { //取消订单
    
    [TLAlert alertWithTitle:@"" msg:@"确定取消订单？" confirmMsg:@"取消" cancleMsg:@"不取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808053";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"remark"] = @"用户取消订单";
        http.parameters[@"token"] = [TLUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"取消订单成功"];
            if (self.cancleSuccess) {
                self.cancleSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    
}

- (void)confirmReceive {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808057";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"确认收货";
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"确认收货成功"];
        [self.navigationController popViewControllerAnimated:YES];
//        [self goCommentWithCode:nil];
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)goCommentWithCode:(NSString *)code {
    
    UIAlertController *actionSheetCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"请对该商品做出评价" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *hpAction = [UIAlertAction actionWithTitle:@"好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self commentWithType:@"A" code:code];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    }];
    
    [actionSheetCtrl addAction:hpAction];
    //    [actionSheetCtrl addAction:zpAction];
    //    [actionSheetCtrl addAction:cpAction];
    [actionSheetCtrl addAction:cancleAction];
    
    [self presentViewController:actionSheetCtrl animated:YES completion:nil];
    
    
}

- (void)commentWithType:(NSString *)type code:(NSString *)code {
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808240";
    http.parameters[@"storeCode"] = self.order.product.code;
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"3";
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"评价成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.expressNameLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 16, kScreenWidth - 30, [FONT(13) lineHeight])
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [footerView addSubview:self.expressNameLbl];
    
    self.expressCodeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin,  self.expressNameLbl.yy + 16, kScreenWidth - 30, self.expressNameLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [footerView addSubview:self.expressCodeLbl];
    
    return footerView;
    
    
}

//--//
- ( void )orderHeaderView {
    
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    UIView *headerView = self.tableViewHeaderView;
    
    //
    self.orderCodeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 16, kScreenWidth - 30, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderCodeLbl];
    
    //
    self.orderTimeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderCodeLbl.yy + 5, kScreenWidth - 30, self.orderCodeLbl.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderTimeLbl];
    
    //
    self.orderStatusLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderTimeLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderStatusLbl];
    
//    //
//    self.parameterLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderStatusLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
//                                   textAligment:NSTextAlignmentLeft
//                                backgroundColor:[UIColor whiteColor]
//                                           font:FONT(13)
//                                      textColor:[UIColor zh_textColor]];
//    [headerView addSubview:self.parameterLbl];
//    self.parameterLbl.numberOfLines = 0;
    
    self.noteLabel = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderStatusLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(13)
                                   textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.noteLabel];
    
    //
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.orderStatusLbl.yy + 16, kScreenWidth, 10)];
    [headerView addSubview:lineV];
    lineV.backgroundColor = [UIColor zh_backgroundColor];
    
    //收货信息
    self.addressView = [[BaseAddressChooseView alloc] initWithFrame:CGRectMake(0, lineV.yy, kScreenWidth, 89)];
    self.addressView.type = ZHAddressChooseTypeDisplay;
    [headerView addSubview:self.addressView];
    
//    //添加约束
//    [self.parameterLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.orderStatusLbl.mas_bottom).offset(5);
//        make.left.equalTo(headerView.mas_left).offset(kLeftMargin);
//        make.right.lessThanOrEqualTo(headerView.mas_right).offset(-kLeftMargin);
//        
//    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.noteLabel.mas_bottom).offset(16);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(10);
        
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(lineV.mas_bottom);
        make.height.equalTo(@89);
        //        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.order.productOrderList.count;
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    ZHOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[ZHOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        __weak typeof(self) weakself = self;
//        cell.comment = ^(NSString *code){
//            
//            [weakself goCommentWithCode:code];
//            
//        };
        
    }
    
    cell.moneyType = MoneyTypeJF;
    cell.order = self.order;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *hfV = (UITableViewHeaderFooterView *)view;
    hfV.contentView.backgroundColor = [UIColor zh_backgroundColor];
    
}


@end
