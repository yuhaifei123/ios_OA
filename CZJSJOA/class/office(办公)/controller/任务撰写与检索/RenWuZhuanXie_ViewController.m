//
//  RenWuZhuanXie_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/24.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "RenWuZhuanXie_ViewController.h"
#import "RenWuZhuanXie_TableViewCell.h"
#import "RenWuZhuanXieTianJia_ViewController.h"
#import "Office_TableViewController.h"
#import "RefreshControl.h"//刷新_02
#import "IanAlert.h"
#import "DJRefresh.h"
#import "DaiBan_ViewController.h"
#import "Home_ViewController.h"

@interface RenWuZhuanXie_ViewController ()<UISearchBarDelegate,RenWuZhuanXie_TableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,DJRefreshDelegate,DaiBan_ViewControllerDelegate,Home_ViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *rengWuChuanXie_tableView;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) GetHttp *http;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,assign) SELECT selecY;//判断是不是，任务撰写 4，任务检索 5
@property (nonatomic,assign) int add_DaiYue_SelectY;
@property (weak, nonatomic) IBOutlet UITableView *renWu_TableView;
@property (nonatomic,strong)RefreshControl * refreshControl;
@property (nonatomic,strong)DJRefresh *refresh;

@end

@implementation RenWuZhuanXie_ViewController

static NSString *ID =@"renwu";
static  int yeShu = 1;

-(NSMutableArray *)array{

    if (_array == nil) {

        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*************  添加搜索框 ************/
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, 100,28)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.renWu_TableView.delegate = self;
    self.renWu_TableView.dataSource = self;

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    //添加按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton)];

    NSArray *array = nil;

    //判断是不是，检索 == 5，撰写 == 4
    if (self.selecY == RWZX) {

        array = [NSArray arrayWithObjects:searchButton,leftButton,nil];
        self.title= @"任务撰写";
    }else {

        self.title = @"任务检索";
        array = [NSArray arrayWithObjects:searchButton,nil];
    }

    self.navigationItem.rightBarButtonItems = array;

    self.renWu_TableView.tableFooterView = [[UIView alloc] init];//这个是，有多少cell，就多少cell
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    _refresh=[[DJRefresh alloc] initWithScrollView:self.renWu_TableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

/*********************** 基本方法 *******************/
#pragma mark -- 基本方法

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

/**
 *  在控制器init，调用，界面即将出现
 *
 *  @param animated <#animated description#>
 */
- (void)viewDidAppear:(BOOL)animated{

    [self reloadData];
}

/** 
  添加按钮，跳转
 */
- (void) addButton {

    NSNumber *ber = [NSNumber numberWithInt:-1];//int转nsnumber

    [self performSegueWithIdentifier:@"renwutianjia" sender:ber];
    [self.renWu_TableView reloadData];
}

/**
 *  服务器申请数据
 *
 *  @return
 */
- (NSDictionary *) addDataPage:(NSString *)page RW:(NSString *)rw Type:(NSString *)type{

    //添加数据
    self.http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    NSString *util_String = [util chuanXie_List];
    //把userid 放到缓存里面去
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    NSString *gsUSERID = [as stringForKey:@"userid"];

    NSString *pinJie = [NSString stringWithFormat:@"PageIndex=%@&RW=%@&type=%@&gsUSERID=%@",page,rw,type,gsUSERID];
 
   // return [self.http getHttpPinJie:pinJie Util:util_String];
    return [self.http getHttpPinJie_JiaZai:pinJie Util:util_String];
}

/**
 *  删除服务器申请数据
 *
 *  @return
 */
- (NSDictionary *) shanChuListId:(NSString *)id{

    //添加数据
    self.http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    NSString *util_String = [util shanChu];

    NSString *pinJie = [NSString stringWithFormat:@"tablename=%@&doubletab=%@&fid=%@&isdel=%@&id=%@",@"OA_INFO_RWJB_XX",@"OA_INFO_RWJB_YBYJ",@"id",@"1",id];

    return [self.http getHttpPinJie_JiaZai:pinJie Util:util_String];
}

/**
 *  判断服务器回来有没有数据
 *  @param dic <#dic description#>
 */
- (void) panDuanDic:(NSDictionary *)dic byBz:(NSString *)bz{

    //得到字典里面的数据(判读是不是有数据)
    NSDictionary *dic_01 = dic[@"message"];
    NSString *code = [NSString stringWithFormat:@"%@",dic_01[@"code"]];
    int code_int = [code intValue];

    if(code_int > -1){
        if ([bz isEqual:@"1"]) {
            self.array  = [dic[@"list"] mutableCopy];
        }else{
            [self.array addObjectsFromArray:dic[@"list"]];
        }
        
    }else{
 if ([bz isEqual:@"1"]) {
        [IanAlert alertError:@"暂无数据" length:1.0];
 }
    }

    [self.renWu_TableView reloadData];
}

/*********************** 代理方法 *******************/
#pragma mark -- 代理方法

/**
  首页数据代理
 */
-(void) addHomeSelect_Y:(SELECT)y{

    _selecY = y;
}


/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [self.array removeAllObjects];

    //请求数据
    NSDictionary *dic = nil;
    //判断 撰写 == 4，检索 == 5
    if (self.selecY == RWZX) {
        
        dic = [self addDataPage:@"1" RW:@"" Type:@"sq"];
    }else{
        dic = [self addDataPage:@"1" RW:@"" Type:@"js"];
    }

    [self panDuanDic:dic byBz:@"1"];

    yeShu = 1;
}

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Xia{

    yeShu ++;

    //请求数据
    NSDictionary *dic = nil;
    //判断 撰写 == 4，检索 == 5
    if (self.selecY == RWZX) {
        
        dic = [self addDataPage:[NSString stringWithFormat:@"%d",yeShu] RW:@"" Type:@"sq"];
    }else{
        
        dic = [self addDataPage:[NSString stringWithFormat:@"%d",yeShu] RW:@"" Type:@"js"];
    }

    [self panDuanDic:dic byBz:@"2"];
}

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
 *  搜索框，方法
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    NSString *page = @"1";
    NSDictionary *dic = nil;
    //判断 撰写 == 4，检索 == 5
    if (self.selecY == RWZX) {
        dic = [self addDataPage:page RW:searchText Type:@"sq"];
    }else{
        dic = [self addDataPage:page RW:searchText Type:@"js"];
    }

    [self.array removeAllObjects];
    [self panDuanDic:dic byBz:@"1"];
    [self.renWu_TableView reloadData];
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
 *  几组
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return 1;
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

    RenWuZhuanXie_TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    [cell enableDeleteMethod:YES];
    cell.deleteDelegate = self;

    NSDictionary *dic = self.array[indexPath.row];
    cell.name_Text.text = dic[@"NGR"];
    cell.content_Text.text = dic[@"RW"];
    cell.time_Text.text = dic[@"NRTIME"];
    //判读是不是"未完成"
    NSNumber *nub = dic[@"ISWC"];
    int nub_int = [nub intValue];
    if (nub_int == 0) {
        cell.state_Text.text = @"未完成";
    }else{
        cell.state_Text.text = @"已完成";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    int a = (int)indexPath.row;
    NSNumber *ber = [NSNumber numberWithInt:a];//int转nsnumber

    [self performSegueWithIdentifier:@"renwutianjia" sender:ber];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSString *id = segue.identifier;

    if([id isEqualToString:@"renwutianjia"]){

        int a = [sender intValue];

        if (a != -1) {

            RenWuZhuanXieTianJia_ViewController *tianJian = segue.destinationViewController;
            self.delegate = tianJian;

            NSDictionary *dic = self.array[a];

            // 判断是不是实现了某个方法
            if([self.delegate respondsToSelector:@selector(addDataDic:)]){

                [self.delegate addDataDic:dic];
            }
        }

#pragma mark -- 代理，跳转添加view。 判断是不是，撰写 == 4，检索 == 5
        if ([self.delegate respondsToSelector:@selector(addType:)]) {

            [self.delegate addType:self.selecY];
        }
    }
}

#pragma  mark --  侧滑删除
- (void)deleteAction:(UITableViewCell *)cell {

    NSIndexPath* indexPath = [self.renWu_TableView indexPathForCell:cell];
    int a = (int) indexPath.row;

    NSDictionary *dic = self.array[a];
    NSDictionary *dic_01 =[self shanChuListId:dic[@"ID"]];
    NSDictionary *dic_02 = dic_01[@"message"];

    //判断是不是，删除成功
    if([dic_02[@"text"] isEqualToString:@"保存成功"]){

        //删除，第几个cell
        [self.array removeObjectAtIndex:a];
        [self.renWu_TableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }else{

        [IanAlert alertError:@"删除错误"];
    }
}

-(void) add_DaiYue_SelectY:(SELECT)y{
    
    self.selecY = y;
}

#pragma  mark -- Office_TableViewController 代理方法  判断，撰写，检索
- (void) selectY:(SELECT)y{

    self.selecY = y;
}

/*********************** 工具方法 *******************/
#pragma mark -- 工具方法

@end
