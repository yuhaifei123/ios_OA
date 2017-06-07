//
//  LiuChenBean.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/15.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiuChenBean : NSObject

@property (nonatomic,copy) NSString *names;
@property (nonatomic,copy) NSString *idlist1;
@property (nonatomic,copy) NSString *taskname;
@property (nonatomic,copy) NSString *ztbs;
@property (nonatomic,copy) NSString *tablename;
@property (nonatomic,copy) NSString *lcname;
@property (nonatomic,copy) NSString *spyjColumn;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *issh;
@property (nonatomic,copy) NSString *bz;
@property (nonatomic,copy) NSString *idlist;
@property (nonatomic,copy) NSString *kslist;
@property (nonatomic,copy) NSString *ldlist;
@property (nonatomic,copy) NSString *spyj;
@property (nonatomic,copy) NSString *updateColumns;
@property (nonatomic,copy) NSString *swlx;//选择人
/** 状态 */
@property (nonatomic,copy) NSString *state;
/** 是否发生短信  */
@property (nonatomic,copy) NSString *isdx;
/** 特殊流程 */
@property (nonatomic,copy) NSString *teshu;

+(instancetype) init_LiuChenBeanDic:(NSDictionary *)dic;
-(instancetype) init_LiuChenBeanDic:(NSDictionary *)dic;

@end
