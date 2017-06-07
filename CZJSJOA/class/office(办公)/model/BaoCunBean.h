//
//  BaoCunBean.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoCunBean : NSObject


/**
 *  短信(是否发送短信)(0 == no,1 == yes)
 */
@property (nonatomic,copy) NSString *ISDX;

/**
 *  类型（go 保存，save 提交 ）
 */
@property (nonatomic,copy) NSString *TYPE;

/**
 *  useroidList 查看人的id
 */
@property (nonatomic,copy) NSString *FBFWID;

/**
 *  当前时间
 */
@property (nonatomic,copy) NSString *NRTIME;

/**
 *  deptid（在登录的时候，拿的个人id）部门id
 */
@property (nonatomic,copy) NSString *NGBMID;

/**
 *  usercnname 交办人名字
 */
@property (nonatomic,copy) NSString *NGR;

/**
 *  检测人名字
 */
@property (nonatomic,copy) NSString *FBFW;

/**
 *  默认""
 */
@property (nonatomic,copy) NSString *BZ;

/**
 *  userid
 */
@property (nonatomic,copy) NSString *NGRID;

/**
 *  选择时间
 */
@property (nonatomic,copy) NSString *YQSJ;

/**
 *  默认""
 */
@property (nonatomic,copy) NSString *ID;

/**
 *  部门中文名字
 */
@property (nonatomic,copy) NSString *NGBM;

/**
 * 内容
 */
@property (nonatomic,copy) NSString *RW;


+(instancetype) init_BaoCunBeanDic:(NSMutableDictionary *)dic;

- (instancetype) init_BaoCunBeanDic:(NSMutableDictionary *)dic;




@end
