//
//  AllList_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/4.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- list表界面父类

@protocol AllListDelegate <NSObject>

@required
/** 把数据回调给详细界面 */
-(void) AllList_Dic:(NSDictionary *)dic Dic_Table:(NSDictionary *)dic_Table;

@end

@interface AllList_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 拼接好的请求数据 */
@property (nonatomic,copy) NSString *functioncode;
@property (nonatomic,copy) NSString *util_string;

@property (nonatomic,copy) NSString *FUNCTIONCODE; //查询表名
@property (nonatomic,copy) NSString *TABLENAME; //查询表名
@property (nonatomic,copy) NSString *FLOWNAME; //流程名字
@property (nonatomic,copy) NSString *PageIndex; //页数

@property (nonatomic,strong) NSArray *array_TableList;//表的数据

/** 跳转的id */
@property (nonatomic,copy) NSString *segueId;

//代理
@property (nonatomic,weak) id<AllListDelegate> delegate;

/**
 * 请求网络参数设置
 *
 *  @param functioncode 请求网络要的参数
 *  @param util         请的路径
 */
-(void) add_GetHttpData_Functioncode:(NSString *(^)())functioncode Util:(NSString *(^)())util;

/**
 * view属性设置
 */
-(void) add_View;

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Down;

@end
