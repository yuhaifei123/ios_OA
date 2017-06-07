//
//  BaoMi_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/8.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "BaoMi_ViewController.h"
#import "BaoMi_TableView.h"
#import "BaoMiDetailed_ViewController.h"


@interface BaoMi_ViewController ()<BaoMi_TableViewDelegate,DJRefreshDelegate>

@property (weak, nonatomic) IBOutlet BaoMi_TableView *tableView_BaoMi;

@property (nonatomic,strong) DJRefresh *refresh;//下拉刷新

@end

@implementation BaoMi_ViewController

static  int yeShu = 1;
static int int_CellId = 0;//cell回来的ID，详细请求参数

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self getHttp];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self add_View];
    [self add_dropDownRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -- 添加view属性
/**
 * 添加view属性
 */
-(void) add_View{

    self.tableView_BaoMi.baoMiDelegate = self;
    self.tableView_BaoMi.delegate = self.tableView_BaoMi;
    self.tableView_BaoMi.dataSource = self.tableView_BaoMi;
}

#pragma  mark -- 下拉刷新
/**
 *  下拉刷新
 */
-(void) add_dropDownRefresh{

    _refresh=[[DJRefresh alloc] initWithScrollView:self.tableView_BaoMi delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

#pragma mark -- 请求网络数据
/**
 *  请求网络数据
 */
-(void) getHttp{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util baoMi_List];

    NSString  *pinJie = @"functionCode=206002&type=sp";

    //返回，dic数据
    NSDictionary *dic = [http getHttpPinJie_JiaZai:pinJie Util:util_string];

    if (dic) {

        //NSLog(@"%@",dic);
        self.tableView_BaoMi.dic_BaoMiTableViewData = dic;
    }
}

#pragma  mark -- BaoMi_TableViewDelegate
//cell点击回调
-(void) BaoMiTableView_ClockCell:(int)cell{

    int_CellId = cell;

    [self performSegueWithIdentifier:@"DETAILED" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    BaoMiDetailed_ViewController *baoMiDetailed_ViewController = segue.destinationViewController;
    self.delegatea = baoMiDetailed_ViewController;

    if ([self.delegatea respondsToSelector:@selector(BaoMiViewControllerDelegate_Id:)]) {

        [self.delegatea BaoMiViewControllerDelegate_Id:int_CellId];
    }
}

#pragma  mark -- 下拉刷新代理
/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [[self.tableView_BaoMi.dic_BaoMiTableViewData mutableCopy] removeAllObjects];
    //请求数据
    [self getHttp];

    [self.tableView_BaoMi reloadData];
}

/**
 刷新代理方法
 */
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
}

- (void)addDataWithDirection:(DJRefreshDirection)direction{
    [_refresh finishRefreshingDirection:direction animation:YES];

    if (direction==DJRefreshDirectionTop) {
        [self reloadData];
    }else{
        [self reloadData];
    }
}

@end
