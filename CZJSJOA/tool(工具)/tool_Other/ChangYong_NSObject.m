//
//  ChangYong_NSObject.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "ChangYong_NSObject.h"

@implementation ChangYong_NSObject

/**
 判断空值
 */
+ (NSString *) selectNulString:(NSString *)stye{

    if ( (NSNull *) stye ==  [[NSNull alloc] init]) {
        
        return  @"";
    }else{

        return stye;
    }
}

/**
 *  判断<null>
 */
+(NSString *)judgeNullString:(NSString *)stpe{

    if ([stpe isEqualToString:@"<null>"]) {

        return @"";
    }
    return stpe;
}

/**
 拿两位小数
 */
+ (NSString *) twoDouble: (double)a{

    float b = a;
    NSString *c = [NSString stringWithFormat:@"%.2f",b];

    return  c;
}

/**
 * 得到当前时间
 *  @return<#return value description#>
 */
+(NSString *) DanQianTime{

    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；

    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
    NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；

    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day  =  [d day];

    NSString *month_string;
    NSString *day_string;

    if (month < 10) {
        month_string = [NSString stringWithFormat:@"%@%d",@"0",(int)month];
    }else{
        month_string = [NSString stringWithFormat:@"%d",(int)month];
    }

    if (day < 10) {
        day_string = [NSString stringWithFormat:@"%@%d",@"0",(int)day];
    }else{
        day_string = [NSString stringWithFormat:@"%d",(int)day];
    }
    return [NSString stringWithFormat:@"%d-%@-%@",(int)year,month_string,day_string];
}

#pragma  mark -- 截取string
/**
 *  截取string
 *
 *  @param string 字符
 *  @param chare  截取字符前面几个
 *
 *  @return 截取后字符
 */
+(NSString *)  InterceptionString:(NSString *)string Character:(int) chare{

   NSString *string_Chare = [string substringToIndex:chare];//截取掉下标2之前的字符串

    return string_Chare;
}

#pragma  mark -- 得到当前时间
/**
 得到当前时间
 */
+(NSString *) shiJian_DangQian{

    NSDate *date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];

    return  [formatter stringFromDate:date];
}

#pragma  mark -- 去空格去换行
/**
 *  去空格去换行
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str{

    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

#pragma  mark -- 判断sreing是不是null “”
/**
 *  判断sreing是不是null “”
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+(NSString *) judgeString:(NSString *)string{

    if ([string isEqualToString:@""] || [string isEqual:[NSNull null]]) {
        return @"";
    }else{

        return string;
    }
}

@end
