//
//  AllList_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/4.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "AllList_ViewController.h"
#import "AllList_TableViewCell.h"
#import "AllDetailed_ViewController.h"

@interface AllList_ViewController ()<DJRefreshDelegate>

@property (nonatomic,strong) DJRefresh *refresh;//下拉刷新

@end

@implementation AllList_ViewController

static NSString *CELLID = @"ALLLIST";

/** 点击了第几个cell */
static int int_ClickCellNO = 0;

/************* 懒加载 **************/
-(NSArray *) array_TableList{

    if (_array_TableList == nil) {

        _array_TableList = [NSArray array];
    }
    return _array_TableList;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self add_View];
    [self add_GetHttp];
}

/**
 *  在控制器init，调用，界面即将出现
 *
 *  @param animated <#animated description#>
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD hideHUD];

    [self add_dropDownRefresh];
}

#pragma  mark -- view属性设置
/**
 * view属性设置
 */
-(void) add_View{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma  mark -- 请求网络参数设置
/**
 * 请求网络参数设置
 *
 *  @param functioncode 请求网络要的参数
 *  @param util         请的路径
 */
-(void) add_GetHttpData_Functioncode:(NSString *(^)())functioncode Util:(NSString *(^)())util{

    self.functioncode = functioncode();
    self.util_string = util();
}

#pragma  mark -- 请求网络数据
/**
 * 请求网络数据
 */
-(void) add_GetHttp{

    GetHttp *http = [[GetHttp alloc] init];

    NSString *util_string = self.util_string;

    NSString  *pinJie =self.functioncode;

    //返回，dic数据
    NSDictionary *dic = [http getHttpPinJie_JiaZai:pinJie Util:util_string];

    //请求正确
    NSDictionary *dic_message = dic[@"message"];
    if ([dic_message[@"code"] isEqualToString:@"0"]) {

        self.array_TableList = dic[@"list"];
    }else{

        [IanAlert alertError:@"没有数据" length:1.0];
    }
}

/********************* 下拉刷新 ******************/
#pragma  mark -- 下拉刷新
/**
 *  下拉刷新
 */
-(void) add_dropDownRefresh{

    _refresh=[[DJRefresh alloc] initWithScrollView:self.tableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
}

#pragma  mark -- 下拉刷新代理
/**
 刷新代理方法 (添加数据) 上
 */
-(void)reloadData{

    [[self.array_TableList mutableCopy] removeAllObjects];

    [self add_GetHttp];
    [self.tableView reloadData];
}

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Down{

    int  int_PageIndex = self.PageIndex.intValue;
    int_PageIndex  = int_PageIndex + 1;
    self.PageIndex = [NSString stringWithFormat:@"%d",int_PageIndex];
       
    [self.tableView reloadData];
}

/**
 刷新代理方法
 */
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
}

- (void)addDataWithDirection:(DJRefreshDirection)direction{
    [_refresh finishRefreshingDirection:direction animation:YES];

    if (direction==DJRefreshDirectionTop) {
        [self reloadData];

    }else{
        [self reloadData_Down];
    }
}

/********************* uitableView 代理 ******************/
#pragma  mark -- uitableView 代理
//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置多少组
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array_TableList.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AllList_TableViewCell *allList_TableViewCell = [tableView dequeueReusableCellWithIdentifier:CELLID];

    if (allList_TableViewCell == nil){
        allList_TableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AllList_TableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
     allList_TableViewCell.dic_TableCell = self.array_TableList[(int)indexPath.row];
    return allList_TableViewCell;
}

//行高
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

/**
 *
 * 点击以后，触发的事件<#indexPath description#>
 *  @param tableView <#tableView description#>
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     int_ClickCellNO = (int)indexPath.row;

     [self performSegueWithIdentifier:self.segueId sender:nil];
}

//跳转
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    AllDetailed_ViewController<AllListDelegate> *allDetailed_ViewController = segue.destinationViewController;
    self.delegate = allDetailed_ViewController;

    if ([self.delegate respondsToSelector:@selector(AllList_Dic:Dic_Table:)]) {

        NSDictionary *dic = self.array_TableList[int_ClickCellNO];
        NSDictionary *dic_Table = [NSDictionary dictionaryWithObjectsAndKeys:self.TABLENAME,@"tableName",self.FLOWNAME,@"flowName",nil];
        [self.delegate AllList_Dic:dic Dic_Table:dic_Table];
    }
    
}

@end
