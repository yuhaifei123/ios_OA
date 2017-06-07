//
//  RenWuZhuanXie_SelectMen_TableViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/25.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "RenWuZhuanXie_SelectMen_TableViewController.h"
#import "Util.h"
#import "GetHttp.h"
#import "ChooseTableView.h"
#import "HeaderView.h"
#import "ChooseRoleCell.h"
#import "DaiYueXiangQin_ViewController.h"
#import "RenWuZhuanXieTianJia_ViewController.h"

@interface RenWuZhuanXie_SelectMen_TableViewController ()<DaiYueXiangQin_ViewControllerDelegate,RenWuZhuanXieTianJia_ViewControllerDelegate>

@property (nonatomic, retain) NSArray *rowsArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (nonatomic,strong) NSString *type;//访问网络，类型
@property (nonatomic,strong) NSDictionary *dic_type;//访问网络，类型

@end

@implementation RenWuZhuanXie_SelectMen_TableViewController

- (id) init{

    if (self = [super initWithNibName:@"SDNestedTableView" bundle:nil]){
        // do init stuff
    }

    return self;
}


- (id)initWithCoder:(NSCoder*)aDecoder{

    if(self = [super initWithCoder:aDecoder]){

        _rowsArray = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

//界面将要打开
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSDictionary *dic;
    if([self.type isEqual:nil] || self.type == nil ){
        
        dic = [self getPersonsListType:self.dic_type[@"type"]];
    }else{
        
        dic = [self getPersonsListType:self.type];
    }
    
    [self shuJuZhuanHuanDic:dic];
}

/********************** 基本方法 ****************/
#pragma mark -- 基本方法

//点击完成按钮（保存）
- (IBAction)wangChen_Item:(id)sender {

    // [self deDao_name:sender];
    //去掉内存里面的view
    [self.navigationController popViewControllerAnimated:YES];

    //如果有这个方法
    if([self.delegate_AddName respondsToSelector:@selector(addNameDic:)]){

        NSDictionary *dic= [self deDao_name:sender];
        
        NSString *dic_name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        
        if ([dic_name isEqualToString:@""] || dic == nil) {
            
            NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
            NSString *name = [as stringForKey:@"username"];
             NSString *nameId = [as stringForKey:@"userid"];
            
             //name = 选择的名字，nameid = 选择的名字的id ，cdListid = 领导id,kslistId = 监督id，idlistId = 屌丝id
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"name",@"",@"nameId",@"",@"kslistId",@"",@"cdListid",@"",@"idlistId",nil];
        }
        
        [[self delegate_AddName] addNameDic:dic];
    }
}

/**
 *  得到选择中的名字
 *
 *  @param sender <#sender description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *) deDao_name:(id)sender{

    if(sender !=self.save) return nil;

    self.persons=@"";
    self.personsid=@"";
    self.cdList = @"";//领导DM
    self.ksList = @"";//监督Dm
    self.idList = @"";//屌丝DM

    //循环得到，名字,个人唯一ID
    for (id akey in [selectableSubCellsState allKeys]) {

        NSIndexPath *depindex =  akey;
        NSDictionary  *subobj = [selectableSubCellsState objectForKey:akey];
        NSDictionary *deptdic = [_rowsArray objectAtIndex:depindex.row];

        NSArray *personsarray = [deptdic valueForKey:@"list"];

        for (id subkey in [subobj allKeys]){

            NSIndexPath *sunindex =  subkey;

            NSNumber *tempflag = [subobj objectForKey:subkey];
            int flag =[tempflag intValue];
            if (flag ==0) {
                continue;
            }

            NSDictionary *subdic = [personsarray objectAtIndex:sunindex.row];

            //得到名字
            if (self.persons.length == 0) {
                self.persons = [self.persons stringByAppendingString:[subdic valueForKey:@"MC"]];
            }else{

                self.persons = [[self.persons stringByAppendingString:@";"] stringByAppendingString:[subdic valueForKey:@"MC"]];
            }

            //得到代码（个人唯一ID）
            if (self.personsid.length == 0) {

                self.personsid = [self.personsid stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
            }else{
                self.personsid = [[self.personsid stringByAppendingString:@";"] stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
            }

            //判断是不是领导
            NSString *linDao = [ChangYong_NSObject selectNulString:[subdic valueForKey:@"ROLE"]];//判断是不是空值
            if([linDao isEqualToString:@"oa_zxld"]){

                if (self.cdList.length == 0) {
                    self.cdList = [self.cdList stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }else{
                    self.cdList = [[self.cdList stringByAppendingString:@";"] stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }
            }else if ([linDao isEqualToString:@"oa_ksfzr"]){

                if (self.ksList.length == 0) {
                    self.ksList = [self.ksList stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }else{
                    self.ksList = [[self.ksList stringByAppendingString:@";"] stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }
            }else{

                if (self.idList.length == 0) {
                    self.idList = [self.idList stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }else{
                    self.idList = [[self.idList stringByAppendingString:@";"] stringByAppendingString:[NSString stringWithFormat:@"%@",subdic [@"DM"]]];
                }
            }
        }
    }

    //name = 选择的名字，nameid = 选择的名字的id ，cdListid = 领导id,kslistId = 监督id，idlistId = 屌丝id
    return  [NSDictionary dictionaryWithObjectsAndKeys:self.persons,@"name",self.personsid,@"nameId",self.cdList,@"cdlistId",self.ksList,@"kslistId",self.idList,@"idlistId",nil];
}

/**
 *  请求网络数据
 */
-(NSDictionary *) getPersonsListType:(NSString *)type{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util xuanZheMean];

    //把userid 缓存里面拿出来
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    NSString *dept = [as stringForKey:@"dept"];

    NSString *rolename = @"";
    if (self.dic_type != nil)  rolename = self.dic_type[@"rolename"];

    NSString  *pinJie = [NSString stringWithFormat:@"type=%@&dept=%@&rolename=%@",type,dept,rolename];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 *  把服务器过来的数据，转化一下格式
 *
 *  @param dic <#dic description#>
 */
- (void) shuJuZhuanHuanDic:(NSDictionary *)dic{

    NSMutableArray *array = dic[@"list"];
    NSDictionary *dic_02 = nil;
    NSDictionary *dic_03 = nil;

    //确定部门
    NSMutableArray *dept_Array = [NSMutableArray array];
    for (int i = 1; i < array.count; i ++ ) {

        dic_02 = array[i-1];
        dic_03 = array[i];
        NSString *DEPTNAME_01 = [NSString stringWithFormat:@"%@",dic_02[@"DEPTNAME"]];
        NSString *DEPTNAME_02 = [NSString stringWithFormat:@"%@",dic_03[@"DEPTNAME"]];

        //确定第一个
        if (i == 1) {
            [dept_Array addObject:DEPTNAME_01];
        }

        if (! [DEPTNAME_01 isEqualToString:DEPTNAME_02]) {

            [dept_Array addObject:DEPTNAME_02];
        }
    }

    //相同部门的总的数组
    NSMutableArray *da_Array = [NSMutableArray array];
    NSMutableArray *xiao_Array = nil;
    for (int i = 0; i < dept_Array.count; i++) {

        xiao_Array = [NSMutableArray array];
        NSDictionary *dic_Array = nil;
        for (int j = 0; j < array.count; j ++) {

            NSString *dept_Name = dept_Array[i];
            dic_Array = array[j];
            NSString *all_Name = [NSString stringWithFormat:@"%@",dic_Array[@"DEPTNAME"]];

            if ([dept_Name isEqualToString:all_Name]) {
                [xiao_Array addObject:array[j]];
            }
        }

        [da_Array addObject:xiao_Array];
    }

    NSMutableDictionary *dic_All = nil;//最大的dic
    NSMutableArray *array_All = [NSMutableArray array];
    //把得到的数据变成字典 -》放入大字典里面
    for (int i = 0; i < dept_Array.count;  i ++) {

        dic_All = [NSMutableDictionary dictionary];
        dic_All[@"dept"] = dept_Array[i];
        dic_All[@"list"] = da_Array[i];
        
        [array_All addObject:dic_All];
    }

    _rowsArray = array_All;
}


#pragma mark - Nested Tables methods

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    return _rowsArray.count;
}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *obj = [_rowsArray objectAtIndex:indexPath.row];
    NSArray *subobj = [obj valueForKey:@"list"];

    return subobj.count;
}

- (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obj = [_rowsArray objectAtIndex:indexPath.row];

    item.itemText.text = [obj valueForKey:@"dept"];
    item.itemText.tag =indexPath.row;
    //item.itemText.text = [NSString stringWithFormat:@"My Main Item %u", indexPath.row +1];
    return item;
}

- (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *obj = [_rowsArray objectAtIndex:item.itemText.tag];
    NSArray *subobj = [obj valueForKey:@"list"];
    NSDictionary *subdic = [subobj objectAtIndex:indexPath.row];

    subItem.backgroundColor = [UIColor whiteColor];
    subItem.itemText.text=[subdic valueForKey:@"MC"];
    subItem.itemText.tag =indexPath.row;
    // subItem.itemText.text = [NSString stringWithFormat:@"My Sub Item %u", indexPath.row +1];
    return subItem;
}

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
{
    SelectableCellState state = item.selectableCellState;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:item];
    switch (state) {
        case Checked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Checked\"", indexPath);
            break;
        case Unchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            break;
        case Halfchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Halfchecked\"", indexPath);
            break;
        default:
            break;
    }
}

- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
{
    SelectableCellState state = subItem.selectableCellState;
    NSIndexPath *indexPath = [item.subTable indexPathForCell:subItem];
    switch (state) {
        case Checked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Checked\"", indexPath);
            break;
        case Unchecked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            break;
        default:
            break;
    }
}

- (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Expanded Item at indexPath: %@", indexPath);
}

- (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Collapsed Item at indexPath: %@", indexPath);
}

/********************** 代理方法 ****************/
#pragma mark -- 代理方法

/**
  DaiYueXiangQin_ViewController.h 代理方法
 */
- (void) addType:(NSDictionary *)type{

    self.dic_type = type;
}

-(void) addType_RenWu:(NSString *)type{
    self.type = type;
}

@end
