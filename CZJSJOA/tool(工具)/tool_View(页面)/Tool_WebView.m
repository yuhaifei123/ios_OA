//
//  Tool_WebView.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/14.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "Tool_WebView.h"

//web
#import "QuickLookVC.h"
#import "DownloadData.h"

@interface Tool_WebView ()

@property(nonatomic,strong) UINavigationController *navigationController;

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@property (nonatomic,strong) DownloadData *downloadData;//下载文件

@end

@implementation Tool_WebView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
    }
    return self;
}



/**
正文的拼接和超链接
*/
- (void) tool_Content:(NSString *)string{

    NSString *pingJie;

    //判断nil
    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""]) {

        Util *util = [[Util alloc] init];
        NSString *xiaZai = [util xiaZai];

        pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<a href='",xiaZai,@"?filename=",string,@"&downname=",string,@".doc&path=&uploadtype=doc'>",string,@".doc</a><br>"];
    }

    //替换里面的数据
    NSString *string_TiHuan = [self add_HtmFileData:pingJie];

    [self loadHTMLString:string_TiHuan baseURL:nil];
}

/**
 附件的拼接和超链接 string:正文的名字，以及下载的地方
 */
- (void) tool_Attachment:(NSString *)string{

    NSString *pingJie = @"";
    Util *util = [[Util alloc] init];
    NSString *xiaZai = [util xiaZai];

    if (string != nil && ![string isEqualToString:@""]) {

        NSArray *array = [string componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组

        //不清楚，到底有几个附件，迭代出来
        for (NSString *fuJian_fj in array) {

            //把附件分层filename 与 idname
            NSArray *array = [fuJian_fj componentsSeparatedByString:@":"];

            NSString *id  = array[0];
            NSString *downname = array[1];

            pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",pingJie,@"<a href='",xiaZai,@"?filename=",id,@"&downname=",downname,@"&path=&uploadtype='>",downname,@"</a><br>"];
        }

          NSLog(@"%@",pingJie);
    }

    //替换里面的数据
    NSString *string_TiHuan = [self add_HtmFileData:pingJie];

    [self loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

/**
 *  html文件的拼接，拿到html的路劲，替换数据
 *  @return <#return value description#>
 */
- (NSString *) add_HtmFileData:(NSString *)pinJie {

    //替换html文件
    //拿系统里面“context.html”文件
    NSString *homePath = [[NSBundle mainBundle] executablePath];
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];
    NSString *rawDirectory = [homePath substringToIndex:
                              [homePath length]-[executableName length]-1];
    NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" "
                                                                      withString:@"%20"];
    NSString *htmlFile = [NSString stringWithFormat:@"file://%@/download.html",baseDirectory];

    //把文件里面的数据拿出来
    NSURL *url = [NSURL URLWithString: htmlFile];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    //NSData *fileData = [NSData dataWithContentsOfFile:htmlFile];

    //得到uiview里面的样式
    NSString *htmlContent = [[NSMutableString alloc] initWithData:
                             fileData encoding:NSUTF8StringEncoding];

    //替换里面的数据
    NSString *string_TiHuan = [NSString stringWithFormat: htmlContent,pinJie];

    return string_TiHuan;
}

/**
 *   webView的数据浏览 (点击webView 以后跳转到下个页面显示)
 *
 *  @param nav     调用者的控制器
 *  @param webView 调用者的webView
 */
-(void) tool_WebViewBrowse:(UINavigationController *)nav{

    _navigationController = nav;
  //  webView.delegate = self;
}

#pragma  mark -- uiwebView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{

    // Will execute  this block only when links are clicked
    if( navigationType == UIWebViewNavigationTypeLinkClicked ) {

        NSURL *url = [request URL];


        NSString *str1 = [url absoluteString];


        NSRange range = [str1 rangeOfString:@"downname="];
        int location = range.location;
        NSString *filename = [str1 substringFromIndex:location+9];

        range = [filename rangeOfString:@"&path"];
        location = range.location;
        filename = [filename substringToIndex:location];
        range = [filename rangeOfString:@"."];
        filename = [filename substringFromIndex:range.location];
        self.filename =[NSString stringWithFormat:@"%@%@",@"temp",filename];
        [MBProgressHUD showMessage:@"正在努力加载中...."];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

        if (connection)
        {
            self.receivedData = [NSMutableData data];//初始化接收数据的缓存
        }
        else{

            NSLog(@"Bad Connection!");
        }

        return NO;

    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];//置空数据
    long long mp3Size = [response expectedContentLength];//获取要下载的文件的长度
    NSLog(@"%@",response.MIMEType) ;
    NSLog(@"%lld",mp3Size);
}

//接收NSMutableData数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSRange range = [self.filename  rangeOfString:@".txt"];
    int bz =range.length;

    if (bz>0) {

        //判断是UNICODE编码
        NSString *isUNICODE = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        //还是ANSI编码
        NSString *isANSI = [[NSString alloc] initWithData:data encoding:-2147482062];

        if (isUNICODE) {

            NSString *retStr = [[NSString alloc]initWithCString:[isUNICODE UTF8String] encoding:NSUTF8StringEncoding];

            NSData *data1 = [retStr dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }else if(isANSI){

            NSData *data1 = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }

    }else{

        [_receivedData appendData:data];
    }
}

//接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    [MBProgressHUD hideHUD];
    //在保存文件和播放文件之前可以做一些判断，保证程序的健壮行：例如：文件是否存在，接收的数据是否完整等处理，此处没加，使用时注意
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"mp3 path=%@",documentsDirectory);
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: self.filename];//mp3Name:你要保存的文件名称，包括文件类型。如果你知道文件类型的话，可以指定文件类型；如果事先不知道文件类型，可以在- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response中获取要下载的文件类型

    //在document下创建文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    NSLog(@"mp3 path=%@",filePath);
    //将下载的数据，写入文件中
    [_receivedData writeToFile:filePath atomically:YES];

    //播放下载下来的mp3文件
    [self openfile:filePath];


    //如果下载的是图片则可以用下面的方法生成图片并显示 create image from data and set it to ImageView
    /*
     UIImage *image = [[UIImage alloc] initWithData:recvData];
     [imgView setImage:image];
     */
}

/**
 web
 */
-(void)openfile:(NSString *)filePath {

    QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];
    qu.path = filePath;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:qu animated:YES];
}


@end
