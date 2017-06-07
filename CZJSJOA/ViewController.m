//
//  ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/19.
//  Copyright (c) 2015年 虞海飞. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import "GetHttp.h"
#import <UIKit/UIKit.h>

#import <sys/socket.h>
#import <sys/time.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <time.h>
#import <pthread.h>

#import "ViewController.h"
#import "AuthHelper.h"
#import "ASIHTTPRequest.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MKNetworkOperation.h"
#import "MKNetworkEngine.h"

//static void *thread_func(void *param);

// 以下是认证可能会用到的认证信息 测试 58.216.242.87
short port = 443;                        //vpn设备端口号，一般为443
NSString *vpnIp =    @"58.216.242.87";  //vpn设备IP地址    测试  218.93.20.13
NSString *userName = @"czscxjsj";             //用户名认证的用户名  czscxjsj
NSString *password = @"czscxjsj";                //用户名认证的密码 czscxjsj

NSString *certName = @"";     //导入证书名字，如果服务端没有设置证书认证可以不设置
NSString *certPwd =  @"";

//PrivateMethod
@interface ViewController()
@property (weak, nonatomic) IBOutlet UITextField *name_Text;//名字
@property (weak, nonatomic) IBOutlet UITextField *pass_Text;//密码

@property (weak, nonatomic) IBOutlet UISwitch *jiDeMiMa_Swith;//记得密码
@property (weak, nonatomic) IBOutlet UISwitch *ziDongDengLu_Swith;//自动登录

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{

    [self add_LinkVpn];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    [MBProgressHUD hideHUD];
}


#pragma  mark -- 建立vpn链接
/**
 * 建立vpn链接
 */
-(void) add_LinkVpn{

    [MBProgressHUD showMessage:@"正在建立VPN链接...."];
    helper = [[AuthHelper alloc] initWithHostAndPort:vpnIp port:port delegate:self];

    //如果svpn已经注销了，就重新登陆
    if ([helper queryVpnStatus] == VPN_STATUS_LOGOUT)
    {
        NSLog(@"Svpn is logout!");
        [helper relogin];
    }

    //请求成功
    if ([helper queryVpnStatus] == VPN_STATUS_INIT_OK){

        [self panDuan];//判断自动登录
    }


}

#pragma mark -- 记得密码，自动登录。判断 fwzxxxk/056897
/**
 记得密码，自动登录。判断
 */
- (void) panDuan{
    
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *remember = [as stringForKey:@"rememberPass"];
    NSString *autoLogin = [as stringForKey:@"autologin"];//"1"自动登陆
    
    //判断是不是要记得密码 == 1，不要记得 == 0，自动登录 == 1
    if([remember isEqualToString:@"1"] ){
        
        [self.jiDeMiMa_Swith setOn:YES];
        self.name_Text.text = [as stringForKey:@"dengLuname"];
        self.pass_Text.text = [as stringForKey:@"dengLupass"];
    }else{
        
        [self.ziDongDengLu_Swith setOn:NO];
    }
    
    //判断是不是要自动登录
    if ([autoLogin isEqualToString:@"1"]){
        
        [self.ziDongDengLu_Swith setOn:YES];
        [self.jiDeMiMa_Swith setOn:YES];
        self.name_Text.text = [as stringForKey:@"dengLuname"];
        self.pass_Text.text = [as stringForKey:@"dengLupass"];
        
        [self ziDongLogin];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

/**
 *  登陆跳转
 *  @param sender <#sender description#>
 */
- (IBAction)loginButton:(id)sender {

    [self ziDongLogin];
}

#pragma  mark -- 自动登录
/**
 自动登录
 */
- (void) ziDongLogin{
    
    if([self.name_Text.text isEqualToString:@""]){

        [IanAlert alertError:@"用户名不能为空" length:1.0];

        return;
    }
    else if (self.pass_Text.text.length < 1){

        [IanAlert alertError:@"密码不能为空" length:1.0];

        return;
    }
    else{

        //添加一个遮罩，禁止用户操作
        [MBProgressHUD showMessage:@"正在努力加载中...."];

        NSString *name  = self.name_Text.text;
        name  = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去首尾空格
        NSString *pass = self.pass_Text.text;
        pass = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去首尾空格

        [self getHttpName:name Pass:pass];
    }
    
}

#pragma  mark --记得密码 0 == 不记得密码  1 == 记得密码
- (IBAction)jiDeMiMa_Button:(UISwitch *)sender {
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    //如果开启，记得密码，就是在缓存里面放一，没有
    if(sender.isOn == NO){
        
        [self.ziDongDengLu_Swith setOn:NO animated:YES];
        [accountDefaults setObject:@"0" forKey:@"rememberPass"];
    }else{
        
        [accountDefaults setObject:@"1" forKey:@"rememberPass"];
    }
    //从新设置不自动登录
    [accountDefaults setObject:@"0" forKey:@"autologin"];
    //放到磁盘里面
    [accountDefaults synchronize];
}

#pragma mark -- 自动登录 1 == 自动登录, 0 == 不自动登录
- (IBAction)ziDonDenLu_Button:(UISwitch *)sender {
    
    //缓存
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    if(sender.isOn == YES){
        
        [self.jiDeMiMa_Swith setOn:YES animated:YES];
        [accountDefaults setObject:@"1" forKey:@"autologin"];
    }else{
        
        [accountDefaults setObject:@"0" forKey:@"autologin"];
    }
    //放到磁盘里面
    [accountDefaults synchronize];
}



- (void) getHttpName:(NSString *)name Pass:(NSString *)pass{
    
    Util *util = [[Util alloc] init];
    NSString *login = [util Login];
    NSDictionary *dic =[ [NSDictionary alloc] initWithObjectsAndKeys:name,@"tt_username",pass,@"tt_password",@"",@"wtrbs",@"",@"wtr",nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:login]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:login
                                                      parameters:dic];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        // 判断数据
        NSString *code  = [NSString stringWithFormat:@"%@",content[@"code"]];
        int code_int = [code intValue];
        
        if(code_int < 0){

            [MBProgressHUD hideHUD];

            NSTimeInterval abcd = 1.0;
            [IanAlert alertError:content[@"text"] length:abcd];
            return;
        }else{
            
            //cookie存起来
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey: @"sessionCookies"];

            [self loginHttpDic:content];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

      //  NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }];

    [operation start];
    [operation waitUntilFinished];
}


/**
 *  第二次请求数据
 */
- (void) loginHttpDic:(NSDictionary *)dic{
    
    Util *util = [[Util alloc] init];
    NSString *login = [util Login_Two];
    
    GetHttp *http = [[GetHttp alloc] init];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *token =[accountDefaults stringForKey:@"token"];
    if (token==nil) {
        token = @"0";
    }
    
    NSString  *pinJie = [NSString stringWithFormat:@"token=%@",token];
    
    
    NSDictionary *dic_a = [http getHttpPinJie:pinJie Util:login];
    
    NSString *userid = [NSString stringWithFormat:@"%@",dic_a[@"userid"]];
    NSString *dept = [NSString stringWithFormat:@"%@",dic_a[@"deptid"]];
    NSString *deptname = [NSString stringWithFormat:@"%@",dic_a[@"deptname"]];
    NSString *username = [NSString stringWithFormat:@"%@",dic_a[@"username"]];
    NSString *tt_username = [NSString stringWithFormat:@"%@",dic_a[@"tt_username"]];
    //把userid 放到缓存里面去
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    [as setObject:userid forKey:@"userid"];
    [as setObject:dept forKey:@"dept"];
    [as setObject:deptname forKey:@"deptname"];
    [as setObject:username forKey:@"username"];
    [as setObject:tt_username forKey:@"dengLuname"];
    [as setObject:self.pass_Text.text forKey:@"dengLupass"];
    [as setObject:dic_a[@"role"] forKey:@"role"];
    //放到磁盘里面
    [as synchronize];
    
    //跳转到主界面
    UITabBarController *deer = [self.storyboard instantiateViewControllerWithIdentifier:@"tab"];
    //跳转效果
    [deer setModalPresentationStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:deer animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/********************* vpn delegate 方法******************/

/**
 *  判断vpn是不是链接成功
 *
 *  @param vpnErrno <#vpnErrno description#>
 *  @param authType <#authType description#>
 */
- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
{
    switch (vpnErrno)

    {
        case RESULT_VPN_INIT_FAIL:
            say_err("Vpn Init failed!");
            [MBProgressHUD hideHUD];
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            [helper clearAuthParam:@SET_RND_CODE_STR];
            say_err("Vpn auth failed!");
            [MBProgressHUD hideHUD];
            break;

        //链接成功出发事件，，，连接成功，判断自动登陆
        case RESULT_VPN_INIT_SUCCESS:
            say_log("Vpn init success!");
            
            
            if ([helper queryVpnStatus] == VPN_STATUS_INIT_OK){
            //设置认证参数 用户名和密码以数值map的形式传入
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
            //开始用户名密码认证
            [helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
            }

            break;
        case RESULT_VPN_AUTH_SUCCESS:
            [self startOtherAuth:authType];
            [MBProgressHUD hideHUD];

#warning     自动登陆  fwzxxxk/056897
            [self panDuan];
            break;
        case RESULT_VPN_AUTH_LOGOUT:
            say_log("Vpn logout success!");
            [MBProgressHUD hideHUD];
            break;
        case RESULT_VPN_OTHER:
            if (VPN_OTHER_RELOGIN_FAIL == (VPN_RESULT_OTHER_NO)authType) {
                say_log("Vpn relogin failed, maybe network error");
            }
            break;
            
        case RESULT_VPN_NONE:
            break;
            
        default:
            break;
    }
}

- (void) onReloginCallback:(const int)status result:(const int)result
{
    switch (status) {
        case START_RECONNECT:
            NSLog(@"vpn relogin start reconnect ...");
            break;
        case END_RECONNECT:
            NSLog(@"vpn relogin end ...");
            if (result == SUCCESS) {
                NSLog(@"Vpn relogin success!");
            } else {
                NSLog(@"Vpn relogin failed");
            }
            break;
        default:
            break;
    }
}

- (void) startOtherAuth:(const int)authType
{
    NSArray *paths = nil;
    switch (authType)
    {
        case SSL_AUTH_TYPE_CERTIFICATE:
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
            
            if (nil != paths && [paths count] > 0)
            {
                NSString *dirPaths = [paths objectAtIndex:0];
                NSString *authPaths = [dirPaths stringByAppendingPathComponent:certName];
                NSLog(@"PATH = %@",authPaths);
                [helper setAuthParam:@CERT_P12_FILE_NAME param:authPaths];
                [helper setAuthParam:@CERT_PASSWORD param:certPwd];
            }
            say_log("Start Cert Auth!!!");
            break;
            
        case SSL_AUTH_TYPE_PASSWORD:
            say_log("Start Password Name Auth!!!");
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
            
            break;
        case SSL_AUTH_TYPE_NONE:
            say_log("Auth success!!!");
            return;
        default:
            say_err("Other failed!!!");
            return;
    }
    [helper loginVpn:authType];
}

- (IBAction)login:(id)sender
{
    //设置认证参数 用户名和密码以数值map的形式传入
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
    //开始用户名密码认证
    [helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
}

- (IBAction)logout:(id)sender
{
    //注销用户登陆
    [helper logoutVpn];
}

-(IBAction)autoLogin:(id)sender
{
    //如果svpn已经注销了，就重新登陆
    if ([helper queryVpnStatus] == VPN_STATUS_LOGOUT)
    {
        NSLog(@"Svpn is logout!");
        [helper relogin];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webview start loading==========");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webview did finish load=========");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"did failed load with error %@", error);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(nonnull NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

//请求内网资源信息
//IBAction
-(void)requestRc:(id)sender
{
    //使用webview
   // NSString *url = [url_textfiled text];
    //    NSLog(@"load url ===========");
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    //webviewj加载页面
    //    [test_webview loadRequest:request];
    
    //使用ASI 进行http访问
    //    [self ASIHttpRequestDemo];
    
    //使用AFNetwork库进行访问
    //   [self AFHttpRequestDemo];
    
    //使用普通的NSURLRequest 进行http访问
    //    [self NSURLRequestHttpRequest];
    
    //使用MKNETWork库进行请求
    //  [self MKHttpRequestDemo];
}

-(void) NSURLRequestHttpRequest
{
    NSString *postData = @"&param={transcode:'KJ0001',userID:1,formParam:{zjlx:'1',zjhm:'513022198601188625',pwd:'188625'}}";
    NSData *data = [postData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
    NSURL *baseUrl = [NSURL URLWithString:@"http://172.16.5.8:9098/kj_mobile/api/service/"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *retdata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
    }
    if (retdata)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:retdata encoding:NSUTF8StringEncoding]);
    }
}



//http请求下载文件测试
- (void) httpRequest:(NSString *)host port:(short)port
{
    NSAssert(host != nil, @"host is nil");
    
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1)
    {
        NSLog(@"socket failed int httpRequest!");
        return ;
    }
    char buffer[4096];
    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    in_addr_t inaddr = INADDR_NONE;
    //说明是ip地址形势
    if ((inaddr = inet_addr([host UTF8String])) != INADDR_NONE)
    {
        addr.sin_addr.s_addr = inaddr;
    }
    else
    {
        struct hostent *hostent = gethostbyname([host UTF8String]);
        if (hostent != NULL)
        {
            if ((hostent->h_addrtype == AF_INET) &&
                (hostent->h_addr_list != NULL))
            {
                inaddr = *((uint32_t *)(hostent->h_addr_list[0]));
            }
        }
        if (inaddr == INADDR_NONE)
        {
            NSLog(@"gethostbyname failed<%@>",host);
            goto failed;
        }
        addr.sin_addr.s_addr = inaddr;
    }
    if (connect(sockfd, (struct sockaddr *)&addr ,sizeof(struct sockaddr_in)) < 0)
    {
        NSLog(@"connect socket failed!");
        goto failed;
    }
    
    const char *httpRequeset =  "GET / HTTP/1.0\r\n"
    "Accept: application/xaml+xml\r\n"
    "Accept-Language: zh-cn\r\n"
    "Accept-Encoding: deflate\r\n"
    "User-Agent: Mozilla/4.0\r\n"
    "Host: %s\r\n"
    "Connection: close\r\n\r\n";
    
    snprintf(buffer, sizeof(buffer)-1 ,httpRequeset,[host UTF8String]);
    buffer[sizeof(buffer) -1] = 0;
    
    if (write(sockfd, buffer, strlen(buffer)) < 0)
    {
        NSLog(@"write failed");
        goto failed;
    }
    
    if (recv(sockfd, buffer, sizeof(buffer) - 1, 0) < 0)
    {
        NSLog(@"recv failed");
        goto failed;
    }
    
    NSLog(@"%s",buffer);
    
failed:
    if (sockfd != -1)
    {
        close(sockfd);
    }
}

//上传文件的测试
- (void) uploadFile:(NSString *)url file:(NSString *)filename
{
    NSAssert(url != nil,  @"url is nil!");
    NSAssert(filename != nil, @"path is nil");
    
    NSString *value = @"7dda656083c";
    
    //创建request对象
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //设置请求的方法
    [request setHTTPMethod:@"POST"];
    
    //设置http请求的content－type
    NSString *content =[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=-----------%@",value];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    NSData *bodyData = [self fileToBodyData:filename boundary:value];
    
    //设置数据的长度值
    [request setValue:[NSString stringWithFormat:@"%d",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"200.200.72.19" forHTTPHeaderField:@"Host"];
    
    //设置body的的数据段
    [request setHTTPBody:bodyData];
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (result != nil)  {
        NSString *outString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",outString);
    }
}

- (NSData *) fileToBodyData:(NSString *)filename boundary:(NSString *)boundary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSData *data = nil;
    if (nil != paths && [paths count] > 0)
    {
        NSString *dirPaths = [paths objectAtIndex:0];
        NSString *authPaths = [dirPaths stringByAppendingPathComponent:filename];
        data = [NSData dataWithContentsOfFile:authPaths];
    }
    
    NSString *value1 = [NSString stringWithFormat:@"-------------%@\r\n",boundary];
    NSString *value2 = [NSString stringWithFormat:@"-------------%@--\r\n",boundary];
    NSMutableData *result = [NSMutableData data];
    
    NSString *format1 = @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: text/plain\r\n\r\n";
    NSString *tmpString = [NSString stringWithFormat:format1, filename];
    //添加boundary
    [result appendData:[value1 dataUsingEncoding:NSUTF8StringEncoding]];
    //添加xml的信息
    [result appendData:[tmpString dataUsingEncoding:NSUTF8StringEncoding]];
    //添加文件内容
    [result appendData:data];
    [result appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[value1 dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *format2 =
    @"Content-Disposition: form-data; name=\"submit\"\r\n\r\n";
    [result appendData:[format2 dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[@"Submit\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[value2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    return result;
}

@end
