//
//  AppDelegate.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/19.
//  Copyright (c) 2015年 虞海飞. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ShaXiang_NSObject *shaXiang = [[ShaXiang_NSObject alloc] init];
    
    NSString *dataFile=[[shaXiang docPath] stringByAppendingPathComponent:@"one.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:dataFile];
    
    if(nil == array){
        
        [self doAdd];
    }

   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:204/255.0 alpha:1]];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:nil forKey:@"token"];
    [accountDefaults synchronize];
    
    // Override point for customization after application launch.
    //判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge										 |UIRemoteNotificationTypeSound										 |UIRemoteNotificationTypeAlert)];
    }

    return YES;
}


/**
 *  添加数据
 */
-(void) doAdd{

    ShaXiang_NSObject *shaXiang = [[ShaXiang_NSObject alloc] init];
    NSString *docPath=[shaXiang docPath];
    
    NSString *dataFile=[docPath stringByAppendingPathComponent:@"one.plist"];
    
    if (YES==[shaXiang isFileNeedCreate:dataFile]) {
        NSLog(@"文件原先不存在，现已新建空文件！");
    }else{
        NSLog(@"文件已存在，无需创建！");
    }
    
    _plistDic = [[NSMutableArray alloc ] init];
    // 添加字典
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"未读通知",@"text",@"f44",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"已读通知",@"text",@"f15",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"未读材料",@"text",@"s11",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"已读材料",@"text",@"f24",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"任务撰写",@"text",@"f34",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"任务检索",@"text",@"f32",@"image",nil]];
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"收文待阅",@"text",@"f20",@"image",nil]];
 
    [self.plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"换一换",@"text",@"a16",@"image",nil]];
    
    [self.plistDic writeToFile:dataFile atomically:YES];//完全覆盖
    
    //添加第二个数据plist
    NSString *dataFile_02=[docPath stringByAppendingPathComponent:@"two.plist"];
    _plistDic_02 = [[NSMutableArray alloc ] init];
    // 添加字典
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"收文办理",@"text",@"e6",@"image",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"收文检索",@"text",@"f50",@"image",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"请假审核",@"text",@"a10",@"image",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"离常检索",@"text",@"a9",@"image",nil]];

    #pragma  mark -- 第二阶段
    //计财处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"基础设施配套费呈批事项",@"text",@"y29",@"image",@"JHCZC",@"SBname",@"JCSSPTFCPSX_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"重大事项会审",@"text",@"y30",@"image",@"JHCZC",@"SBname",@"DARZSXHS_List",@"CVname",nil]];

    //造价处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"审计报告传阅",@"text",@"y31",@"image",@"ZJJDC",@"SBname",@"SJBBCY_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"审计事项管理",@"text",@"y32",@"image",@"ZJJDC",@"SBname",@"SJSXGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"审计合同管理",@"text",@"y33",@"image",@"ZJJDC",@"SBname",@"SJHTGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"内审计划",@"text",@"y34",@"image",@"ZJJDC",@"SBname",@"JJSJJH_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"经责审计通知书",@"text",@"y35",@"image",@"ZJJDC",@"SBname",@"JZSJTZS_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"经责审计报告",@"text",@"y36",@"image",@"ZJJDC",@"SBname",@"ZJSJBG_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"概算审查报告传阅",@"text",@"y37",@"image",@"ZJJDC",@"SBname",@"GSSCBGCY_List",@"CVname",nil]];

    //行政服务处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"房地产企业资质初审",@"text",@"y38",@"image",@"XZFWC",@"SBname",@"FDCKFQYZZCS_List",@"CVname",nil]];
     [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"房地产开发企业资质许可报签",@"text",@"y39",@"image",@"XZFWC",@"SBname",@"FDCKFQYZZXKBQ_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"房地产开发企业资质许可件公示",@"text",@"y40",@"image",@"XZFWC",@"SBname",@"FDCKFQYZZXKJGS_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建筑业企业资质审查意见公示",@"text",@"y41",@"image",@"XZFWC",@"SBname",@"JZYQYZZSCYJGS_List",@"CVname",nil]];

    #pragma  mark -- 科研处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"工程勘察设计企业资质初审",@"text",@"y42",@"image",@"JSJNYKYSJC",@"SBname",@"GCKCSJQYZZCS_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"工程勘察设计企业资质申报业绩核查初审",@"text",@"y43",@"image",@"JSJNYKYSJC",@"SBname",@"GCKCSJQYZZYJHCCS_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"勘察设计企业诚信手册管理",@"text",@"y44",@"image",@"JSJNYKYSJC",@"SBname",@"KCSJQYCXSCGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"勘察设计企业资质证书领取",@"text",@"y45",@"image",@"JSJNYKYSJC",@"SBname",@"KCSJQYZZZSLQ_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"优秀勘察设计项目申报",@"text",@"y46",@"image",@"JSJNYKYSJC",@"SBname",@"YXKCSJXMSB_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"勘察设计企业诚信证明办理",@"text",@"y47",@"image",@"JSJNYKYSJC",@"SBname",@"KCSJQYCXZMGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"工程建设企业技术标准认证",@"text",@"y48",@"image",@"JSJNYKYSJC",@"SBname",@"GCJSQYBZSB_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"省级节能减排专项引导资金项目管理",@"text",@"y49",@"image",@"JSJNYKYSJC",@"SBname",@"SJJNQPZXYDZJXMGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建设领域推广应用新技术项目评估认定初审",@"text",@"y50",@"image",@"JSJNYKYSJC",@"SBname",@"KJCGTGXMPGRDSQB_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"民用建筑能效测评机构申报",@"text",@"y51",@"image",@"JSJNYKYSJC",@"SBname",@"MYJSNXPCJGSBLZD_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建设领域推广应用新技术出省、出市备案",@"text",@"y52",@"image",@"JSJNYKYSJC",@"SBname",@"JSLYTGYYJSCSCSBA_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"不使用太阳能热水系统评估",@"text",@"y53",@"image",@"JSJNYKYSJC",@"SBname",@"BNSYTYNRSXTSB_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"绿色建筑评价标识申报",@"text",@"y54",@"image",@"JSJNYKYSJC",@"SBname",@"LSJZPJBSSQLZD_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建设科技项目奖项申报",@"text",@"y55",@"image",@"JSJNYKYSJC",@"SBname",@"JSKJXMJXSB_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建设科技项目管理",@"text",@"y56",@"image",@"JSJNYKYSJC",@"SBname",@"JSKJXMGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"施工图设计文件审查机构认定申请",@"text",@"y57",@"image",@"JSJNYKYSJC",@"SBname",@"SGTSJWJSCJGRDSQ_List",@"CVname",nil]];

    //城市建设处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"临时占用道路管理",@"text",@"y58",@"image",@"CSJSC",@"SBname",@"LSZYDLGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"挖掘道路管理",@"text",@"y59",@"image",@"CSJSC",@"SBname",@"WJDLGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"依附城市道路管理",@"text",@"y60",@"image",@"CSJSC",@"SBname",@"YFCSDLGL_List",@"CVname",nil]];

    //公用处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"燃气行政许可事项审批流转表",@"text",@"y61",@"image",@"GYSYC",@"SBname",@"QRXZXKSXSPLZ_LIst",@"CVname",nil]];

    //城市建设处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"资金申报事项",@"text",@"y62",@"image",@"CZJSC",@"SBname",@"ZJSBSX_List",@"CVname",nil]];

    //城市综合开发管理办公室
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"规费缴纳管理",@"text",@"y63",@"image",@"CSZHKFGLBGS",@"SBname",@"GFJNGL_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"建设条件意见书会签",@"text",@"y64",@"image",@"CSZHKFGLBGS",@"SBname",@"JYTJYJSHQ_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"交付使用备案会签",@"text",@"y65",@"image",@"CSZHKFGLBGS",@"SBname",@"JFSYBAHQ_List",@"CVname",nil]];
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"地块配套市政工程项目建设书阶段会签",@"text",@"y66",@"image",@"CSZHKFGLBGS",@"SBname",@"DKPTSZGCXMJSSJDHQ_List",@"CVname",nil]];

    //宣传教育处
    [self.plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"新闻报道内容审批事项",@"text",@"y67",@"image",@"XCJYC",@"SBname",@"XCJYC_List",@"CVname",nil]];

    [self.plistDic_02 writeToFile:dataFile_02 atomically:YES];//完全覆盖
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
  //  NSLog(@"My token is:%@", token);
    NSString *temp = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *temp1 = [temp stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:temp2 forKey:@"token"];
    [accountDefaults synchronize];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


//处理收到的消息推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
    
    //    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"" otherButtonTitles:@"确定", nil ];
    //
    //    [alert show];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    if (notification) {
        //设置推送时间
        NSDate *fireDate = [NSDate date];
        notification.fireDate = fireDate;
        //设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //设置重复间隔
        //notification.repeatInterval = NSWeekCalendarUnit;
        //推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        //内容
        notification.alertBody = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 0;
        //notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSMutableDictionary *dicNotificationInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [dicNotificationInfo setObject:@"111" forKey:@"111"];
        notification.userInfo = dicNotificationInfo;
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 添加程序的处理代码
    if (notification) {
        NSLog(@"didFinishLaunchingWithOptions");
        NSDictionary *userInfo = notification.userInfo;
        
    }
}

@end
