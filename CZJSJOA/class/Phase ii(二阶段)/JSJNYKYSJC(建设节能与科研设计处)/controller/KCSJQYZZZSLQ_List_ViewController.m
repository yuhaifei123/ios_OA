//
//  KCSJQYZZZSLQ_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 勘察设计企业资质证书领取
#import "KCSJQYZZZSLQ_List_ViewController.h"
#import "AllList_TableViewCell.h"

@interface KCSJQYZZZSLQ_List_ViewController ()

@end

@implementation KCSJQYZZZSLQ_List_ViewController

- (void)viewDidLoad {

    self.FUNCTIONCODE = @"309901";
    self.TABLENAME = @"OA_YWGL_KCZZLQ";//查询表名
    self.FLOWNAME = @"kczzlq";//流程名字
    self.PageIndex = @"1";
    self.segueId = @"KCSJQYZZZSLQ";
    //设置参数
    [self add_GetHttpData_Functioncode:^NSString *{


        NSString *stringFun = [NSString stringWithFormat:@"flowname=%@&tablename=%@&typename=yfcs&functionCode=%@",self.FLOWNAME,self.TABLENAME,self.FUNCTIONCODE];

        return stringFun;
    } Util:^NSString *{

        Util *util = [[Util alloc] init];
        return [util phaseTwo_List];
    }];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static NSString *CELLID = @"ALLLIST";

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AllList_TableViewCell *allList_TableViewCell = [tableView dequeueReusableCellWithIdentifier:CELLID];

    if (allList_TableViewCell == nil){
        allList_TableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AllList_TableViewCell" owner:nil options:nil] objectAtIndex:0];
    }

    NSDictionary *dic = self.array_TableList[(int)indexPath.row];
    // NSLog(@"%@",dic);

    allList_TableViewCell.label_Title.text = [NSString stringWithFormat:@"%@",dic[@"DWMC"]];
    NSString *string_Time = [ChangYong_NSObject InterceptionString:dic[@"NRTIME"] Character:11];//截取字符
    allList_TableViewCell.label_Name.text = [NSString stringWithFormat:@"%@  %@",dic[@"NGR"],string_Time];
    allList_TableViewCell.label_LiuCheng.text = [NSString stringWithFormat:@"%@",dic[@"LCNAME"]];
    allList_TableViewCell.label_State.text = [NSString stringWithFormat:@"%@",dic[@"STATES"]];

    return allList_TableViewCell;
}

@end
