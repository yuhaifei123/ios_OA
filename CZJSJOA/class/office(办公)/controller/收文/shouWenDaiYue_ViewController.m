//
//  shouWenDaiYue_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "shouWenDaiYue_ViewController.h"
#import "shouWenDaiYue_TableViewCell.h"
#import "Office_TableViewController.h"
#import "DaiYueXiangQin_ViewController.h"
#import "RefreshControl.h"
#import "DJRefresh.h"
#import "DaiYueXiangQin_ViewController.h"
#import "DaiBan_ViewController.h"
#import "Home_ViewController.h"


@interface shouWenDaiYue_ViewController ()<UITableViewDataSource,UITableViewDelegate,Office_TableViewControllerDelegate,UISearchBarDelegate,DJRefreshDelegate,DaiYueXiangQin_ViewControllerDelegate,DaiBan_ViewControllerDelegate,Home_ViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shouWenDaiYue_TableView;//收文待阅——Table

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong)RefreshControl * refreshControl;

@property (nonatomic,assign) SELECT a;//在，办公代理里面过来值 0 == 待阅， 1 == 办理
@property (nonatomic,strong)DJRefresh *refresh;

@property (nonatomic,assign) int add_DaiYue_SelectY;
@end

@implementation shouWenDaiYue_ViewController

static  NSString *ID = @"shouwen";
static  int cell_Id;//点击了第几个cell
static  int yeShu = 1;


- (NSMutableArray *) array{

    if(_array == nil){
        _array = [NSMutableArray array];
    }

    return  _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self souSuoKuangAll_Id:self];

    self.shouWenDaiYue_TableView.delegate = self;
    self.shouWenDaiYue_TableView.dataSource = self;
    //显示多少列，uitableView
    self.shouWenDaiYue_TableView.tableFooterView = [[UIView alloc] init];
    //不自动，定位大小
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSDictionary *dic = nil;

    //a == 0待阅
    if (self.a == SWDY) {

        self.title = @"收文待阅";
        dic = [self getHttpType:@"dy" TITLE:@"" PageIndex:@"1"];
    }else{

        self.title = @"收文办理";
        dic = [self getHttpType:@"nb" TITLE:@"" PageIndex:@"1"];
    }
}

//界面将要打开
-(void) viewWillAppear:(BOOL)animated{
    
    //刷新
    _refresh=[[DJRefresh alloc] initWithScrollView:self.shouWenDaiYue_TableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

/******************* 基本方法 ****************/
#pragma  mark -- 基本方法

#pragma mark -- 请求网络数据
/**
 *  请求网络数据
 */
-(NSDictionary *) getHttpType:(NSString *)type TITLE:(NSString *)title PageIndex:(NSString *)page{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util shouWenList];

    NSString  *pinJie = [NSString stringWithFormat:@"state=%@&TITLE=%@&PageIndex=%@",type,title,@"10"];

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

/******************* 代理方法 ****************/
#pragma  mark -- 代理方法

/**
 刷新代理方法
 */

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}

/**
  代办代理
 */
-(void)add_DaiYue_SelectY:(SELECT)y{
    
    _a = y;
}

/**
 */
-(void)addHomeSelect_Y:(SELECT)y{

    _a = y;
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

    NSDictionary *dic = nil;
    //a == 0待阅
    if (self.a == SWDY) {

        self.title = @"收文待阅";
        dic = [self getHttpType:@"dy" TITLE:@"" PageIndex:@"1"];
    }else{

        self.title = @"收文办理";
        dic = [self getHttpType:@"nb" TITLE:@"" PageIndex:@"1"];
    }

    //请求数据
    self.array = [dic[@"list"] mutableCopy];

    [self.shouWenDaiYue_TableView reloadData];
    yeShu = 1;
}

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Xia{

    yeShu ++;

    //请求数据
    NSDictionary *dic = nil;
    //a == 0待阅
    if (self.a == SWDY) {

        dic = [self getHttpType:@"dy" TITLE:@"" PageIndex:[NSString stringWithFormat:@"%d",yeShu]];
    }else{

        dic = [self getHttpType:@"nb" TITLE:@"" PageIndex:[NSString stringWithFormat:@"%d",yeShu]];
    }

    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] intValue] < 0 ) {

        [IanAlert alertError:dic_message[@"text"] length:1.0];
    }
    [self.array addObjectsFromArray:dic[@"list"]];
    [self.shouWenDaiYue_TableView reloadData];

   }


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
 *  搜索框，方法代理
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self.array removeAllObjects];

    NSDictionary *dic = nil;

    if (self.a == SWDY) {

        //请求数据
        dic = [self getHttpType:@"dy" TITLE:searchText PageIndex:@"1"];
    }else{

        //请求数据
        dic = [self getHttpType:@"nb" TITLE:searchText PageIndex:@"1"];
   }

    self.array = [dic[@"list"] mutableCopy];

    //判断有没有数据
    if ((int)self.array.count == 0) {

        [IanAlert alertError:@"没有数据" length:1.0];
    }
    [self.shouWenDaiYue_TableView reloadData];
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
    shouWenDaiYue_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    cell.fuJian_Text.text = dic[@"TITLE"];
    cell.shouWen_Text.text = dic[@"LCNAME"];
    cell.hao_Text.text = dic[@"LWH"];

    NSString *SWTIME = [dic[@"SWTIME"] substringToIndex:11];
    cell.shiJian_Text.text = SWTIME;
    
    return cell;
}

#pragma  mark -- uitableView -- 选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    cell_Id = (int)indexPath.row;
  //  (self.a == 0)? (self.title = @"收文待阅"): (self.title = @"收文办理");
    if (self.a == SWDY) {

        [self performSegueWithIdentifier:@"daiyue" sender:nil];
    }else{

         [self performSegueWithIdentifier:@"banli" sender:nil];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

     NSString *segue_String = segue.identifier;

    if ([segue_String isEqualToString:@"daiyue"]) {

        NSDictionary *dic = self.array[cell_Id];

        //代理
        DaiYueXiangQin_ViewController  *dai = segue.destinationViewController;
        self.delegate = dai;

        [self.delegate addDic:dic];
    }else{

        NSDictionary *dic = self.array[cell_Id];

        //代理
        DaiYueXiangQin_ViewController  *dai = segue.destinationViewController;
        self.delegate = dai;

        [self.delegate addDic:dic];
    }
}

#pragma  mark -- 办公代理
- (void) selectY:(SELECT)y{

    self.a = y;
}

/******************* 工具方法 ****************/
#pragma  mark -- 工具方法

@end
