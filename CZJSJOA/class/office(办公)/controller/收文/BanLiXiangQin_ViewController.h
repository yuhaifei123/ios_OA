//
//  BanLiXiangQin_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/10.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

@protocol DaiYueXiangQin_ViewControllerDelegate <NSObject>

@optional

/**
 添加类型
 */
- (void) addType:(NSDictionary *)type;

@end

@interface BanLiXiangQin_ViewController : UIViewController

@property (nonatomic,weak) id delegate;

@end
