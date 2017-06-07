//
//  BaoMi_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/8.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BaoMiViewControllerDelegate<NSObject>


-(void) BaoMiViewControllerDelegate_Id:(int)Id;

@end

@interface BaoMi_ViewController : UIViewController

@property (nonatomic,weak) id<BaoMiViewControllerDelegate> delegatea;

/**
 刷新代理方法 (添加数据) 下
 */
-(void)reloadData_Down;

@end
