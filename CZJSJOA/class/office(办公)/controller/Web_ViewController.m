//
//  Web_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "Web_ViewController.h"
#import "IanAlert.h"
#import "TongZhiBean.h"
#import "Office_TableViewController.h"

@interface Web_ViewController ()<Office_TableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *web;//web的用法
@property (nonatomic,assign) SELECT y;
@end

@implementation Web_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置，web 后面没有黑色条
    self.web.opaque = NO;
    self.web.backgroundColor = [UIColor clearColor];

    TongZhiBean *tongZhi = [[TongZhiBean alloc] init];
    tongZhi.gsUSERID = @"24";

    if(self.y == WYTZ){
        tongZhi.state = @"wy";
    }else{
          tongZhi.state = @"yy";
    }
    tongZhi.PageIndex = @"1";
    tongZhi.TITLE = @"";

    [self getHttpTongzhi:tongZhi];
}

-(void) getHttpTongzhi:(TongZhiBean *)tongzhi {

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    Util *util = [[Util alloc] init];
    NSString *tongZhi = [util tongZhi];
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把coo加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param=[NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&state=%@&TITLE=%@",tongzhi.gsUSERID,tongzhi.PageIndex,tongzhi.state,tongzhi.TITLE];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    if (data) {

        //请求成功
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        [self tiHuanDic:dict];

    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }
}

/**
 *  替换html文件
 *
 *  @param array <#array description#>
 */
- (void) tiHuanDic:(NSDictionary *)dict{

    //拿系统里面“context.html”文件
    NSString *homePath = [[NSBundle mainBundle] executablePath];
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];
    NSString *rawDirectory = [homePath substringToIndex:
                              [homePath length]-[executableName length]-1];
    NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" "
                                                                      withString:@"%20"];
    NSString *htmlFile = [NSString stringWithFormat:@"file://%@/context.html",baseDirectory];

    //把文件里面的数据拿出来
    NSURL *url = [NSURL URLWithString: htmlFile];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    //NSData *fileData = [NSData dataWithContentsOfFile:htmlFile];

    //得到uiview里面的样式
    NSString *htmlContent = [[NSMutableString alloc] initWithData:
                             fileData encoding:NSUTF8StringEncoding];

    //得到字典里面的数据(判读是不是有数据)
    NSDictionary *dic_01 = dict[@"message"];
    NSString *code = [NSString stringWithFormat:@"%@",dic_01[@"code"]];
    int code_int = [code intValue];

    NSString *string;
    if(code_int < 0){

        string = [NSString stringWithFormat: htmlContent,@"没有通知",@"",@"",@"",@""];
    }else{

        NSArray *array = dict[@"list"];
        NSDictionary *dic  = array[0];
        //替换里面的数据
        string = [NSString stringWithFormat: htmlContent,dic[@"TITLE"],@"作者",dic[@"NGR"],dic[@"ID"],dic[@"NGTIME"]];
    }

    [self.web loadHTMLString:string baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

#pragma  mark -- office代理方法
-(void) selectY:(SELECT)y{

    self.y = y;
}

@end
