//
//  Util.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/21.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "Util.h"

@implementation Util

/**
 *  原始路径
 */
- (NSString *) yuanShi{

     // return  @"http://172.16.7.107:8080/jsjoa/";
   //return  @"http://titan.finstone.com.cn/jsjoa/";

   // return  @"http://172.16.7.107:8080/hfmis/";

    //测试
   // return @"http://172.16.6.21:8080/jsjoa1/";
     //发布 http://172.18.83.87:7001/jsjoa/
    return @"http://172.18.83.87:7001/jsjoa/";
}

/**
 *  通知公告
 */
- (NSString *) tongZhi{

    NSString *yuanShi = [self yuanShi];
    NSString *tongZhi = @"app/tzgg/list.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,tongZhi];
}

/**
 *  通知公告_web
 */
- (NSString *) tongZhi_web{

    NSString *yuanShi = [self yuanShi];
    NSString *tongZhi = @"app/tzgg/view.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,tongZhi];
}

/**
 *  登陆
 *  @return <#return value description#>
 */
- (NSString *) Login{

    NSString *yuanShi = [self yuanShi];
    NSString *login = @"tt_checklogon.do"; //@"tt_logon.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,login];
}

/**
 *  登陆(第二次)
 */
- (NSString *) Login_Two{

    NSString *yuanShi = [self yuanShi];
    NSString *login = @"app/userInfo.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,login];
}

/**
 *  材料_List
 *
 *  @return <#return value description#>
 */
- (NSString *) caiLiao_List{

    NSString *yuanShi = [self yuanShi];
    NSString *cailiao_List = @"app/mailbox/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,cailiao_List];
}

/**
 *  材料
 */
- (NSString *) caiLiao_Web{

    NSString *yuanShi = [self yuanShi];
    NSString *cailiao_List = @"app/mailbox/view.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,cailiao_List];
}

/**
 *任务撰写List
 */
- (NSString *) chuanXie_List{

    NSString *yuanShi = [self yuanShi];
    NSString *chuanXie_List = @"app/rwjb/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,chuanXie_List];
}

/**
 *  选择人
 *  @return <#return value description#>
 */
- (NSString *) xuanZheMean{

    NSString *yuanShi = [self yuanShi];
    NSString *xuanZheMean = @"app/personSelect.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,xuanZheMean];
}

/**
 *  保存（任务撰写，保存任务）
 *
 *  @return <#return value description#>
 */
- (NSString *) baoCun{

    NSString *yuanShi = [self yuanShi];
    NSString *baoCun = @"app/rwjb/save.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,baoCun];
}

/**
    任务添加view的数据
 */
- (NSString *) renWu_TianJia{

    NSString *yuanShi = [self yuanShi];
    NSString *renWu_TianJia = @"app/rwjb/form.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,renWu_TianJia];
}

/**
 删除list
 */
- (NSString *) shanChu{

    NSString *yuanShi = [self yuanShi];
    NSString *shanChu = @"app/delete.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,shanChu];
}

/**
    收文List
 */
- (NSString *) shouWenList{

    NSString *yuanShi = [self yuanShi];
    NSString *shouWenList = @"app/swgl/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,shouWenList];
}

/**
 收文List
 */
- (NSString *) faWenList{

    NSString *yuanShi = [self yuanShi];
    NSString *faWenList = @"app/fwgl/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,faWenList];
}

/**
 干部离常List
 */
- (NSString *) ganBuLiChangList{

    NSString *yuanShi = [self yuanShi];
    NSString *ganBuLiChangList = @"app/lcba/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,ganBuLiChangList];
}

/**
 请假List
 */
- (NSString *) qinJiaList{

    NSString *yuanShi = [self yuanShi];
    NSString *qinJiaList = @"app/qjgl/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,qinJiaList];
}

/**
  收文待阅内容
 */
- (NSString *) shouWen_NeiRong{

    NSString *yuanShi = [self yuanShi];
    NSString *shouWen_NeiRong = @"app/swgl/jcxx.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,shouWen_NeiRong];
}

/**
 发文待阅内容
 */
- (NSString *) faWen_NeiRong{

    NSString *yuanShi = [self yuanShi];
    NSString *faWen_NeiRong = @"app/fwgl/jcxx.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,faWen_NeiRong];
}

/**
 请假内容
 */
- (NSString *) qingJia_NeiRong{

    NSString *yuanShi = [self yuanShi];
    NSString *shouWen_NeiRong = @"app/qjgl/view.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,shouWen_NeiRong];
}

/**
  下载地址
 */
- (NSString *) xiaZai {

    NSString *yuanShi = [self yuanShi];
    NSString *xiaZai = @"app/tt_downloadfile.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,xiaZai];
}

/**
 离开常州内容方法
 */
- (NSString *) liChang_NeiRong {

    NSString *yuanShi = [self yuanShi];
    NSString *liChang_NeiRong = @"app/lcba/view.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,liChang_NeiRong];
}

/**
 推流程
 */
- (NSString *) tuiLiuChen {

    NSString *yuanShi = [self yuanShi];
    NSString *tuiLiuCheng = @"ttforward.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,tuiLiuCheng];
}

/**
    代办事项
 */
- (NSString *) daiBan{

    NSString *yuanShi = [self yuanShi];
    NSString *tuiLiuCheng = @"app/dbsy/listnew.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,tuiLiuCheng];
}

/**
    一周办理
 */
- (NSString *) yiZhouBanLi{

    NSString *yuanShi = [self yuanShi];
    NSString *yiZhouBanLi = @"app/yzap/list.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,yiZhouBanLi];
}

/**
 发文检索
 */
- (NSString *) faWen_JianSuo{

    NSString *yuanShi = [self yuanShi];
    NSString *faWen_JianSuo = @"app/fwgl/jslist.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,faWen_JianSuo];
}

/**
 发文检索
 */
- (NSString *) shouWen_JianSuo{

    NSString *yuanShi = [self yuanShi];
    NSString *shouWen_JianSuo = @"app/swgl/jslist.do";
    return  [NSString stringWithFormat:@"%@%@",yuanShi,shouWen_JianSuo];
}

/**
 保密列表
 */
- (NSString *) baoMi_List{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"app/appService/list.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}

/**
 保密详细
 */
- (NSString *) baoMi_Detailed{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"app/appService/view.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}

/************************ 第二阶段  ***********************/
#pragma  mark -- 第二阶段

#pragma  mark -- 科研处
/**
  第二阶段所以的列表数据
 */
- (NSString *) phaseTwo_List{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"app/appService/list.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}

/**
 第二阶段所有的详细界面
 */
- (NSString *) phaseTwo_Detailed{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"app/appService/view.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}


/**
 业务管理
 */
- (NSString *) phaseTwo_YeWuGuanLi{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"app/appService/list.do";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}

//common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess

/**
 选人
 */
- (NSString *) phaseTwo_XuanRen{

    NSString *yuanShi = [self yuanShi];
    NSString *baoMi_List = @"common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess";

    return [NSString stringWithFormat:@"%@%@",yuanShi,baoMi_List];
}

@end
