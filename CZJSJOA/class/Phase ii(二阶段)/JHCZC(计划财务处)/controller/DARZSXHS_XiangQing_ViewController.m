//
//  DARZSXHS_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 重大融资事项会审
#import "DARZSXHS_XiangQing_ViewController.h"

@interface DARZSXHS_XiangQing_ViewController ()<UITextViewDelegate>

/** 融资事项 */
@property (weak, nonatomic) IBOutlet UILabel *label_RZSX;

/** 文档 */
//@property (weak, nonatomic) IBOutlet Tool_WebView *webView_WD;
/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 主要内容 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZYNR;
/** 经办单位负责人*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JBDWFZR;
/** 计财处意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JCCYJ;
/** 分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FFGLDYJ;
/**主要领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZYLDYJ;
/** 备注 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_BZ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;


@end

@implementation DARZSXHS_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_ZDRZSXHS";
        NSString *string_flowName = @"zdrzsxhs";

        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"YBRID"]];

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
                         self.textView_ZYNR,@"ZYNR",
                         self.textView_JBDWFZR,@"JBDWYJ",
                         self.textView_JCCYJ,@"JCCYJ",
                         self.textView_FFGLDYJ,@"FGLDYJ",
                         self.textView_ZYLDYJ,@"ZYLDYJ",
                         self.textView_BZ,@"BZ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_ZYNR.delegate = self;
    self.textView_JBDWFZR.delegate = self;
    self.textView_JCCYJ.delegate = self;
    self.textView_FFGLDYJ.delegate = self;
    self.textView_ZYLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];
    self.label_RZSX.text = dic_list[@"RZSX"];

    self.textView_ZYNR.text = dic_list[@"ZYNR"];
    self.textView_JBDWFZR.text = dic_list[@"JBDWYJ"];
    self.textView_JCCYJ.text = dic_list[@"JCCYJ"];
    self.textView_FFGLDYJ.text = dic_list[@"FGLDYJ"];
    self.textView_ZYLDYJ.text = dic_list[@"ZYLDYJ"];
    self.textView_BZ.text = dic_list[@"BZ"];
    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
//    //文档
//    NSString *string_Attachment_WD = [ChangYong_NSObject selectNulString:dic_list[@"WD"]];
//    [self.webView_FJ tool_Attachment:string_Attachment_WD];
//    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
}

//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    [self add_Process];
}

#pragma  mark -- 返回按钮
- (IBAction)clickReturn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

/************* UITextViewDelegate ***************/
#pragma  mark --  UITextViewDelegate
//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return [super textViewShouldBeginEditing:textView];
}

//键盘控制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}

@end
