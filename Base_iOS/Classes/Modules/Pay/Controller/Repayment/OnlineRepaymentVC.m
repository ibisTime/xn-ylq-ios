//
//  OnlineRepaymentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OnlineRepaymentVC.h"

#import "PayInfoCell.h"
#import "PayFuncModel.h"

#import "TLWXManager.h"
#import "TLAlipayManager.h"

@interface OnlineRepaymentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) TLTextField *amountTf;

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <PayFuncModel *>*pays;

@end

@implementation OnlineRepaymentVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"还款";
    
    [self beginLoad];
    
    [self initSubviews];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

#pragma mark - Init

- (TLTextField *)amountTf {
    
    if (!_amountTf) {
        
        _amountTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:@"还款金额" titleWidth:100 placeholder:@""];
        
        _amountTf.backgroundColor = [UIColor whiteColor];
        _amountTf.delegate = self;
        _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
        
        _amountTf.text = [self.order.totalAmount convertToSimpleRealMoney];
        
        _amountTf.enabled = NO;
    }
    return _amountTf;
    
}

- (void)initSubviews {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) delegate:self dataSource:self];
    
    [self.view addSubview:self.tableView];
    
    self.tableView .tableHeaderView = self.amountTf;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //按钮
    UIButton *payBtn = [UIButton buttonWithTitle:@"确定还款" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:22.5];
    
    payBtn.frame = CGRectMake(15, 40, kScreenWidth - 30, 45);
    
    [payBtn addTarget:self action:@selector(repayment) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:payBtn];
    
    self.tableView.tableFooterView = footerView;
    
}

#pragma mark - Events

- (void)beginLoad {
    
    //--//
    //    NSArray *imgs = @[@"weixin",@"alipay"];
    NSArray *imgs = @[@"alipay", @"baofu"];
    
    NSArray *payNames;
    
    //    payNames  = @[@"微信支付",@"支付宝"]; //余额(可用100)
    //
    //    NSArray *payType = @[@(PayTypeWeChat),@(PayTypeAlipay)];
    //    NSArray <NSNumber *>*status = @[@(YES),@(NO)];
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

- (void)repayment {
    
    __block PayType type;
    
    [self.pays enumerateObjectsUsingBlock:^(PayFuncModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            type = obj.payType;
            *stop = YES;
        }
        
    }];
    
    if (![self.amountTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入还款金额"];
        return;
        
    }
    
    NSString *payType;
    
    switch (type) {
            
        case PayTypeBaoFu:
        {
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

#pragma mark- 优店支付, 余额支付需要支付密码
- (void)shopPay:(NSString *)payType payPwd:(nullable NSString *)pwd {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"623072";
    //    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"payType"] = payType;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([payType isEqualToString: @"2"]) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else if([payType isEqualToString: @"3"]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
        } else {
            
            [TLAlert alertWithSucces:@"还款成功"];
            
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
            
            [TLAlert alertWithSucces:@"还款成功"];
            
            if (weakSelf.paySucces) {
                weakSelf.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"还款失败"];
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
        
        [TLAlert alertWithError:@"还款失败"];
    }
    //回调
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                [TLAlert alertWithSucces:@"还款成功"];
                
                if (weakSelf.paySucces) {
                    
                    weakSelf.paySucces();
                }
                
            } else {
                
                [TLAlert alertWithError:@"还款失败"];
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
    
    return 10;
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
