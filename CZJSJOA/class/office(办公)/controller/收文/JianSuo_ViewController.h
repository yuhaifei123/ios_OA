//
//  JianSuo_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/26.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

@protocol JianSuo_ViewControllerDelegate <NSObject>

@optional

//传cell 的 dic
-(void) addDic:(NSDictionary *)dic;
@end

@interface JianSuo_ViewController : UIViewController

@property (nonatomic,weak) id delegate;

@end
