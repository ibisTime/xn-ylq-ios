//
//  TLBaseVC.m
//  WeRide
//
//  Created by  蔡卓越 on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLBaseVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface TLBaseVC ()

@property (nonatomic, strong) UILabel *placeholderTitleLbl;

@property (nonatomic, strong) UIButton *opBtn;

@end

@implementation TLBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)setTitle:(NSString *)title {

    self.navigationItem.titleView = [UILabel labelWithTitle:title];
}

- (void)removePlaceholderView {
    
    if (self.tl_placeholderView) {
        
        [self.tl_placeholderView removeFromSuperview];
        
    }
    
}

- (void)addPlaceholderView{
    
    if (self.tl_placeholderView) {
        
        [self.view addSubview:self.tl_placeholderView];
        
    }
    
}

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)opTitle {
    
    if (self.tl_placeholderView) {
        
        _placeholderTitleLbl.text = title;
        [_opBtn setTitle:opTitle forState:UIControlStateNormal];
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(16) textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        lbl.text = title;
        _placeholderTitleLbl = lbl;
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(14);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        _opBtn = btn;
        _tl_placeholderView = view;
        
    }
    
}

- (UIView *)tl_placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle {
    
    if (!_tl_placeholderView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:18.0];
        
        lbl.frame = CGRectMake(0, 100, view.width, 50);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        
        [view addSubview:lbl];
        lbl.text = title;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(tl_placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        
        _tl_placeholderView = view;
    }
    return _tl_placeholderView;
    
}

- (void)showReLoginVC {
    
    TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark- 站位操作
- (void)tl_placeholderOperation {

    if ([self isMemberOfClass:NSClassFromString(@"TLBaseVC")]) {
        
        NSLog(@"子类请重写该方法");
        
    }

}

- (UIView *)tl_placeholderView {

    if (_tl_placeholderView) {
        
        return _tl_placeholderView;
    } else {
        
        ;
        NSLog(@"请先调用%@ 进行初始化",NSStringFromSelector(@selector(tl_placholderViewWithTitle:opTitle:)));

        return nil;
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告 …%@",[self class]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
