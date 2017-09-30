//
//  IntegralPayVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/18.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntegralPayVC.h"
#import "ZHPayInfoCell.h"
#import "ZHPayFuncModel.h"
#import "ZHPayFuncCell.h"
#import "TLCurrencyHelper.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLGroupModel.h"
#import "TLAlipayManager.h"
#import "TLPwdRelatedVC.h"
#define PAY_TYPE_DEFAULT_PAY_CODE @"1"
#define PAY_TYPE_WX_PAY_CODE @"2"
#define PAY_TYPE_ALI_PAY_CODE @"3"

@interface IntegralPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

//@property (nonatomic, strong) TLTextField *tradePwdTf;
//底部价格
@property (nonatomic,strong) UILabel *priceLbl;

@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;

@end

@implementation IntegralPayVC

- (void)canclePay {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self beginLoad];
}

- (void)tl_placeholderOperation {
    
    TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
    [self.navigationController pushViewController:pwdAboutVC animated:YES];
    
    [pwdAboutVC setSuccess:^{
        
        [self removePlaceholderView];
        [self beginLoad];
        
    }];
    
}

- (void)beginLoad {
    
    //--//
    
    self.pays = [NSMutableArray array];
    
    
    //--//
    self.paySceneManager = [[ZHPaySceneManager alloc] init];
    switch (self.type) {
            
        case ZHPayViewCtrlTypeHZB: { //购买汇赚宝
            
            
            
        } break;
            
        case ZHPayViewCtrlTypeNewYYDB: { //2.0版本的一元夺宝
            
            
            
            
        } break;
            
        case ZHPayViewCtrlTypeNewGoods: { //普通商品支付
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.rmbAmount convertToSimpleRealMoney];
            
            //1.第一组
            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
            priceItem.headerHeight = 10.0;
            priceItem.footerHeight = 10.0;
            
            priceItem.rowNum = 1;

            
            self.paySceneManager.groupItems = @[priceItem];
            [self setUpUI];

            
        } break;
            
        default: [TLAlert alertWithInfo:@"您还没有选择支付场景"];
            
    }
    
    
    
#pragma mark- 微信支付回调
    BaseWeakSelf;
    
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                [TLAlert alertWithSucces:@"支付成功"];
                
                if (weakSelf.paySucces) {
                    weakSelf.paySucces();
                }
                
            } else {
                
                [TLAlert alertWithError:@"支付失败"];
                
                
            }
            
            
        });
        
    };
    
#pragma mark- 支付宝支付回调
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"支付成功"];
            
            if (weakSelf.paySucces) {
                weakSelf.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"支付失败"];
            
        }
        
    }];
    
    
    
}

#pragma mark- 支付
- (void)pay {
    
    
    [self goodsPay:@"1" payPwd:nil];

    
}

- (void)wxPayWithInfo:(NSDictionary *)info {
    
    
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
        
        [TLAlert alertWithError:@"兑换失败"];
        
    }
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    
}

//尖货支付
- (void)goodsPay:(NSString *)payType payPwd:(NSString *)pwd {
    
    if (!self.goodsCodeList) {
        
        NSLog(@"请填写订单信息");
        return;
    }
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"确定要兑换?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808052";
        http.parameters[@"codeList"] = self.goodsCodeList;
        http.parameters[@"payType"] = payType;
        
        [http postWithSuccess:^(id responseObject) {
            
            if ([payType isEqualToString:PAY_TYPE_ALI_PAY_CODE]) {
                
                [self aliPayWithInfo:responseObject[@"data"]];
                
            } else if([payType isEqualToString:PAY_TYPE_WX_PAY_CODE]) {
                
                [self wxPayWithInfo:responseObject[@"data"]];
                
            } else {
                
                [TLAlert alertWithSucces:@"兑换成功"];
                
                if (self.paySucces) {
                    self.paySucces();
                }
                
            }
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }]];
    
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    
    
}

#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL con1 = self.pays[indexPath.row].payType == ZHPayTypeWeChat;
    BOOL con2 = [WXApi isWXAppInstalled];
    if (con1 && !con2) {
        [TLAlert alertWithInfo:@"您还未安装微信,不能进行微信支付"];
        return;
    }
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
        
        
        //解决重复点击
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


//
- (void)setUpUI {
    
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kSuperViewHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:payTableView];
    self.payTableView = payTableView;
    payTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    payTableView.rowHeight = 50;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.dataSource = self;
    payTableView.delegate = self;
    
    //底部支付相关
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, payTableView.yy, kScreenWidth, 49)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
    //按钮
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, payView.height) title:@"确认支付" backgroundColor:kAppCustomMainColor];
    [payView addSubview:payBtn];
    payBtn.titleLabel.font = [UIFont secondFont];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.paySceneManager.groupItems.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.footerHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.headerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.rowNum;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return [self payFuncHeaderView];
        
    }
    
    return nil;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 1) { //支付方式的组
        
        static NSString * payFuncCellId = @"ZHPayFuncCell";
        ZHPayFuncCell  *cell = [tableView dequeueReusableCellWithIdentifier:payFuncCellId];
        if (!cell) {
            cell = [[ZHPayFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payFuncCellId];
        }
        cell.pay = self.pays[indexPath.row];
        
        return cell;
        
    }
    
    
    //支付金额
    ZHPayInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
    
    if (!infoCell) {
        
        infoCell = [[ZHPayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
    }
    
    if (indexPath.row == 0) {
        
        infoCell.titleLbl.text = @"消费积分";
        infoCell.hidenArrow = YES;
        infoCell.infoLbl.textAlignment = NSTextAlignmentLeft;
        //        infoCell.infoLbl.attributedText = self.amoutAttr;
        infoCell.infoLbl.text = [NSString stringWithFormat:@"%@ 积分", [_rmbAmount convertToRealMoney]];
        
    }
    
    return infoCell;
    
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
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
}

@end
