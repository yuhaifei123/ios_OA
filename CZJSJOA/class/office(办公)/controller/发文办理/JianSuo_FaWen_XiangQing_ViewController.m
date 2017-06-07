//
//  JianSuo_FaWen_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/27.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "JianSuo_FaWen_XiangQing_ViewController.h"
#import "JianSuo_FaWen_ViewController.h"
#import "QuickLookVC.h"

@interface JianSuo_FaWen_XiangQing_ViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIWebViewDelegate,JianSuo_FaWen_ViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *all_ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *biaoTi_Text;//标题

@property (weak, nonatomic) IBOutlet UITextView *qianFa_TxetView;//签发_TextView
@property (weak, nonatomic) IBOutlet UITextView *huiQian_TextView;//会签_TextView
@property (weak, nonatomic) IBOutlet UITextView *banGongShi_TextView;//办公室核稿_TextView
@property (weak, nonatomic) IBOutlet UITextView *huiGao_TextView;//会搞_TextView
@property (weak, nonatomic) IBOutlet UITextView *danWeiYiJian_TxtView;//单位意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMenYiJian_01_TextView;//部门意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *fenFaFnWei_TextView;//分发范围_TextView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoShenYue_TextView;//领导审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoYiJian_TextView;//领导意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMengShenYue_textView;//部门审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMengYiJian_TextView;//部门意见_TextView  上面
@property (weak, nonatomic) IBOutlet UIWebView *zhenWen_Web;//正文_Web
@property (weak, nonatomic) IBOutlet UIWebView *fuJian_Web;//附件_Web

@property (nonatomic,strong) NSDictionary *dic_swdj;//dic_swdj
@property (nonatomic,strong) NSDictionary *dic_FaWen;//发文办理传递过来的数据

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@end

@implementation JianSuo_FaWen_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self sheZhiTextView_ShuXing];

     [self tianJia_ShuJuDic:[self getHttpDic:self.dic_FaWen]];

    self.zhenWen_Web.delegate = self;
    self.fuJian_Web.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************************** 基本方法 *************************/
#pragma mark -- 基本方法

/**
 设置UiTextView的属性
 */
- (void) sheZhiTextView_ShuXing{

    [self textView_BianKuanTextView:self.qianFa_TxetView Text:@""];
    [self textView_BianKuanTextView:self.huiQian_TextView Text:@""];
    [self textView_BianKuanTextView:self.banGongShi_TextView Text:@""];
    [self textView_BianKuanTextView:self.huiGao_TextView Text:@""];
    [self textView_BianKuanTextView:self.danWeiYiJian_TxtView Text:@""];
    [self textView_BianKuanTextView:self.buMenYiJian_01_TextView Text:@""];
    [self textView_BianKuanTextView:self.fenFaFnWei_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoShenYue_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoYiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.buMengShenYue_textView Text:@""];
    [self textView_BianKuanTextView:self.buMengYiJian_TextView Text:@""];

    self.all_ScrollView.delegate = self;
}

/**
 textView设置边框
 (UITextView *)txetView 对象， Text:(NSString *)text 需要显示的文字
 */
- (void) textView_BianKuanTextView:(UITextView *)txetView Text:(NSString *)text{

    //内容框设置
    txetView.layer.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor;
    txetView.layer.borderWidth =1.0;
    txetView.layer.cornerRadius =5.0;
    txetView.text = @"";

    txetView.delegate = self;
    txetView.userInteractionEnabled = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

#pragma  mark -- 访问访问器
/**
 访问服务器
 */
- (NSDictionary *) getHttpDic:(NSDictionary *)dic{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util faWen_NeiRong];

    NSString  *pinJie = [NSString stringWithFormat:@"ID=%@&bz=%@",dic[@"ID"],dic[@"JSDE940"]];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 view添加数据
 */
- (void) tianJia_ShuJuDic:(NSDictionary *)dic{

    self.dic_swdj = dic[@"swdj"];

    self.biaoTi_Text.text = self.dic_swdj[@"TITLE"];
    self.banGongShi_TextView.text = self.dic_swdj[@"BGSHGSYJ"];
    self.qianFa_TxetView.text = self.dic_swdj[@"ZYYJ"];
    self.huiQian_TextView.text = self.dic_swdj[@"QFYJ"];
    self.huiGao_TextView.text = self.dic_swdj[@"HGYJ"];
    self.danWeiYiJian_TxtView.text = self.dic_swdj[@"DWYJ"];
    self.buMenYiJian_01_TextView.text = self.dic_swdj[@"BMYJ"];
    
    self.fenFaFnWei_TextView.text = self.dic_swdj[@"NBYJ"];
    self.lingDaoShenYue_TextView.text = self.dic_swdj[@"LDSHYJ"];
    self.lingDaoYiJian_TextView.text = self.dic_swdj[@"LDYJ"];
    self.buMengShenYue_textView.text = self.dic_swdj[@"BMYJQM"];
    self.buMengYiJian_TextView.text = self.dic_swdj[@"BMHGYJ"];

    //正文
    [self zhenWenString:self.dic_swdj[@"RECORDID"]];
    [self fuJianString:self.dic_swdj[@"FJNAME"]];
}

/**
 正文的拼接和超链接
 */
- (void) zhenWenString:(NSString *)string{

    NSString *pingJie;

    //判断nil
    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""]) {

        Util *util = [[Util alloc] init];
        NSString *xiaZai = [util xiaZai];

        pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<a href='",xiaZai,@"?filename=",string,@"&downname=",string,@".doc&path=&uploadtype=doc'>",string,@".doc</a><br>"];
    }

    //替换里面的数据
    NSString *string_TiHuan = [self add_HtmFileData:pingJie];

    [self.zhenWen_Web loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

/**
 附件的拼接和超链接
 */
- (void) fuJianString:(NSString *)string{

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
    }

    //替换里面的数据
    NSString *string_TiHuan = [self add_HtmFileData:pingJie];
    
    [self.fuJian_Web loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
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

/************************** 代理方法 *************************/
#pragma mark -- 代理方法
- (void) addDic:(NSDictionary *)dic{

    self.dic_FaWen = dic;
}

/**
 web代理
 */
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
        }else{

           // NSLog(@"Bad Connection!");
        }
        
        return NO;
        
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_receivedData setLength:0];//置空数据
    long long mp3Size = [response expectedContentLength];//获取要下载的文件的长度
//    NSLog(@"%@",response.MIMEType) ;
//    NSLog(@"%lld",mp3Size);

}

//接收NSMutableData数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
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
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
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
   // NSLog(@"mp3 path=%@",filePath);
    //将下载的数据，写入文件中
    [_receivedData writeToFile:filePath atomically:YES];
    
    //播放下载下来的mp3文件
    [self openfile:filePath];
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
