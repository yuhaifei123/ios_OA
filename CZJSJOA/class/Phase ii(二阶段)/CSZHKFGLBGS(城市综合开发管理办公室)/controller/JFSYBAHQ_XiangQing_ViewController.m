//
//  JFSYBAHQ_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 交付使用备案会签
#import "JFSYBAHQ_XiangQing_ViewController.h"

@interface JFSYBAHQ_XiangQing_ViewController ()<UITextViewDelegate>

/** 开发公司名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_KFGSMC;
/** 法人代表 */
@property (weak, nonatomic) IBOutlet UILabel *label_FRDB;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;
/** 本次交付批次*/
@property (weak, nonatomic) IBOutlet UILabel *label_BCJFPC;
/** 公安编号*/
@property (weak, nonatomic) IBOutlet UILabel *label_GABH;
/**对应施工编号*/
@property (weak, nonatomic) IBOutlet UILabel *label_DYSGBH;
/** 交付建筑面积*/
@property (weak, nonatomic) IBOutlet UILabel *label_JFJZMJ;

/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 经办人意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JBRYJ;
/**复核人意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FHRYJ;
/** 开发办主任意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_KFBZRYJ;
/** 分管局领导意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FGJLDYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

@end

@implementation JFSYBAHQ_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_JFSYHQ";
        NSString *string_flowName = @"jfsyhq";

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
                         self.textView_JBRYJ,@"JBRYJ",
                         self.textView_FHRYJ,@"FZRYJ",
                         self.textView_KFBZRYJ,@"ZRYJ",
                         self.textView_FGJLDYJ,@"FGLDYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_JBRYJ.delegate = self;
    self.textView_FHRYJ.delegate = self;
    self.textView_KFBZRYJ.delegate = self;
    self.textView_FGJLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_KFGSMC.text = dic_list[@"GSMC"];
    self.label_FRDB.text = dic_list[@"FDDBR"];
    self.label_LXDH.text = dic_list[@"FDTEL"];
    self.label_BCJFPC.text = dic_list[@"BCJFPC"];
    self.label_GABH.text = dic_list[@"GAID"];
    self.label_DYSGBH.text = dic_list[@"DYSGID"];
    self.label_JFJZMJ.text = dic_list[@"BQJZMJ"];
    
    self.textView_JBRYJ.text = dic_list[@"JBRYJ"];
    self.textView_FHRYJ.text = dic_list[@"FZRYJ"];
    self.textView_KFBZRYJ.text = dic_list[@"ZRYJ"];
    self.textView_FGJLDYJ.text = dic_list[@"FGLDYJ"];

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
