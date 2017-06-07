//
//  JianSuo_FaWen_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/27.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

@protocol JianSuo_FaWen_ViewControllerDelegate <NSObject>

@optional

//传cell 的 dic
-(void) addDic:(NSDictionary *)dic;
@end


@interface JianSuo_FaWen_ViewController : UIViewController

@property (nonatomic,weak) id delegate;

@end
