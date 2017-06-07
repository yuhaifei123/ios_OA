
//
//  SGTSJWJSCJGRDSQ_List_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 施工图设计文件审查机构认定申请
#import "SGTSJWJSCJGRDSQ_List_ViewController.h"

@interface SGTSJWJSCJGRDSQ_List_ViewController ()

@end

@implementation SGTSJWJSCJGRDSQ_List_ViewController

- (void)viewDidLoad {

    self.FUNCTIONCODE = @"309901";
    self.TABLENAME = @"OA_YWGL_SGSJRDSQ";//查询表名
    self.FLOWNAME = @"sgsjrdsq";
    self.PageIndex = @"1";//页数
    self.segueId = @"SGTSJWJSCJGRDSQ";
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
