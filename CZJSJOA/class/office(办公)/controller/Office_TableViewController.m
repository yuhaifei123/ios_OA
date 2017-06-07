//
//  Office_TableViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/20.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "Office_TableViewController.h"
#import "Offiec_TableViewCell.h"
#import "IanAlert.h"
#import "Web_ViewController.h"
#import "shouWenDaiYue_ViewController.h"
#import "RenWuZhuanXie_ViewController.h"
#import "DaiBan_NavigationController.h"

//研发处
#import "GCKCSJQYZZCS_List_ViewController.h"
#import "GCKCSJQYZZYJHCCS_List_ViewController.h"

@interface Office_TableViewController ()

@end

@implementation Office_TableViewController

static NSString *ID = @"office";
static int int_Row = 0;//第几列
static int int_section = 0;//第几组

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置title的字体大小
    CGRect rect = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = @"常州市城乡建设局综合信息平台（移动端）";
    label.font =  [UIFont fontWithName:@"Arial" size:14];
    label.textColor = [UIColor blackColor];
    
    self.navigationItem.titleView = label;
}

/**
 设置标题(宽度)
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

/**
 *设置标题头的名称
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    int a = (int)section;
    
    NSString *name = @"";
    
    switch (a) {
            
        case 0:
            name = @"一周安排";
            break;
            
        case 1:
            name = @"任务交办";
            break;
            
        case 2:
            name = @"收文管理";
            break;
         
        case 3:
            name = @"发文管理";
            break;
            
        case 4:
            name = @"通知公告";
            break;
            
        case 5:
            name = @"材料互递";
            break;

        case 6:
            name = @"保密审查单";
            break;

        case 8:
            name = @"考勤管理";
            break;

        case 7:
            name = @"科研处";
            break;

        default:
            name = @"";
            break;
    }
    
    return  name;
}

#pragma mark - Table view data source

//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //缓存
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *string_role = [as stringForKey:@"role"];
    NSRange range_oa_ksfzr = [string_role rangeOfString:@"oa_ksfzr"];//判断字符串是否包含
    NSRange range_oa_zxld = [string_role rangeOfString:@"oa_zxld"];
    NSRange range_oa_xzjld = [string_role rangeOfString:@"oa_xzjld"];
    NSRange range_oa_dwsj = [string_role rangeOfString:@"oa_dwsj"];

    NSRange range_oa_qjglzzc = [string_role rangeOfString:@"oa_qjglzzc"];

    NSRange range_oa_bgszr = [string_role rangeOfString:@"oa_bgszr"];
     NSRange range_oa_jld = [string_role rangeOfString:@"oa_jld"];

    if(range_oa_ksfzr.length > 0 || range_oa_zxld.length > 0 || range_oa_xzjld.length >0 || range_oa_xzjld.length >0 || range_oa_dwsj.length>0 ||  range_oa_qjglzzc.length>0 || range_oa_bgszr.length>0 || range_oa_jld.length>0){

        return 9;
    }else{

        return 8;
    }
}

//cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //缓存
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *string_role = [as stringForKey:@"role"];

    NSRange range_oa_ksfzr = [string_role rangeOfString:@"oa_ksfzr"];//判断字符串是否包含
    NSRange range_oa_zxld = [string_role rangeOfString:@"oa_zxld"];
    NSRange range_oa_xzjld = [string_role rangeOfString:@"oa_xzjld"];
    NSRange range_oa_dwsj = [string_role rangeOfString:@"oa_dwsj"];

    NSRange range_oa_qjglzzc = [string_role rangeOfString:@"oa_qjglzzc"];

    NSRange range_oa_bgszr = [string_role rangeOfString:@"oa_bgszr"];
    NSRange range_oa_jld = [string_role rangeOfString:@"oa_jld"];

    //每组多少cell
    int int_Cell = 0;
    switch (section) {

        case 0:
            int_Cell = 1;
            break;

        case 2:
            int_Cell = 3;
            break;

        case 6:
            int_Cell = 1;
            break;

        case 8:
            if(range_oa_ksfzr.length > 0 || range_oa_zxld.length > 0 || range_oa_xzjld.length >0 || range_oa_dwsj.length >0|| range_oa_qjglzzc.length >0){

                int_Cell = int_Cell+1;
            }
            if(range_oa_jld.length > 0 || range_oa_zxld.length > 0 ||  range_oa_bgszr.length > 0){

                int_Cell = int_Cell+1;
            }
            break;

        case 7:
            int_Cell = 1;
            break;

        default:
            int_Cell = 2;
            break;
    }

    return int_Cell;
}

//cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Offiec_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    //组
    int int_section = (int)indexPath.section;
    //行
    int int_Row = (int)indexPath.row;

    //缓存
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *string_role = [as stringForKey:@"role"];
    NSRange range_oa_ksfzr = [string_role rangeOfString:@"oa_ksfzr"];//判断字符串是否包含
    NSRange range_oa_zxld = [string_role rangeOfString:@"oa_zxld"];
    NSRange range_oa_xzjld = [string_role rangeOfString:@"oa_xzjld"];
    NSRange range_oa_dwsj = [string_role rangeOfString:@"oa_dwsj"];

    NSRange range_oa_qjglzzc = [string_role rangeOfString:@"oa_qjglzzc"];

    NSRange range_oa_bgszr = [string_role rangeOfString:@"oa_bgszr"];
    NSRange range_oa_jld = [string_role rangeOfString:@"oa_jld"];


    switch (int_section) {

        case 0:
            cell.office_Image.image = [UIImage imageNamed:@"a10"];
            cell.office_Text.text = @"一周安排";
            break;

        case 1:
            if(int_Row == 0){
                
                cell.office_Image.image = [UIImage imageNamed:@"a0"];
                cell.office_Text.text = @"任务撰写";
            }else{
                
                cell.office_Image.image = [UIImage imageNamed:@"a1"];
                cell.office_Text.text = @"任务检索";
            }
            break;
            
        case 2:
            if(int_Row == 0){
                
                cell.office_Image.image = [UIImage imageNamed:@"a2"];
                cell.office_Text.text = @"收文待阅";
            }
            else if(int_Row == 1){
                
                cell.office_Image.image = [UIImage imageNamed:@"a3"];
                cell.office_Text.text = @"收文办理";
            }
            else{

                cell.office_Image.image = [UIImage imageNamed:@"a12"];
                cell.office_Text.text = @"收文检索";
            }
            break;
            
        case 3:
            if (int_Row == 0) {

                cell.office_Image.image = [UIImage imageNamed:@"a4"];
                cell.office_Text.text = @"发文办理";
            }
            else{

                cell.office_Image.image = [UIImage imageNamed:@"a13"];
                cell.office_Text.text = @"发文检索";
            }

            break;
            
        case 4:
            if(int_Row == 0){
                
                cell.office_Image.image = [UIImage imageNamed:@"a6"];
                cell.office_Text.text = @"未阅通知";
            }
            else{
                
                cell.office_Image.image = [UIImage imageNamed:@"a7"];
                cell.office_Text.text = @"已阅通知";
            }
            break;
            
        case 5:
            if(int_Row == 0){

                cell.office_Image.image = [UIImage imageNamed:@"a8"];
                cell.office_Text.text = @"未读材料";
            }
            else{

                cell.office_Image.image = [UIImage imageNamed:@"a9"];
                cell.office_Text.text = @"已读材料";
            }
            break;

        case 6:
            cell.office_Image.image = [UIImage imageNamed:@"a14"];
            cell.office_Text.text = @"保密审查单";
            break;

        case 8:
            if(int_Row == 0){

                if(range_oa_jld.length > 0 || range_oa_zxld.length > 0 ||  range_oa_bgszr.length > 0){
                    
                    cell.office_Image.image = [UIImage imageNamed:@"a11"];
                    cell.office_Text.text = @"干部离常登记审核";
                }

                if(range_oa_ksfzr.length > 0 || range_oa_zxld.length > 0 || range_oa_xzjld.length >0 || range_oa_dwsj.length >0|| range_oa_qjglzzc.length >0){

                    cell.office_Image.image = [UIImage imageNamed:@"a10"];
                    cell.office_Text.text = @"请假审核";
                }

            }
            else{

                cell.office_Image.image = [UIImage imageNamed:@"a11"];
                cell.office_Text.text = @"干部离常登记审核";
            }
            break;

        case 7:
            cell.office_Image.image = [UIImage imageNamed:@"a14"];
            cell.office_Text.text = @"工程勘察设计企业资质初审";
            break;

        default:
            break;
    }

    return cell;
}

/**
 *
 * 点击以后，触发的事件
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //组
    int_section = (int)indexPath.section;
    //行
    int_Row = (int)indexPath.row;

    //缓存
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *string_role = [as stringForKey:@"role"];
    NSRange range_oa_ksfzr = [string_role rangeOfString:@"oa_ksfzr"];//判断字符串是否包含
    NSRange range_oa_zxld = [string_role rangeOfString:@"oa_zxld"];
    NSRange range_oa_xzjld = [string_role rangeOfString:@"oa_xzjld"];
    NSRange range_oa_dwsj = [string_role rangeOfString:@"oa_dwsj"];

    NSRange range_oa_qjglzzc = [string_role rangeOfString:@"oa_qjglzzc"];

    NSRange range_oa_bgszr = [string_role rangeOfString:@"oa_bgszr"];
    NSRange range_oa_jld = [string_role rangeOfString:@"oa_jld"];

    //是第一阶段，用segue跳转方式,
    if (int_section < 7 || int_section  == 8 ) {

        switch (int_section) {
            case 0:
                [self performSegueWithIdentifier:@"yizhouanpai" sender:nil];
                break;

            case 1:
                //segue f都是一样的地址
                [self performSegueWithIdentifier:@"renwu" sender:nil];
                break;

            case 2:
                if(int_Row == 0){

                    //segue f都是一样的地址
                    [self performSegueWithIdentifier:@"shouwen" sender:nil];
                }
                else if(int_Row == 1){

                    //segue f都是一样的地址
                    [self performSegueWithIdentifier:@"shouwen" sender:nil];
                }
                else{

                    //segue f都是一样的地址
                    [self performSegueWithIdentifier:@"shouwenjiansuo" sender:nil];
                }
                break;

            case 3:
                if (int_Row == 0) {
                    //segue f都是一样的地址
                    [self performSegueWithIdentifier:@"fawen" sender:nil];
                }
                else{
                    //fawenjiansuo
                    [self performSegueWithIdentifier:@"fawenjiansuo" sender:nil];
                }

                break;

            case 4:
                //segue f都是一样的地址
                [self performSegueWithIdentifier:@"cailiao" sender:nil];
                break;

            case 5:
                //segue f都是一样的地址
                [self performSegueWithIdentifier:@"cailiao" sender:nil];
                break;

            case 6:
                [self performSegueWithIdentifier:@"secretTable" sender:nil];
                break;

            case 8:
                if(int_Row == 0){

                    if(range_oa_ksfzr.length > 0 || range_oa_zxld.length > 0 || range_oa_xzjld.length >0 || range_oa_dwsj.length >0|| range_oa_qjglzzc.length >0){

                        //segue f都是一样的地址
                        [self performSegueWithIdentifier:@"qinjia" sender:nil];
                        return;
                    }

                    if(range_oa_jld.length > 0 || range_oa_zxld.length > 0 ||  range_oa_bgszr.length > 0){
                        
                        //segue f都是一样的地址
                        [self performSegueWithIdentifier:@"lichang" sender:nil];
                    }
                    
                }
                else{
                    //segue f都是一样的地址
                    [self performSegueWithIdentifier:@"lichang" sender:nil];
                }
                break;
                
            default:
                break;
        }
    }else{
        #pragma  mark -- 测试
        NSString *string_SBName = @"";
        NSString *string_SBControllerName = @"";

        //第二阶段，用代码跳转
        switch (int_section) {
            case 7:
                string_SBName = @"JSJNYKYSJC";
                string_SBControllerName = @"GCKCSJQYZZYJHCCS_List";
                break;
                
            default:
                break;
        }

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:string_SBName bundle:[NSBundle mainBundle]];
        GCKCSJQYZZYJHCCS_List_ViewController *gCKCSJQYZZCS_List_ViewController = [storyboard instantiateViewControllerWithIdentifier:string_SBControllerName];
       [self.navigationController pushViewController:gCKCSJQYZZCS_List_ViewController animated:YES];
    }
}


//segue,调用的方法
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    //判断那个 segue 标示
    NSString *segue_String = segue.identifier;

    //判断，代理
        //任务
        if([segue_String isEqualToString:@"renwu"]){

            RenWuZhuanXie_ViewController *ren = segue.destinationViewController;
            self.delegate = ren;
        
            if (int_Row == 0) {
                [self.delegate selectY:RWZX];
            }
            else{
                [self.delegate selectY:RWJS];
            }
        //材料
        }
        else if ([segue_String isEqualToString:@"cailiao"]){

            //目标view
            Web_ViewController *web= segue.destinationViewController;
            //他实现代理
            self.delegate = web;

            if (int_section == 4) {

                  (int_Row == 0)?([self.delegate selectY:WYTZ]) : ([self.delegate selectY:YYTZ]);
            }
            else{
                  (int_Row == 0)?([self.delegate selectY:WDCL]) : ([self.delegate selectY:YDCL]);
            }

        //收文
        }
        else if ([segue_String isEqualToString:@"shouwen"]){

            shouWenDaiYue_ViewController *shou = segue.destinationViewController;
            self.delegate = shou;

            //待阅 == 0，办理 == 1
            (int_Row == 0)?([self.delegate selectY:SWDY]) : ([self.delegate selectY:SWBL]);
    }
}
@end
