//
//  DaiBan_ViewController.h
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/22.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaiBan_ViewControllerDelegate <NSObject>

@optional
-(void) add_DaiYue_SelectY:(SELECT)y;

@end

@interface DaiBan_ViewController : UIViewController

@property(nonatomic,weak) id delegate;

@end
