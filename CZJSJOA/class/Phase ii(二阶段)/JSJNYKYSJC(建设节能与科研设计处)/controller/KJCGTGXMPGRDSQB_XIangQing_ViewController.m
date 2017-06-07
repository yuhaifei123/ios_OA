//
//  KJCGTGXMPGRDSQB_XIangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/9.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 科技成果推广项目评估认定申请表(建设领域推广应用新技术项目评估认定)
#import "KJCGTGXMPGRDSQB_XIangQing_ViewController.h"

@interface KJCGTGXMPGRDSQB_XIangQing_ViewController ()<UITextViewDelegate>

/** 申请单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQDW;
/** 申请名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;
/** 申请类型 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQLX;
/** 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXR;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;

/** 标准核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_BZHDYJ;
/** 处分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CFGLDYJ;
/** 局分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_JFGLDYJ;
/** 处领导意见 */
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

@implementation KJCGTGXMPGRDSQB_XIangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;

    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_KJCGTG";
        NSString *string_flowName = @"kjcgtg";
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
                         self.textView_BZHDYJ,@"XCHCYJ",

                         
                         self.tetxView_CFGLDYJ,@"KYCYJ",
                         self.tetxView_CLDYJ,@"KYCCSYJ",
                         self.tetxView_JFGLDYJ,@"FGLDYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_BZHDYJ.delegate = self;
    self.tetxView_CFGLDYJ.delegate = self;
    self.tetxView_CLDYJ.delegate = self;
    self.tetxView_JFGLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

   // NSLog(@"%@",dic_list);

    self.label_SQDW.text = dic_list[@"QYMC"];
    self.label_XMMC.text = dic_list[@"XMMC"];
    self.label_SQLX.text = [self judge_XWLB:dic_list[@"LX"]];
    self.label_LXR.text = dic_list[@"LXNAME"];
    self.label_LXDH.text = dic_list[@"LXTEL"];

    self.textView_BZHDYJ.text = dic_list[@"XCHCYJ"];
    self.tetxView_CFGLDYJ.text = dic_list[@"KYCYJ"];
    self.tetxView_CLDYJ.text = dic_list[@"KYCCSYJ"];
    self.tetxView_JFGLDYJ.text = dic_list[@"FGLDYJ"];

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

            string_lx = @"新办";
        }
        else if ([lx isEqualToString:@"2"]){

            string_lx = @"换证";
        }
        else if ([lx isEqualToString:@"3"]){

            string_lx = @"增项";
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
