//
//  Util.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/21.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 *  原始路径
 */
- (NSString *) yuanShi;

/**
 *  通知公告
 */
- (NSString *) tongZhi;

/**
 *  通知公告_web
 */
- (NSString *) tongZhi_web;
/**
 *  材料List
 */
- (NSString *) caiLiao_List;

/**
 *  登陆
 */
- (NSString *) Login;

/**
 *  登陆(第二次)
 */
- (NSString *) Login_Two;

/**
 *  材料List
 */
- (NSString *) caiLiao_Web;

/**
 *任务撰写List
 */
- (NSString *) chuanXie_List;

/**
 *  选择人
 *  @return <#return value description#>
 */
- (NSString *) xuanZheMean;

/**
 *  保存（任务撰写，保存任务）
 *
 *  @return <#return value description#>
 */
- (NSString *) baoCun;

/**
 任务添加view的数据
 */
- (NSString *) renWu_TianJia;

/**
  删除list
 */
- (NSString *) shanChu;

/**
 收文List
 */
- (NSString *) shouWenList;

/**
 收文List
 */
- (NSString *) faWenList;

/**
 干部离常List
 */
- (NSString *) ganBuLiChangList;

/**
 请假List
 */
- (NSString *) qinJiaList;

/**
 收文待遇内容
 */
- (NSString *) shouWen_NeiRong;

/**
 请假内容
 */
- (NSString *) qingJia_NeiRong;

/**
 发文待阅内容
 */
- (NSString *) faWen_NeiRong;

/**
 下载地址
 */
- (NSString *) xiaZai;

/**
 离开常州内容方法
 */
- (NSString *) liChang_NeiRong;

/**
 推流程
 */
- (NSString *) tuiLiuChen;

/**
 代办事项
 */
- (NSString *) daiBan;

/**
 一周办理
 */
- (NSString *) yiZhouBanLi;

/**
发文检索
 */
- (NSString *) faWen_JianSuo;

/**
 收文检索
 */
- (NSString *) shouWen_JianSuo;

/**
 保密列表
 */
- (NSString *) baoMi_List;

/**
 保密详细
 */
- (NSString *) baoMi_Detailed;

/**
 第二阶段所以的列表数据
 */
- (NSString *) phaseTwo_List;

/**
 第二阶段所有的详细界面
 */
- (NSString *) phaseTwo_Detailed;

/**
 业务管理
 */
- (NSString *) phaseTwo_YeWuGuanLi;

/**
 选人
 */
- (NSString *) phaseTwo_XuanRen;

@end
