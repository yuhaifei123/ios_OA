//
//  KCSJQYZZZSLQ_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/9.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 勘察设计企业资质证书领取详情
#import "KCSJQYZZZSLQ_XiangQing_ViewController.h"

@interface KCSJQYZZZSLQ_XiangQing_ViewController ()<UITextViewDelegate>

/** 申请单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQDW;
/** 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXR;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;
/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;
/** 标准核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_BZHDYJ;
/** 处领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CLDYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

@end

@implementation KCSJQYZZZSLQ_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;

    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_KCZZLQ";
        NSString *string_flowName = @"kczzlq";
        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&state=%@&ybrid=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"STATE"],weakDic[@"YBRID"]];

        return string_PinJie;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //判断提交按钮是不是要显示
    if (![self.dic_AllList[@"STATES"] isEqualToString:@"未办"]) {

        self.button_Submit.hidden = YES;
        self.layout_ReturnWidth.constant = 100;
        //禁止自动转换AutoresizingMask
        self.button_Return.translatesAutoresizingMaskIntoConstraints = NO;
        //居中
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:self.button_Return
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1
                                  constant:0]];

    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.textView_BZHDYJ,@"BZHDYJ",
                         self.tetxView_CLDYJ,@"KYCCSYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_BZHDYJ.delegate = self;
    self.tetxView_CLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_SQDW.text = dic_list[@"DWMC"];
    self.label_LXR.text = dic_list[@"LXR"];
    self.label_LXDH.text = dic_list[@"LXTEL"];

    self.textView_BZHDYJ.text = dic_list[@"BZHDYJ"];
    self.tetxView_CLDYJ.text = dic_list[@"KYCCSYJ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
}

//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    [self add_Process];
}

#pragma  mark -- 返回按钮
- (IBAction)clickReturn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
