//
//  XCJYC_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "XCJYC_XiangQing_ViewController.h"

@interface XCJYC_XiangQing_ViewController ()<UITextViewDelegate>

/** 记者姓名 */
@property (weak, nonatomic) IBOutlet UILabel *label_JZXM;
/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *label_XWBT;
/** 新闻类别 */
@property (weak, nonatomic) IBOutlet UILabel *label_XWLB;
/** 记者单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_JZDW;

/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 处领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CLDYJ;
/** 分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FGLDYJ;
/** 主要领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZYLDYJ;
/** 宣传处意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_XCCYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

@end

@implementation XCJYC_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_XWBDSG";
        NSString *string_flowName = @"xwbdsg";
        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"]];

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
                         self.textView_CLDYJ,@"CLDYJ",
                         self.textView_XCCYJ,@"XJCYJ",
                         self.textView_FGLDYJ,@"FGLDYJ",
                         self.textView_ZYLDYJ,@"ZYLDYJ",
                         nil];
   self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_CLDYJ.delegate = self;
    self.textView_XCCYJ.delegate = self;
    self.textView_FGLDYJ.delegate = self;
    self.textView_ZYLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_JZXM.text = dic_list[@"JZNAME"];
    self.label_XWBT.text = dic_list[@"XWBT"];
    self.label_XWLB.text = [self judge_XWLB: dic_list[@"XWLX"]];
    self.label_JZDW.text = dic_list[@"JZDW"];

    self.textView_CLDYJ.text = dic_list[@"BMYJ"];
    self.textView_FGLDYJ.text = dic_list[@"FGLDYJ"];
    self.textView_ZYLDYJ.text = dic_list[@"ZYLDYJ"];
    self.textView_XCCYJ.text = dic_list[@"XJCYJ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
}

/**
 *  新闻类别判断
 *
 *  @param xwlb <#xwlb description#>
 *
 *  @return <#return value description#>
 */
-(NSString *) judge_XWLB:(NSString *)xwlb{

    NSArray *array = [xwlb componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSString *sjlx = @"";
    for (NSString *lx in array) {

        NSString *string_lx = @"";
        if ([lx isEqualToString:@"1"]) {

            string_lx = @"头版发布稿件";
        }
        else if ([lx isEqualToString:@"2"]){

             string_lx = @"重点工程、工作稿件";
        }
        else if ([lx isEqualToString:@"3"]){

            string_lx = @"重大社会热点稿件";
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
