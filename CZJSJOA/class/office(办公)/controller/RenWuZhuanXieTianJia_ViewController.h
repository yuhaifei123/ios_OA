//
//  RenWuZhuanXieTianJia_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/25.
//  Copyright © 2015年 虞海飞. All rights reserved.
//
@protocol RenWuZhuanXieTianJia_ViewControllerDelegate <NSObject>

@optional
- (void) addType_RenWu:(NSString *)type;

@end

@interface RenWuZhuanXieTianJia_ViewController : UIViewController

@property (nonatomic,weak) id delegate;
@end
