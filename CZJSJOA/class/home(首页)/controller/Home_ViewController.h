//
//  Home_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/19.
//  Copyright (c) 2015年 虞海飞. All rights reserved.
//
@protocol Home_ViewControllerDelegate <NSObject>

@optional

-(void) addHomeSelect_Y:(SELECT)y;

@end
@interface Home_ViewController : UIViewController

@property(nonatomic,weak) id delegate;

@end
