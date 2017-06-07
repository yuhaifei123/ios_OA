//
//  ChangYong_NSObject.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangYong_NSObject : NSObject

/**
 拿两位小数
 */
+ (NSString *) twoDouble: (double)a;

/**
 判断空值
 */
+ (NSString *) selectNulString:(NSString *)stye;

/**
 *得到当前时间
 *  @return <#return value description#>
 */
+(NSString *) DanQianTime;

/**
 *  判断<null>
 */
+(NSString *)judgeNullString:(NSString *)stpe;

#pragma  mark -- 截取string
/**
 *  截取string
 *
 *  @param string 字符
 *  @param chare  截取字符前面几个
 *
 *  @return 截取后字符
 */
+(NSString *)  InterceptionString:(NSString *)string Character:(int) chare;

#pragma  mark -- 得到当前时间
/**
 得到当前时间
 */
+(NSString *) shiJian_DangQian;

#pragma  mark -- 去空格去换行
/**
 *  去空格去换行
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)removeSpaceAndNewline:(NSString *)str;

#pragma  mark -- 判断sreing是不是null “”
/**
 *  判断sreing是不是null “”
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+(NSString *) judgeString:(NSString *)string;
@end
