//
//  LiChangBeiAn_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "LiChangBeiAn_ViewController.h"
#import "FaWen_TableViewCell.h"
#import "LiChangNeiRong_ViewController.h"
#import "RefreshControl.h"
#import "DJRefresh.h"


@interface LiChangBeiAn_ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DJRefreshDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ganBuLiChang_Table;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong)RefreshControl * refreshControl;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong)DJRefresh *refresh;

@end

@implementation LiChangBeiAn_ViewController

static  NSString *ID = @"fawen";
static  int cellId;//选中第几个cell
static  int yeShu = 1;

- (NSMutableArray *) array{

    if(_array == nil){
        _array = [NSMutableArray array];
    }

    return  _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //[self souSuoKuangAll_Id:self];

    self.ganBuLiChang_Table.delegate = self;
    self.ganBuLiChang_Table.dataSource = self;
    //显示多少列，uitableView
    self.ganBuLiChang_Table.tableFooterView = [[UIView alloc] init];
    //不自动，定位大小
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//界面将要打开
-(void) viewWillAppear:(BOOL)animated{

    _refresh=[[DJRefresh alloc] initWithScrollView:self.ganBuLiChang_Table delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

/*********************************  基本方法 *******************************/
#pragma  mark -- 基本方法
#pragma mark -- 请求网络数据
/**
 *  请求网络数据
 */
-(NSDictionary *) getHttpType:(NSString *)type PageIndex:(NSString *)page{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util ganBuLiChangList];

    NSString  *pinJie = [NSString stringWithFormat:@"listtype=%@&PageIndex=%@",type,page];
    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 添加搜索框的方法
 */
-(void) souSuoKuangAll_Id:(id)all_Id{

    /*************  添加搜索框 ************/
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, 100,28)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = all_Id;

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:searchButton];
}

/*********************************  代理方法 *******************************/
#pragma  mark -- 代理方法

/**
    用户点击键盘search按键以后，关闭键盘
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    //失去第一响应者
    [searchBar resignFirstResponder];
}

/**
  scrollView 开始拖动 uitableView继承scrollView 可以调用scrollVie的代理
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    //失去第一响应者
    [self.searchBar resignFirstResponder];
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
        [self reloadData_Xia];
    }
    
    
}

/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [self.array removeAllObjects];

    //请求数据
    NSDictionary *dic = [self getHttpType:@"bl" PageIndex:@"1"];
    self.array = [dic[@"list"] mutableCopy];

    [self.ganBuLiChang_Table reloadData];


    yeShu = 1;
}

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Xia{

    yeShu ++;

    //请求数据
    NSDictionary *dic = [self getHttpType:@"b1"PageIndex:[NSString stringWithFormat:@"%d",yeShu]];

    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] intValue] < 0 ) {

        [IanAlert alertError:dic_message[@"text"] length:1.0];
    }

    [self.array addObjectsFromArray:dic[@"list"]];

    [self.ganBuLiChang_Table reloadData];

  
}

#pragma  mark --tabele代理
/**
 *  几组
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  1;
}

/**
 *  一组有多少(row)
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int a = (int)indexPath.row;
    NSDictionary *dic = self.array[a];
    FaWen_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    cell.biaoTi_Text.text = dic[@"NGR"];
    cell.shenHe_Text.text =  dic[@"LCNAME"];
    cell.hao_Text.text =dic[@"NGTIME"];
    cell.diZhi_Text.text = dic[@"MDD"];

//    NSString *SWTIME = [dic[@"NGTIME"] substringToIndex:11];
    cell.shiJian_Text.text = @"";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    cellId = (int) indexPath.row;
    [self performSegueWithIdentifier:@"lichang" sender:nil];
    //失去第一响应者
    [self.searchBar resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    LiChangNeiRong_ViewController *qnv = segue.destinationViewController;
    self.delegate = qnv;

    NSDictionary *dic = self.array[cellId];
    [self.delegate addDic:dic];
}

/*********************************  工具方法 *******************************/
#pragma  mark -- 工具方法

@end
