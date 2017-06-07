//
//  FaWenBanLi_ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

@protocol FaWenBanLi_ViewControllerDelegate <NSObject>

@optional

//传cell 的 dic
-(void) addDic:(NSDictionary *)dic;
@end

@interface FaWenBanLi_ViewController : UIViewController

@property (nonatomic,weak) id delegate;

@end
