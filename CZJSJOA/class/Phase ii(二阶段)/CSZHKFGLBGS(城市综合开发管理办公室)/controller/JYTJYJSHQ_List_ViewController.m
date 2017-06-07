//
//  JYTJYJSHQ_List_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 建设条件意见书会签
#import "JYTJYJSHQ_List_ViewController.h"

@interface JYTJYJSHQ_List_ViewController ()

@end

@implementation JYTJYJSHQ_List_ViewController

- (void)viewDidLoad {

    self.FUNCTIONCODE = @"309901";
    self.TABLENAME = @"OA_YWGL_YJSHQ";//查询表名
    self.FLOWNAME = @"yjshq";
    self.PageIndex = @"1";//页数
    self.segueId = @"JYTJYJSHQ";
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
