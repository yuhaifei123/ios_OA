//
//  SJJNQPZXYDZJXMGL_List_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 省级节能减排专项引导资金项目管理
#import "SJJNQPZXYDZJXMGL_List_ViewController.h"

@interface SJJNQPZXYDZJXMGL_List_ViewController ()

@end

@implementation SJJNQPZXYDZJXMGL_List_ViewController

- (void)viewDidLoad {

    self.FUNCTIONCODE = @"309901";
    self.TABLENAME = @"OA_YWGL_ZJSB";//查询表名
    self.FLOWNAME = @"zjsb";
    self.PageIndex = @"1";//页数
    self.segueId = @"SJJNQPZXYDZJXMGL";
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
