//
//  SGTSJWJSCJGRDSQ_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/10.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "SGTSJWJSCJGRDSQ_XiangQing_ViewController.h"

@interface SGTSJWJSCJGRDSQ_XiangQing_ViewController ()<UITextViewDelegate>

/** 申请单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQDW;
/** 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;

/** 原件核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_YJHDYJ;
/** 材料核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CLHDYJ;
/** 处分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CLDYJ;

/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

@end

@implementation SGTSJWJSCJGRDSQ_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;

    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_SGSJRDSQ";
        NSString *string_flowName = @"sgsjrdsq";
        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@&state=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"YBRID"],weakDic[@"STATE"]];

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
                         self.textView_YJHDYJ,@"YJHDYJ",
                         self.tetxView_CLHDYJ,@"CLHDYJ",
                         self.tetxView_CLDYJ,@"KYCCSYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_YJHDYJ.delegate = self;
    self.tetxView_CLHDYJ.delegate = self;
     self.tetxView_CLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];
    NSLog(@"%@",dic_list);

    self.label_SQDW.text = dic_list[@"DWMC"];
    self.label_XMMC.text = dic_list[@"XMMC"];

    self.textView_YJHDYJ.text = dic_list[@"YJHDYJ"];
    self.tetxView_CLHDYJ.text = dic_list[@"CLHDYJ"];
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
