//
//  CaiLIaoWeb_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "CaiLIaoWeb_ViewController.h"
#import "CaiLiao_TableViewController.h"
#import "GetHttp.h"
#import "Util.h"

#import "QuickLookVC.h"

@interface CaiLIaoWeb_ViewController ()<CaiLiao_TableViewControllerDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *caiLiaoWeb;//web

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) int y;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@end

@implementation CaiLIaoWeb_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //不自动，定位大小
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置，web 后面没有黑色条
    self.caiLiaoWeb.opaque = NO;
    self.caiLiaoWeb.backgroundColor = [UIColor clearColor];
    self.caiLiaoWeb.delegate =self;
    }

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    GetHttp *http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    
    NSString *util_String;
    if(self.y == 0 || self.y == 1 ){
        
        util_String = [util tongZhi_web];
    }else{
        
        util_String = [util caiLiao_Web];
    }
    
    //得到服务器数据
    //把userid 放到缓存里面去
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    //得到缓存里面的id
    NSString *userid = [as stringForKey:@"userid"];
    NSDictionary *dic =  [http getHttpCaiLiao:userid ID:self.ID Util:util_String];
    [self tiHuanDic:dic];
}

- (void) viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
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

    //判断（通知还是材料）
    NSString *string;
    NSDictionary *dic;
    if(code_int < 0){

        string = [NSString stringWithFormat: htmlContent,@"没有材料",@"",@"",@"",@"",@""];
    }else{

        if(self.y== 1 || self.y == 0){

            dic = dict[@"tzfbdetail"];
            NSString *pinJie =  [self pinJieFuJianDic:dic];//判读是不是有附件

             NSString *pinJie_All = [NSString stringWithFormat:@"%@%@",dic[@"CONTENT"],pinJie];
            //替换里面的数据
            string = [NSString stringWithFormat: htmlContent,dic[@"TITLE"],@"作者",dic[@"NGR"],dic[@"ID"],dic[@"NGTIME"],pinJie_All];
        }else{

            dic = dict[@"maildetail"];
           NSString *pinJie = [self pinJieFuJianDic:dic];//判读是不是有附件

            NSString *pinJie_All = [NSString stringWithFormat:@"%@%@",dic[@"ZW"],pinJie];
            //替换里面的数据
            string = [NSString stringWithFormat: htmlContent,dic[@"TITLE"],@"作者",dic[@"NGR"],dic[@"ID"],dic[@"NGTIME"],pinJie_All];
        }
    }

    [self.caiLiaoWeb loadHTMLString:string baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

/**
 *  拼接附件
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
- (NSString *) pinJieFuJianDic:(NSDictionary *)dic{

    NSString *fuJian = dic[@"FJNAME"];

    /**
     判断空值
     */
    if ( (NSNull *) fuJian ==  [[NSNull alloc] init]) {

        return @"";
    }else{

        Util *util = [[Util alloc] init];
        NSString *yuanShi = [util yuanShi];//得到原始，路径
        NSArray *array = [fuJian componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组
        NSString *pingjie_all = @"<br><br><HR style='border:1 dashed #987cb9' width='100%' color=gray SIZE=1>附件:";
        //不清楚，到底有几个附件，迭代出来
        for (NSString *fuJian_Pdf in array) {

            //把附件分层filename 与 idname
            NSArray *array = [fuJian_Pdf componentsSeparatedByString:@":"];

            NSString *filename  = array[0];
            NSString *downname = array[1];

            NSString *href = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"<br><a href='",yuanShi,@"app/tt_downloadfile.do",@"?filename=",filename,@"&downname=",downname,@"&path=&uploadtype='>",downname,@"</a>"];

            pingjie_all = [NSString stringWithFormat:@"%@%@",pingjie_all,href];

        }
            return  pingjie_all;
    }
}


//webview调用safari浏览
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//{
//    // [retain ]
//    NSURL *requestURL =[request URL] ;
//    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
//        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
//        //autorelease ]
//        return ![ [ UIApplication sharedApplication ] openURL:requestURL];
//    }

  //  [ requestURL release ];
//    return YES;
//}

/**
 webview调用safari浏览
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
   // Will execute this block only when links are clicked
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
        else
        {
            NSLog(@"Bad Connection!");
        }
        [request release];
        [connection release];
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
    }
    else if(isANSI){
        
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
 webview调用safari浏览
 */
-(void)openfile:(NSString *)filePath {

    QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];
    qu.path = filePath;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:qu animated:YES];

}


#pragma  mark -- 材料table的代理
- (void) addId:(NSString *)id Y:(int)y{

    self.ID = id;
    self.y = y;
}

@end
