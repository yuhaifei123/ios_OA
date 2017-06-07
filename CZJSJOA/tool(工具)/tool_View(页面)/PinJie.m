//
//  PinJie.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/12.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "PinJie.h"

@implementation PinJie

/**
 附件的拼接和超链接
 */
+ (void) zhenWenString:(NSString *)string_a WebView:(UIWebView *) webView{

    NSString *pingJie = @"";
    Util *util = [[Util alloc] init];
    NSString *xiaZai = [util xiaZai];

    if (![string_a isEqual:[NSNull null]] && string_a != nil && ![string_a isEqualToString:@""] && ![string_a isEqualToString:@"\n"] && ![string_a isEqualToString:@"\r"] && ![string_a isEqual:@""] && string_a.length != 0) {

        NSArray *array = [string_a componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组

        //不清楚，到底有几个附件，迭代出来
        for (NSString *fuJian_fj in array) {

            //把附件分层filename 与 idname
            NSArray *array = [fuJian_fj componentsSeparatedByString:@":"];

            NSString *id  = array[0];
            NSString *downname = array[1];

            pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",pingJie,@"<a href='",xiaZai,@"?filename=",id,@"&downname=",downname,@"&path=&uploadtype='>",downname,@"</a><br>"];
        }
    }

    //替换html文件
    //拿系统里面“context.html”文件
    NSString *homePath = [[NSBundle mainBundle] executablePath];
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];
    NSString *rawDirectory = [homePath substringToIndex:
                              [homePath length]-[executableName length]-1];
    NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" "
                                                                      withString:@"%20"];
    NSString *htmlFile = [NSString stringWithFormat:@"file://%@/download_01.html",baseDirectory];

    //把文件里面的数据拿出来
    NSURL *url = [NSURL URLWithString: htmlFile];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    //NSData *fileData = [NSData dataWithContentsOfFile:htmlFile];

    //得到uiview里面的样式
    NSString *htmlContent = [[NSMutableString alloc] initWithData:
                             fileData encoding:NSUTF8StringEncoding];

    //替换里面的数据
    NSString *string_TiHuan = [NSString stringWithFormat: htmlContent,pingJie];

    [webView loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
    
}

@end
