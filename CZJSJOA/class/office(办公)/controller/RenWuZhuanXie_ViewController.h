//
//  RenWuZhuanXie_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/24.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "PullTableView.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@protocol RenWuZhuanXie_ViewControllerDelegate <NSObject>

@optional
//代理方法
- (void) addDataDic:(NSDictionary *)dic;

/**
  1 == 任务撰写  2 == 任务检索
 */
- (void) addType:(int)type;
@end



@interface RenWuZhuanXie_ViewController : UIViewController

@property(nonatomic,weak) id delegate;

@end
