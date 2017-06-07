//
//  ViewController.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/19.
//  Copyright (c) 2015年 虞海飞. All rights reserved.
//

#import "AuthHelper.h"
#import "sdkheader.h"
#import "sslvpnnb.h"

#define say_log(str) printf("[log]:%s,%s,%d:%s\n",__FILE__,__FUNCTION__,__LINE__,str)
#define say_err(err) printf("[log]:%s,%s,%d:%s,%s\n",__FILE__,__FUNCTION__,__LINE__,err,get_err())
#define get_err() ssl_vpn_get_err()

@interface ViewController : UIViewController<SangforSDKDelegate>
{
    AuthHelper *helper;
    IBOutlet UIButton *bt_login;
    IBOutlet UIButton *bt_logout;
    IBOutlet UIButton *bt_request;
    IBOutlet UIButton *bt_autologin;
    IBOutlet UIWebView *test_webview;
    IBOutlet UITextField *url_textfiled;
}

//@property (nonatomic, retain) AuthHelper *helper;
@property (nonatomic, retain) UIButton *bt_login;
@property (nonatomic, retain) UIButton *bt_logout;
@property (nonatomic, retain) UIButton *bt_request;
@property (nonatomic, retain) UIButton *bt_autologin;
@property (nonatomic, retain) UIWebView *test_webview;
@property (nonatomic, retain) UITextField *url_textfiled;
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)requestRc:(id)sender;
- (IBAction)autoLogin:(id)sender;

//http请求下载文件测试
- (void) httpRequest:(NSString *)url port:(short)port;

//http请求上传文件测试
- (void) uploadFile:(NSString *)url file:(NSString *)path;

@end

