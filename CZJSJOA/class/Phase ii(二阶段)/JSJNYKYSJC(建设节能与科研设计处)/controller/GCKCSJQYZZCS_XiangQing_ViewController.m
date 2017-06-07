//
//  GCKCSJQYZZCS_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 工程勘察设计企业资质初审详细
#import "GCKCSJQYZZCS_XiangQing_ViewController.h"

@interface GCKCSJQYZZCS_XiangQing_ViewController ()<UITextViewDelegate>

/** 申请单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQDW;
/** 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXR;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;
/** 申请类型 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQLX;
/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 申请内容 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_SQNR;
/** 原件核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_YJHDYJ;
/** 标准核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_BZHDYJ;
/** 处领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CLDYJ;
/** 局分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JFGLDYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

@end

@implementation GCKCSJQYZZCS_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_KCZZCS";
        NSString *string_flowName = @"kczzcs";
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

    self.dic_AllLianXi = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.textView_SQNR,@"SQNR",
                         self.textView_YJHDYJ,@"KYCYJYJ",
                         self.textView_BZHDYJ,@"BZHDYJ",
                         self.tetxView_CLDYJ,@"KYCCSYJ",
                         self.textView_JFGLDYJ,@"FGLDYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:self.dic_AllLianXi];

    self.textView_SQNR.delegate = self;
    self.textView_YJHDYJ.delegate = self;
    self.textView_BZHDYJ.delegate = self;
    self.tetxView_CLDYJ.delegate = self;
    self.textView_JFGLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_SQDW.text = dic_list[@"DWMC"];
    self.label_LXR.text = dic_list[@"FRDB"];
    self.label_LXDH.text = dic_list[@"FRTEL"];
    self.textView_SQNR.text = dic_list[@"SQZZ"];
    self.label_SQLX.text = [self judge_XWLB:dic_list[@"SQLB"]];

    self.textView_YJHDYJ.text = dic_list[@"KYCYJYJ"];
    self.textView_BZHDYJ.text = dic_list[@"BZHDYJ"];
    self.tetxView_CLDYJ.text = dic_list[@"KYCCSYJ"];
    self.textView_JFGLDYJ.text = dic_list[@"FGLDYJ"];
    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
}

/**
 *  运营类别判断
 *
 *  @param xwlb 常数
 *
 *  @return 变成的数据
 */
-(NSString *) judge_XWLB:(NSString *)xwlb{

    NSArray *array = [xwlb componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSString *sjlx = @"";
    for (NSString *lx in array) {

        NSString *string_lx = @"";
        if ([lx isEqualToString:@"1"]) {

            string_lx = @"核准";
        }
        else if ([lx isEqualToString:@"2"]){

            string_lx = @"补正";
        }
        else if ([lx isEqualToString:@"3"]){

            string_lx = @"升级";
        }
        else if ([lx isEqualToString:@"4"]){

            string_lx = @"证书变更";
        }
        else if ([lx isEqualToString:@"5"]){

            string_lx = @"增项";
        }
        else if ([lx isEqualToString:@"6"]){

            string_lx = @"证书增补";
        }
        else if ([lx isEqualToString:@"7"]){

            string_lx = @"延续";
        }

        [sjlx isEqualToString:@""] ? (sjlx = [NSString stringWithFormat:@"%@",string_lx]) : (sjlx = [NSString stringWithFormat:@"%@,%@",sjlx,string_lx]);
    }
    
    return sjlx;
}

//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    [self add_Process];
}

#pragma  mark -- 返回按钮
- (IBAction)clickReturn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark --  AllListDelegate
-(void)AllList_Dic:(NSDictionary *)dic Dic_Table:(NSDictionary *)dic_Table{
    [super AllList_Dic:dic Dic_Table:dic_Table];
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
