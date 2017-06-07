//
//  Office_TableViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/20.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Office_TableViewControllerDelegate <NSObject>

//  选择跳转地址
typedef  NS_ENUM (int, SELECT)   {
    WYTZ = 0,//未阅通知
    YYTZ = 1,//已阅通知
    WDCL,//未读材料
    YDCL,//已读材料
    RWZX,//任务撰写
    RWJS,//任务检索
    SWDY,//收文待阅
    SWBL,//收文办理
    FWBL,//发文办理
    QJSH,//请假审核
    LCJS//离常检索
};

@optional

/**
 *  y 是“0” 说明没有阅
 *  y 是“1” 说明已阅
 *  y 是“2” 材料没有读
 *  y 3     材料读了
    y 4     任务撰写
    y 5     任务检索

 *  @param y<#y description#>
 */
- (void) selectY:(SELECT)y;

@end
@interface Office_TableViewController : UITableViewController




@property (nonatomic,weak) id delegate;
@end
