//
//  QiJia_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//
@protocol   QiJia_ViewControllerDelegate <NSObject>

@optional

- (void) addDic:(NSDictionary *)dic;

@end

@interface QiJia_ViewController : UIViewController

@property (weak,nonatomic) id delegate;

@end
