//
//  CaiLiao_TableViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//
//下拉刷新的方法
#import "PullTableView.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@protocol CaiLiao_TableViewControllerDelegate <NSObject>

@optional

- (void) addId:(NSString *)id Y:(int)y;

@end

@interface CaiLiao_TableViewController :UIViewController


@property(nonatomic,weak) id delegate;

@end
