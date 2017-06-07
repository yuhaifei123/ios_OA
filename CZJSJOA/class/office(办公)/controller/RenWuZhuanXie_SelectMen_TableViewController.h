//
//  RenWuZhuanXie_SelectMen_TableViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/25.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDNestedTableViewController.h"

@protocol RenWuZhuanXie_SelectMen_TableViewControllerDelegate <NSObject>

@optional

- (void) addNameDic:( NSDictionary *)dic;

@end

@interface RenWuZhuanXie_SelectMen_TableViewController : SDNestedTableViewController

@property NSString *persons;
@property NSString *personsid;//个人id
@property NSString *cdList;
@property NSString *ksList;
@property NSString *idList;

@property (nonatomic,weak) id delegate_AddName;

@end
