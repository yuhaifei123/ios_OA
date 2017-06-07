//
//  DaiBan_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/22.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "DaiBan_ViewController.h"
#import "RenWuZhuanXie_ViewController.h"
#import "shouWenDaiYue_ViewController.h"
#import "CaiLiao_TableViewController.h"
#import "DaiBan_TableViewCell.h"
#import "GetHttp.h"

@interface DaiBan_ViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *daiBan_TableView;
/** 所有图标数据  */
@property (nonatomic,strong) NSArray *array_Logo;

//任务撰写 == 1 ： == 2
@property (nonatomic,assign) int cell_XuanZhe;

@property (nonatomic,strong) NSMutableArray *array_Table;

@end

@implementation DaiBan_ViewController

static NSString  *ID = @"daibai";

#pragma  mark -- array_Logo 懒加载
-(NSArray *) array_Logo{

    if (_array_Logo == nil) {

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"plist"];
        _array_Logo = [[NSArray alloc] initWithContentsOfFile:plistPath];
    }

    return _array_Logo;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //设置title的字体大小
    CGRect rect = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = @"常州市城乡建设局综合信息平台（移动端）";
    label.font =  [UIFont fontWithName:@"Arial" size:14];

    self.navigationItem.titleView = label;

    self.daiBan_TableView.delegate = self;
    self.daiBan_TableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //显示多少列，uitableView
    self.daiBan_TableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;//TableView的自动布局不要
}

- (void)viewDidAppear:(BOOL)animated{

    [self pinJie_Array];
    [self.daiBan_TableView reloadData];
}

/**
  服务器返回的数据，拼接
 */
-(void) pinJie_Array{

    NSArray *array = (NSArray *)[self getHttp];
    NSMutableArray *array_zhong = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {

        NSMutableDictionary *dic_01 = [NSMutableDictionary dictionary];
        NSDictionary *dic = array[i];
        NSString *string_LX = dic[@"LX"];
        int int_LX = string_LX.intValue;

        switch (int_LX) {

            case 0:
                break;

            case 1:
                //没有通知
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] =@"daibancailiao";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:WYTZ];
                dic_01[@"title"] = @"未读通知";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条未阅通知",dic[@"NUM"]];
                break;

            case 2:
                dic_01[@"shuLiang"] = [NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] = @"daibancailiao";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:WDCL];
                dic_01[@"title"] = @"材料互递";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条未读材料",dic[@"NUM"]];
                break;

            case 3:
                dic_01[@"shuLiang"] = [NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] = @"daiyuerenwu";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:RWZX];
                dic_01[@"title"] = @"任务交办";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条未办任务" ,dic[@"NUM"]];
                break;

            case 4:
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] =@"daibanshouwen";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:SWDY];
                dic_01[@"title"] = @"收文待阅";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条收文待阅",dic[@"NUM"]];
                break;

            case 5:
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] =@"daibanshouwen";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:SWBL];
                dic_01[@"title"] = @"收文办理";//收文办理
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条收文待办",dic[@"NUM"]];
                break;

            case 6:
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] =@"daibanfawenbanli";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:FWBL];
                dic_01[@"title"] = @"发文待办";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条发文待办",dic[@"NUM"]];
                break;

            case 7:
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] = @"daibanqingjia";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:QJSH];
                dic_01[@"title"] = @"请假审核";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条请假审核",dic[@"NUM"]];
                break;

            case 8:
                dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
                dic_01[@"segue"] = @"daibanlichang";
                dic_01[@"xuanZe"] = [NSNumber numberWithInt:LCJS];
                dic_01[@"title"] = @"干部离常登记审核";
                dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条离常审核",dic[@"NUM"]];
                break;
                
            default:
                break;
        }

        if (int_LX > 8) {

            NSDictionary *dic_logo = self.array_Logo[int_LX-9];
            //没有通知
            dic_01[@"shuLiang"] =[NSString stringWithFormat:@"%@",dic[@"NUM"]];
            dic_01[@"segue"] =@"";
            dic_01[@"xuanZe"] =@"0";
            dic_01[@"title"] = dic_logo[@"text"];
            dic_01[@"text"] = [NSString stringWithFormat:@"您有%@条未阅通知",dic[@"NUM"]];
            dic_01[@"SBname"] = dic_logo[@"SBname"];
            dic_01[@"CVname"] = dic_logo[@"CVname"];
        }

        [array_zhong addObject:dic_01];
    }

    self.array_Table = [NSMutableArray array];
    for ( int i = 0 ; i < array_zhong.count; i ++) {

            NSDictionary *dic = array_zhong[i];
            NSString *string_shuLiang = dic[@"shuLiang"];

                if (![string_shuLiang isEqualToString:@"0"]) {

                    [self.array_Table addObject:dic];
                    [self.daiBan_TableView reloadData];
            }
    }
}

#pragma  mark -- 访问访问器
/**
 访问服务器
 */
- (NSDictionary *) getHttp{

    GetHttp *http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    NSString *util_string = [util daiBan];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:@"" Util:util_string];
}

/**
 *  y 0 材料  没
 *  y 1 材料  有
 *  y 2 通知  没
 *  y 3 通知  有
 y 4     任务撰写
 y 5     任务检索
 y 6  待阅
 y 7  办理
 *  @param y<#y description#>
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *string_segue = segue.identifier;

    NSDictionary *dic = self.array_Table[self.cell_XuanZhe];
   // NSString *string_dic_xuanZe =[NSString stringWithFormat:@"%@",dic[@"xuanZe"]];
   // int int_xuanZe = [string_dic_xuanZe intValue];
    SELECT selectY = [dic[@"xuanZe"] intValue];
    if ([string_segue isEqualToString:@"daiyuerenwu"]) {

        RenWuZhuanXie_ViewController *ren = segue.destinationViewController;

        self.delegate = ren;
        [self.delegate add_DaiYue_SelectY:selectY];

    }
    else if ([string_segue isEqualToString:@"daibanshouwen"]){

        shouWenDaiYue_ViewController *shouwen = segue.destinationViewController;

        self.delegate = shouwen;
        [self.delegate add_DaiYue_SelectY:selectY];

    }
    else if([string_segue isEqualToString:@"daibancailiao"]){

        CaiLiao_TableViewController *cai = segue.destinationViewController;

        self.delegate = cai;
        
        [self.delegate add_DaiYue_SelectY:selectY];
    }

}

/***********************  代理方法  ****************/
#pragma  mark -- 基本代理方法

#pragma mark - Table view data source
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
 *  @param tableView
 *  @param section   <#section description#>
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array_Table.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DaiBan_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    int a = (int)indexPath.row;

    NSDictionary *dic = self.array_Table[a];

    cell.daiBan_Title.text = dic[@"title"];
    //cell.daiBan_Text.text = dic[@"text"];

      NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dic[@"text"]]];

    NSString *string_shuLiang = [NSString stringWithFormat:@"%@",dic[@"shuLiang"]];
    int int_shuLiang = [string_shuLiang intValue];

    if (int_shuLiang > 9 && int_shuLiang < 99) {

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 2)];
    }else if(int_shuLiang > 99){

           [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
    }else{

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 1)];
    }

    cell.daiBan_Text.attributedText = str;
    return cell;
}

/**
 *  选择
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _cell_XuanZhe = (int)indexPath.row;

    NSDictionary *dic = self.array_Table[self.cell_XuanZhe];

    if ([dic[@"segue"] isEqualToString:@""]) {

        //代码跳转
        NSString *string_dic_SBname = dic[@"SBname"];
        NSString *string_dic_CVname = dic[@"CVname"];

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:string_dic_SBname bundle:[NSBundle mainBundle]];
        UIViewController *Controller = [storyboard instantiateViewControllerWithIdentifier:string_dic_CVname];
        [self.navigationController pushViewController:Controller animated:YES];
    }
    else{
        [self performSegueWithIdentifier:dic[@"segue"] sender:nil];
    }

}

@end

