//
//  CaiLiao_TableViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "CaiLiao_TableViewController.h"
#import "Cailiao_TableViewCell.h"
#import "GetHttp.h"
#import "Util.h"
#import "TongZhiBean.h"
#import "Office_TableViewController.h"
#import "CaiLIaoWeb_ViewController.h"
#import "IanAlert.h"
#import "RefreshControl.h"//下拉刷新
#import "DJRefresh.h"
#import "DaiBan_ViewController.h"
#import "Home_ViewController.h"


@interface CaiLiao_TableViewController ()<Office_TableViewControllerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate,DaiBan_ViewControllerDelegate,Home_ViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *caiLiao_TableView;

@property (nonatomic,assign) int y ,add_DaiYue_SelectY;
@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) LoadMoreTableFooterView *loadMoreFooterView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong)RefreshControl * refreshControl;
@property (nonatomic,strong)DJRefresh *refresh;

@property int currentpageno;

@end

@implementation CaiLiao_TableViewController

static  NSString *ID = @"cailiao";
static int a = 0;
static  int yeShu = 1;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.caiLiao_TableView.delegate = self;
    self.caiLiao_TableView.dataSource = self;

    [self souSuoKuangAll_Id:self];

    //显示多少列，uitableView
    self.caiLiao_TableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  在控制器init，调用，界面即将出现
 *
 *  @param animated <#animated description#>
 */
- (void)viewDidAppear:(BOOL)animated{
    

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    _refresh=[[DJRefresh alloc] initWithScrollView:self.caiLiao_TableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];

}

/*********************************  基本方法 *******************************/
#pragma  mark -- 基本方法
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

#pragma  mark -- 搜索框，方法
/**
 *  搜索框，方法
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    TongZhiBean *tongZhi = [[TongZhiBean alloc] init];
    //把userid 放到缓存里面去
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    tongZhi.gsUSERID = [as stringForKey:@"userid"];
    tongZhi.PageIndex = @"1";
    tongZhi.TITLE = searchText;

    NSDictionary *dic = [self addDataTongZhiBean:tongZhi secect:1];
    NSDictionary *dic_02 = dic[@"message"];
    NSString *code = dic_02[@"code"];

    if([code intValue] < 0){
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"没有数据" length:abcd];
        return;
    }
    [self.array removeAllObjects];
    self.array = [dic[@"list"] mutableCopy];
    [self.caiLiao_TableView reloadData];

    
}

/**self.add_DaiYue_SelectY
 *  添加数据
 * secect (0= 一般的样子，1 = 搜索)
 //  y 0 材料  没
 //  y 1 材料  有
 //   y 2 通知  没
 //   y 3 通知  有
 */
-(NSDictionary *) addDataTongZhiBean:(TongZhiBean *)tongZhiBean secect:(int)secect{

    GetHttp *http = [[GetHttp alloc] init];

    //2 是没有阅读
    if(self.y == 2 ){
        tongZhiBean.state = @"sjx";
        self.title = @"未读材料";
    }else if (self.y == 3 ){
        tongZhiBean.state = @"yyx";
        self.title = @"已读材料";
    }else if (self.y == 0 ){
        tongZhiBean.state = @"dy";
        
        self.title = @"未阅通知";

    }else{
        tongZhiBean.state = @"yy";
        self.title = @"已阅通知";
    }

    Util *util = [[Util alloc] init];
    NSString *util_String;
    NSString *pinJie;
    if(self.y == 2 || self.y == 3){

        util_String= [util caiLiao_List];
        pinJie = [NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&type=%@&TITLE=%@",tongZhiBean.gsUSERID,tongZhiBean.PageIndex,tongZhiBean.state,tongZhiBean.TITLE];
    }else{

        util_String = [util tongZhi];
        pinJie = [NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&state=%@&TITLE=%@",tongZhiBean.gsUSERID,tongZhiBean.PageIndex,tongZhiBean.state,tongZhiBean.TITLE];
    }

    return (secect == 0) ? [http getHttpPinJie_JiaZai:pinJie Util:util_String] : [http SearchPinJie:pinJie Util:util_String];
}



/*********************************  代理方法 *******************************/
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
 代办事项
 */
-(void) add_DaiYue_SelectY:(int)y{
    
    _y= y;
}

/**
 首页代理
 */
-(void) addHomeSelect_Y:(int)y{

    _y = y;
}

/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [self.array removeAllObjects];

    TongZhiBean *tongZhi = [[TongZhiBean alloc] init];
    //把userid 缓存里面拿出来
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    tongZhi.gsUSERID = [as stringForKey:@"userid"];
    tongZhi.PageIndex = @"1";
    tongZhi.TITLE = @"";

    //请求数据
    //得到网络返回数据
    NSDictionary *dic = [self addDataTongZhiBean:tongZhi secect:0];
    //得到字典里面的数据(判读是不是有数据)
    NSDictionary *dic_01 = dic[@"message"];
    NSString *code = [NSString stringWithFormat:@"%@",dic_01[@"code"]];
    int code_int = [code intValue];
    
    if(code_int > -1){
        
        self.array = [dic[@"list"] mutableCopy];
    }else{
        
        [IanAlert alertError:@"暂无数据" length:1.0];
    }

    [self.caiLiao_TableView reloadData];

    yeShu = 1;
}

/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData_Xia{

    yeShu ++;

    TongZhiBean *tongZhi = [[TongZhiBean alloc] init];
    //把userid 缓存里面拿出来
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    tongZhi.gsUSERID = [as stringForKey:@"userid"];
    tongZhi.PageIndex = [NSString stringWithFormat:@"%d",yeShu];
    tongZhi.TITLE = @"";

    //请求数据
    //得到网络返回数据
    NSDictionary *dic = [self addDataTongZhiBean:tongZhi secect:0];
    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] intValue] < 0 ) {

        [IanAlert alertError:dic_message[@"text"] length:1.0];
    }

    [self.array addObjectsFromArray:dic[@"list"]];

    [self.caiLiao_TableView reloadData];
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

#pragma mark - Table view data source
/**
 *  几组
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.array == nil) {
        return 0;
    }else{
        return 1;
    }
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
    Cailiao_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    NSDictionary *dic = self.array[indexPath.row];

    cell.title_Text.text = dic[@"TITLE"];
    cell.name_Text.text = dic [@"NGR"];
    cell.time_Text.text = dic[@"NGTIME"];

    return cell;
}

/**
 *  选择
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    a = (int)indexPath.row;

    [self performSegueWithIdentifier:@"cailiaoWeb" sender:nil];
    //失去第一响应者
    [self.searchBar resignFirstResponder];
}

/**
 *  segue调用的方法
 *
 *  @return <#return value description#>
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    //目标view
    CaiLIaoWeb_ViewController *web= segue.destinationViewController;
    //他实现代理
    self.delegate = web;

    // 判断是不是实现了某个方法
    if([self.delegate respondsToSelector:@selector(addId:Y:)]){

       NSDictionary *dic = self.array[a];
        NSString *ID  = dic[@"ID"];

        [self.delegate addId:ID Y:self.y];
    }

}

#pragma  mark -- office 代理

- (void) selectY:(int)y{

    self.y = y;
}

@end
