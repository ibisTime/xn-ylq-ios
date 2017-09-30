//
//  OnlineRenewalVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/5.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OnlineRenewalVC.h"
#import "PayInfoCell.h"
#import "PayFuncModel.h"

#import "TLWXManager.h"
#import "TLAlipayManager.h"

@interface OnlineRenewalVC ()

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <PayFuncModel *>*pays;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) TLTextField *originDateTF;    //起始时间
@property (nonatomic, strong) TLTextField *endDateTF;       //结束时间
@property (nonatomic, strong) TLTextField *amountTF;        //续期金额
@property (nonatomic, strong) UILabel *promptLbl;           //提示

@end

@implementation OnlineRenewalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self beginLoad];
    
    [self initTableView];
    
    [self initHeaderView];
}

#pragma mark - Init

- (void)beginLoad {
    
    //--//
//    NSArray *imgs = @[@"weixin",@"alipay"];

//    payNames  = @[@"微信支付",@"支付宝"]; //余额(可用100)
//
//    NSArray *payType = @[@(PayTypeWeChat),@(PayTypeAlipay)];
//    NSArray <NSNumber *>*status = @[@(YES),@(NO)];
    NSArray *imgs = @[@"alipay", @"baofu"];
    
    NSArray *payNames;
    payNames  = @[@"支付宝", @"宝付"]; //余额(可用100)
    
    NSArray *payType = @[@(PayTypeAlipay), @(PayTypeBaoFu)];
    NSArray <NSNumber *>*status = @[@(YES), @(NO)];
    
    self.pays = [NSMutableArray array];
    
    NSInteger count = imgs.count;
    
    
    //全部转换为支付模型
    for (NSInteger i = 0; i < count; i ++) {
        
        PayFuncModel *zhPay = [[PayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
    
}

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    
    //按钮
    UIButton *payBtn = [UIButton buttonWithTitle:@"确定续期" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    payBtn.frame = CGRectMake(15, 40, kScreenWidth - 30, 45);
    
    [payBtn addTarget:self action:@selector(renewal) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:payBtn];
    
    self.tableView.tableFooterView = footerView;
    
}

- (void)initHeaderView {

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 197)];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    
    UILabel *textLbl = [UILabel labelWithFrame:CGRectMake(15, 0, kScreenWidth, 32) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(14) textColor:kTextColor2];
    
    textLbl.text = @"本次续期";
    
    [topView addSubview:textLbl];
    
    [self.headerView addSubview:topView];
    
    //起始时间
    TLTextField *originDateTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, topView.yy, kScreenWidth, 44) leftTitle:@"起点日期" titleWidth:145 placeholder:@""];
    
    originDateTF.textColor = [UIColor textColor];
    
    originDateTF.enabled = NO;

    [self.headerView addSubview:originDateTF];
    
    self.originDateTF = originDateTF;
    
    //结束时间
    TLTextField *endDateTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, originDateTF.yy + 1, kScreenWidth, 44) leftTitle:@"续期后还款日期" titleWidth:145 placeholder:@""];
    
    endDateTF.textColor = [UIColor textColor];

    endDateTF.enabled = NO;
    
    [self.headerView addSubview:endDateTF];
    self.endDateTF = endDateTF;
    
    //续期金额
    self.amountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, endDateTF.yy + 1, kScreenWidth, 44) leftTitle:@"续期金额" titleWidth:145 placeholder:@""];
    
    self.amountTF.textColor = [UIColor textColor];
    
    self.amountTF.enabled = NO;
    
    [self.headerView addSubview:self.amountTF];
    
    self.tableView.tableHeaderView = self.headerView;
    
    //提示
    self.promptLbl = [UILabel labelWithFrame:CGRectMake(15, self.amountTF.yy, kScreenWidth - 30, 30) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13.0) textColor:kThemeColor];
    
    [self.headerView addSubview:self.promptLbl];
}

#pragma mark - Setting
- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    self.originDateTF.text = [_order.renewalStartDate convertDate];
    
    self.endDateTF.text = [_order.renewalEndDate convertDate];
    
    self.amountTF.text = [NSString stringWithFormat:@"%@元", [_order.renewalAmount convertToSimpleRealMoney]];
    //逾期利息
    NSString *yqAmount = [_order.yqlxAmount convertToSimpleRealMoney];
    
    //续期利息
    NSString *xqAmount = [@([_order.renewalAmount longLongValue] - [_order.yqlxAmount longLongValue]) convertToSimpleRealMoney];
    
    self.promptLbl.text = [NSString stringWithFormat:@"续期金额 = 续期利息(%@元) + 逾期利息(%@元)", xqAmount, yqAmount];
}

#pragma mark - Events
//续期
- (void)renewal {
    
    __block PayType type;
    
    [self.pays enumerateObjectsUsingBlock:^(PayFuncModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            type = obj.payType;
            *stop = YES;
        }
        
    }];
    
    NSString *payType;
    
    switch (type) {
           
        case PayTypeBaoFu: {
            
            payType = @"5";
            
        }break;
            
        case PayTypeAlipay: {
            
            payType = @"3";
            
        }break;
            
        case PayTypeWeChat: {
            
            payType = @"2";
            
        }break;
            
        case PayTypeOther: {
            
            payType = @"1";
            
        }break;
            
    }
    
    [self shopPay:payType payPwd:nil];
    
}

#pragma mark - 支付
- (void)shopPay:(NSString *)payType payPwd:(nullable NSString *)pwd {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623078";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"payType"] = payType;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([payType isEqualToString: @"2"]) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else if([payType isEqualToString: @"3"]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
            
        } else {
            
            [TLAlert alertWithSucces:@"续期成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    [TLAlipayManager manager];
    
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"续期成功"];
            
            if (weakSelf.paySucces) {
                weakSelf.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"续期失败"];
        }
        
    }];
    
    
}

- (void)wxPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    NSDictionary *dict = info;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"wechatPackage"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]){
        
    } else {
        
        [TLAlert alertWithError:@"续期失败"];
    }
    //回调
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                [TLAlert alertWithSucces:@"续期成功"];
                
                if (weakSelf.paySucces) {
                    
                    weakSelf.paySucces();
                }
                
            } else {
                
                [TLAlert alertWithError:@"续期失败"];
            }
            
        });
        
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pays.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * payInfoCellID = @"PayInfoCell";
    PayInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:payInfoCellID];
    if (!cell) {
        cell = [[PayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payInfoCellID];
    }
    cell.pay = self.pays[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PayInfoCell class]]) {
        
        //----不是余额把 支付密码隐藏掉----//
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return [self payFuncHeaderView];
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)payFuncHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, kScreenWidth - 35, headView.height)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor zh_textColor]];
    lbl.text = @"支付方式";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = kLineColor;
    
    [headView addSubview:lineView];
    
    return headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
