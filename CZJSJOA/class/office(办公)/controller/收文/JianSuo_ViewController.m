//
//  JianSuo_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/26.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "JianSuo_ViewController.h"
#import "shouWenDaiYue_TableViewCell.h"
#import "AFPopupView.h"
#import "ShouFaWenJianSuo_ViewController.h"
#import "RefreshControl.h"
#import "DJRefresh.h"
#import "FaWen_TableViewCell.h"
#include "JianSuo_ShouWen_XiangQing_ViewController.h"

@interface JianSuo_ViewController ()<UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *jianSuo_TableView;

@property (weak, nonatomic) IBOutlet UIButton *chaZhao_Button;
@property (retain, strong) ShouFaWenJianSuo_ViewController *modalTest;
@property (nonatomic, strong) AFPopupView *popup;
@property NSString *biaoTi;
@property NSString *wenHao;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong)RefreshControl * refreshControl;
@property (nonatomic,strong)DJRefresh *refresh;
@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation JianSuo_ViewController

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

    _biaoTi = @"";
    _wenHao = @"";

    self.automaticallyAdjustsScrollViewInsets = NO;
    //显示多少列，uitableView
    self.jianSuo_TableView.tableFooterView = [[UIView alloc] init];

    self.jianSuo_TableView.delegate = self;
    self.jianSuo_TableView.dataSource = self;
    
    //pupwindow
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    _modalTest = [storyboard instantiateViewControllerWithIdentifier:@"shoufawenjiansuo"];
    
    [_chaZhao_Button addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hide) name:@"HideAFPopup" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{

    _refresh=[[DJRefresh alloc] initWithScrollView:self.jianSuo_TableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

/***************** 基本方法 **************/
#pragma  mark -- 基本方法

-(void)go {
    
    _popup = [AFPopupView popupWithView:_modalTest.view];
    [_popup show:self.view];
}

-(void)hide {
    
    _biaoTi = _modalTest.biaoTi;
    _wenHao = _modalTest.wenHao;

    [self reloadData];
    [_popup hide];
}

/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [self.array removeAllObjects];

    //请求数据
    NSDictionary *dic = [self getHttpType:@"bl" PageIndex:@"1" TITLE:@""];;
    self.array = [dic[@"list"] mutableCopy];

    [self.jianSuo_TableView reloadData];

    yeShu = 1;
}

#pragma mark -- 请求网络数据
/**
 *  请求网络数据
 */
-(NSDictionary *) getHttpType:(NSString *)type PageIndex:(NSString *)page TITLE:(NSString *)title{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util shouWen_JianSuo];

    NSString  *pinJie = [NSString stringWithFormat:@"PageIndex=%@&LWH=%@&TITLE=%@",page,self.wenHao,self.biaoTi];


    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

/***************** 代理方法 **************/
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
 *  搜索框，方法代理
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self.array removeAllObjects];
    //请求数据
    NSDictionary *dic = [[self getHttpType:@"bl" PageIndex:@"1" TITLE:searchText] mutableCopy];

    self.array = [dic[@"list"] mutableCopy];

    //判断有没有数据
    if ((int)self.array.count == 0) {

        [IanAlert alertError:@"没有数据" length:1.0];
    }
    [self.jianSuo_TableView reloadData];
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
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Xia{

    yeShu ++;

    //请求数据
    NSDictionary *dic = [self getHttpType:@"bl" PageIndex:[NSString stringWithFormat:@"%d",yeShu] TITLE:@""];;

    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] intValue] < 0 ) {

        [IanAlert alertError:dic_message[@"text"] length:1.0];
    }

    [self.array addObjectsFromArray:dic[@"list"]];
    
    [self.jianSuo_TableView reloadData];
    
}


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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell_Id = indexPath.row;
    //shouwenjiansuoxiangqing
    [self performSegueWithIdentifier:@"shouwenjiansuoxiangqing" sender:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSString *segue_String = segue.identifier;

        NSDictionary *dic = self.array[cell_Id];

        //代理
        JianSuo_ShouWen_XiangQing_ViewController  *dai = segue.destinationViewController;
        self.delegate = dai;

        [self.delegate addDic:dic];
}

/***************** 工具方法 **************/
#pragma  mark -- 工具方法

@end
