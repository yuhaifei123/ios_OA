//
//  ZJSJBG_XiangQing_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 经责审计报告
#import "AllDetailed_ViewController.h"

@protocol ZJSJBG_XiangQingDelegate <NSObject>

@optional

/**
 添加类型
 */
- (void) addTypeSJBBCY:(NSDictionary *)type;

@end

@interface ZJSJBG_XiangQing_ViewController : AllDetailed_ViewController


@property (nonatomic,weak) id<ZJSJBG_XiangQingDelegate> ZJSJBGdelegate;

@end
