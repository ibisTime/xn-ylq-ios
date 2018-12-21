//
//  HistoryInviteVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HistoryInviteVC.h"

#import "HistoryFriendCell.h"
#import "TLTableView.h"
#import "InviteModel.h"

@interface HistoryInviteVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <InviteModel *>*friends;

@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation HistoryInviteVC

static NSString *identifierCell = @"HistoryFriendCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐历史";
    
    [self initTableView];
    
    [self requestFriendList];
}

#pragma mark - Init
- (void)initTableView {

    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
//    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无推荐历史"];
    
    [self.tableView registerClass:[HistoryFriendCell class] forCellReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.tableView];
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"推荐历史");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"暂无推荐历史" textColor:kTextColor textFont:15];
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [self.view addSubview:self.placeHolderView];
}

#pragma mark - Data
- (void)requestFriendList {

    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805120";
    helper.parameters[@"userReferee"] = [TLUser user].userId;
//    helper.parameters[@"token"] = [TLUser user].token;

    helper.tableView = self.tableView;

    [helper modelClass:[InviteModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        if (objs.count == 0) {
            [self initPlaceHolderView];
            return ;
        }
        weakSelf.friends = objs;
        
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                [self initPlaceHolderView];
                return ;
            }
            weakSelf.friends = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.inviteModel = self.friends[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
