//
//  YiZhouAnPai_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/26.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "YiZhouAnPai_ViewController.h"
#include "YiZhouDaiBan_TableViewCell.h"
#import "Util.h"
#import "RefreshControl.h"
#import "DJRefresh.h"
#import "QuickLookVC.h"
#import "ReadWriteData.h"
#import "DownloadData.h"

@interface YiZhouAnPai_ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DJRefreshDelegate,DownloadDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *yiZhouAnPai_TableView;//一周安排——tableView
@property (nonatomic,strong) UISearchBar *searchBar;


@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong)DJRefresh *refresh;
@property (nonatomic,copy) NSString *mingZi;

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@property (nonatomic,strong) ReadWriteData *readWriteData;
@property (nonatomic,strong) DownloadData *downloadData;//下载文件
@end

@implementation YiZhouAnPai_ViewController

static  NSString *ID = @"yizhouanpai";
static  int yeShu = 1;

-(ReadWriteData *) readWriteData{

    if (_readWriteData == false) {

        _readWriteData = [[ReadWriteData alloc] init];
    }
    return  _readWriteData;
}

-(DownloadData *)downloadData{

    if (_downloadData == false) {

        _downloadData = [[DownloadData alloc] init];
    }

    return _downloadData;
}

-(NSArray *) array_table{

    if (_array == nil) {

        _array = [NSArray array];
    }

    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //显示多少列，uitableView
    self.yiZhouAnPai_TableView.tableFooterView = [[UIView alloc] init];

    [self souSuoKuangAll_Id:self];

    self.yiZhouAnPai_TableView.delegate = self;
    self.yiZhouAnPai_TableView.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    _refresh=[[DJRefresh alloc] initWithScrollView:self.yiZhouAnPai_TableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**************** 基本方法 **************/
#pragma  mark -- 基本方法

/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [self.array removeAllObjects];

    //请求数据
    NSDictionary *dic = [self getHttpPageIndex:@"1" TITLE:@""];
    self.array = [dic[@"list"] mutableCopy];

    [self.yiZhouAnPai_TableView reloadData];

    yeShu = 1;
}

/**
 *  请求网络数据
 */
-(NSDictionary *) getHttpPageIndex:(NSString *)page TITLE:(NSString *)title{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util yiZhouBanLi];

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *remember = [as stringForKey:@"userid"];

    NSString  *pinJie = [NSString stringWithFormat:@"PageIndex=%@&gsUSERID=%@&TITLE=%@",page,remember,title];

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/*************  下载的用法 ************/

/**
 拼接下载路径
 */
- (NSString *) pinJie_XiaZaiLiuJin:(NSString *)liuJin{

    if (![liuJin isEqualToString:@""]) {
        Util *url =[[Util alloc]init];

        return [NSString stringWithFormat:@"%@app/tt_downloadfile.do?filename=%@&downname=%@.doc&path=&uploadtype=doc",[url yuanShi],liuJin,liuJin];
    }

    return @"";
}

/**
  下载的用法(button点击监听)
 */
-(void)xiaZai_Button_Click:(id)sender {

    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.yiZhouAnPai_TableView indexPathForCell:cell];

    int a = (int)path.row;
    [self downloadDataRow:a];
   }


/**
 现在数据

 @param row <#row description#>
 */
-(void)downloadDataRow:(int)row{

    NSDictionary *dic = self.array[row];

    NSString *pingJie = [NSString stringWithFormat:@"%@",dic[@"RECORDID"]];

    if ([pingJie isEqualToString:@""]) {

        [IanAlert alertError:@"没有数据" length:1.0];
        return;
    }

    //拼接下载路径
    NSString *pingJie_all = [self pinJie_XiaZaiLiuJin:pingJie];

    self.downloadData.delegate = self;
    //下载数据，显示数据
    [self.downloadData downloadDataFilePath:pingJie_all VC:self];

}

/**************** 代理方法 **************/
#pragma  mark -- 代理方法

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
    //NSDictionary *dic = [self getHttpType:@"bl" PageIndex:[NSString stringWithFormat:@"%d",yeShu] TITLE:@""];;
    NSDictionary *dic = [self getHttpPageIndex:[NSString stringWithFormat:@"%d",yeShu] TITLE:@""];

    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] intValue] < 0 ) {

        [IanAlert alertError:dic_message[@"text"] length:1.0];
    }

    [self.array addObjectsFromArray:dic[@"list"]];

    [self.yiZhouAnPai_TableView reloadData];
}

/**
 *  搜索框，方法代理
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self.array removeAllObjects];
    //请求数据
    NSDictionary *dic = [[self getHttpPageIndex:@"1" TITLE:searchText] mutableCopy];

    self.array = [dic[@"list"] mutableCopy];

    //判断有没有数据
    if ((int)self.array.count == 0) {

        [IanAlert alertError:@"没有数据" length:1.0];
    }
    [self.yiZhouAnPai_TableView reloadData];
}

/**
 用户点击键盘search按键以后，关闭键盘
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    //失去第一响应者
    [searchBar resignFirstResponder];
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

/**
 * cell 设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int a = (int)indexPath.row;
    NSDictionary *dic = self.array[a];

    YiZhouDaiBan_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    cell.biaoTi_Text.text = dic[@"TITLE"];
    self.mingZi = dic[@"TITLE"];
    cell.mingzi_Text.text = dic[@"NGR"];
    cell.shiJian_Text.text = [self string_JieQuString:[NSString stringWithFormat:@"%@",dic[@"NRTIME"]] NumBer:11];
   // cell.xiaZaiDiZhi = dic[@"TITLE"];//[NSString stringWithFormat:@"%@",dic[@"RECORDID"]];
    [cell.xiaZai_Button addTarget:self action:@selector(xiaZai_Button_Click:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

/**
  cell 点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  //  [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    [self downloadDataRow:(int)indexPath.row];
}

/**
 cell 点击以后消失阴影
 */
- (void)deselect{

    [self.yiZhouAnPai_TableView deselectRowAtIndexPath:[self.yiZhouAnPai_TableView indexPathForSelectedRow] animated:YES];
}
/**************** 工具方法 **************/
#pragma  mark -- 工具方法

/**
 正文的拼接和超链接
 */
- (void) zhenWenString:(NSString *)string{

    NSString *pingJie;

    //判断nil
    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""]) {

        Util *util = [[Util alloc] init];
        NSString *xiaZai = [util xiaZai];

        pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<a href='",xiaZai,@"?filename=",string,@"&downname=",string,@".doc&path=&uploadtype=doc'>",string,@".doc</a><br>"];
    }
}

/**
 string 截取 nr 前面的几位 不包括nr位
 */
- (NSString *) string_JieQuString:(NSString *)string NumBer:(int)nr{
    if (string.length < nr) {
        return @"";
    }
    return  [string substringToIndex:nr];
}

/**
 得到当前时间
 */
-(NSString *) shiJian_DangQian{

    NSDate *date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];

    return  [formatter stringFromDate:date];
}

/**
 string判断是不是null
 */
- (NSString *) String_PanDuanFeiKongString:(NSString *)string{

    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""] && ![string isEqualToString:@"\n"] && ![string isEqualToString:@"\r"] && ![string isEqual:@""] && string.length != 0) {

        return string;
    }
    return @"";
}

-(BOOL)getData:(NSMutableData *)data{

    return true;
}

@end
