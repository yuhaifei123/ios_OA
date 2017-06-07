//
//  SJHTGL_List_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/12.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 审计合同管理
#import "SJHTGL_List_ViewController.h"
#import "AllList_TableViewCell.h"

@interface SJHTGL_List_ViewController ()

@end

@implementation SJHTGL_List_ViewController

- (void)viewDidLoad {

    self.FUNCTIONCODE = @"309901";
    self.TABLENAME = @"OA_YWGL_SJHT";//查询表名
    self.FLOWNAME = @"sjht";
    self.PageIndex = @"1";//页数
    self.segueId = @"SJHT";
    //设置参数
    [self add_GetHttpData_Functioncode:^NSString *{

           NSString *stringFun = [NSString stringWithFormat:@"flowname=%@&tablename=%@&typename=yfcs&functionCode=%@",self.FLOWNAME,self.TABLENAME,self.FUNCTIONCODE];

        return stringFun;
    } Util:^NSString *{

        Util *util = [[Util alloc] init];
        return [util phaseTwo_List];
    }];

    [super viewDidLoad];
}

@end
