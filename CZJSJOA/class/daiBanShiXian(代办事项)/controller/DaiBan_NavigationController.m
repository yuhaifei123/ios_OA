//
//  DaiBan_NavigationController.m
//  CZJSJOA
//
//  Created by 薛伟俊 on 15/11/6.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "DaiBan_NavigationController.h"

@interface DaiBan_NavigationController ()

@end

@implementation DaiBan_NavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

/**
    当程序收到内存警告时候ViewController会调用didReceiveMemoryWarning这个方法
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    NSDictionary *dic = [self getHttp];
//    
//    NSString *string_list = dic[@"list"];
//    
//    NSArray *array_fenge = [string_list componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
//    
//    int num = 0;
//    for (NSString *string_Array in array_fenge) {
//        
//        num += string_Array.intValue;
//    }
//    
//    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",num]];
}

#pragma  mark -- 访问访问器
/**
 访问服务器
 */
- (NSDictionary *) getHttp{
    
    GetHttp *http = [[GetHttp alloc] init];
    
    Util *util = [[Util alloc] init];
    NSString *util_string = [util daiBan];
    
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *userid = [as stringForKey:@"userid"];
    
   // NSString  *pinJie = [NSString stringWithFormat:@"gsUSERID=%@",userid];
    
    //返回，dic数据
    return [http getHttpPinJie_JiaZai:@"" Util:util_string];
}

@end
