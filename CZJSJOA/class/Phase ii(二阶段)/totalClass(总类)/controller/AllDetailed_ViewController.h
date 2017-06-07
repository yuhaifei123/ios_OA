//
//  AllDetailed_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 详细界面父类

#import "AllList_ViewController.h"

@protocol AllDetailedDelegate <NSObject>

/**  textView 参数，判断是否可编辑 */
-(void) AllDetailedDic:(NSDictionary *)dic;

/**
    点击小手，选择人的时候，给别人要的数据
 */
- (void) addTypeAllDetailed:(NSDictionary *)type;

@end

@interface AllDetailed_ViewController : UIViewController<AllListDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switch_isdx;

/** 按钮触发参数_默认“0”关闭 */
@property(nonatomic,copy) NSString *string_SwitchNO;

/** 判断以后，得到的spyj 和 spyjColumn */
@property (nonatomic,strong) NSMutableArray *array_spyj;
/** 放列表回来列表回来的数据 */
@property (nonatomic,strong) NSDictionary *dic_AllList;
@property (nonatomic,strong) NSDictionary *dic_Table;
/** 网络返回的详情数据 */
@property (nonatomic,strong) NSDictionary *dic_ALLXiangQing;

/** 解析返回详情数据的字典，页面展示数据 */
@property (nonatomic,strong) NSArray *array_AllXiangQing;
/** textView所有的key  */
@property (nonatomic,strong) NSDictionary *dic_AllLianXi;

//流程
/** 流程bean */
@property (nonatomic,strong) LiuChenBean *liuChenBean;
/** 发送数据 */
@property (nonatomic,strong) FaSongShuJu *faSongShuJu;
/** 流程返回_dic 节点  */
@property (nonatomic, strong)  NSArray *array_person;

/** 代理 */
@property (nonatomic,weak) id<AllDetailedDelegate> delegate;

/**
 * view属性设置
 */
-(void) add_View;

/**
 *请求网络数据
 *
 *  @param dic 请求网络数据
 */
-(void) add_GetHttp_PinJie:(NSString *(^)())pinJie;

/**
 *
 *  @return 返回的数据，赋值给界面
 */
-(void) add_View_Array:(NSArray *)array;

/**
 *  判断按钮
 *
 *  @param sw           按钮
 *  @param string_Judge 数据
 */
-(void) add_JudgeSwitch:(UISwitch *)sw String_Judge:(NSString *)string_Judge;

/**
 *  根据messageControl，判断来给每个textView赋值
 *
 *  @param BzDic 字典[ZYLDYJ:主要领导意见]
 *
 *  @return [spyi,spyjColumn];
 */
-(NSMutableArray *) add_judgeAddTextView_BZDic:(NSDictionary *)BzDic;

#pragma  mark -- 流程推送
/**
 * 流程推送
 */
-(void) add_Process;

#pragma  mark -- view赋值，子类的一些独有的方法
/**
 * view赋值，子类的一些独有的方法
 */
-(void) add_ViewZiLei;
@end
