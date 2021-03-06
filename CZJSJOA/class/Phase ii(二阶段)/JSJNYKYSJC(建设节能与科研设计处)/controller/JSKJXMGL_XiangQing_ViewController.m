//
//  JSKJXMGL_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/10.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 建设科技项目管理
#import "JSKJXMGL_XiangQing_ViewController.h"

@interface JSKJXMGL_XiangQing_ViewController ()<UITextViewDelegate>

/** 申报单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMDW;//G
/** 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;
/** 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXR;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;
/** 项目类别 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMLB;
/** 申报年份 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMNF;
/** 申请内容 */
@property (weak, nonatomic) IBOutlet UILabel *label_SQNR;
/** 剩余金额拨付(单位：元) */
@property (weak, nonatomic) IBOutlet UILabel *tetxView_JE;

/** 材料核对意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CLHDYJ;
/** 处分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CFGLDYJ;
/** 处领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_CLDYJ;
/** 局分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *tetxView_JFGLDYJ;

/** 立项 */
@property (weak, nonatomic) IBOutlet UISwitch *switch_LX;
/** 是否验收 */
@property (weak, nonatomic) IBOutlet UISwitch *switch_YS;

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

@implementation JSKJXMGL_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;

    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_KJXMSB";
         NSString *string_flowName = @"kjxmsb";
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
                         self.textView_CLHDYJ,@"CLHDYJ",
                         self.tetxView_CFGLDYJ,@"KYCYJ",
                         self.tetxView_CLDYJ,@"KYCCSYJ",
                         self.tetxView_JFGLDYJ,@"FGLDYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_CLHDYJ.delegate = self;
    self.tetxView_CFGLDYJ.delegate = self;
    self.tetxView_CLDYJ.delegate = self;
    self.tetxView_JFGLDYJ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    NSLog(@"%@",dic_list);

    self.label_XMDW.text = dic_list[@"SBDW"];
    self.label_XMMC.text = dic_list[@"XMMC"];
    self.label_LXR.text = dic_list[@"SBNAME"];
    self.label_LXDH.text = dic_list[@"LXTEL"];
    self.label_XMLB.text = dic_list[@"XMLX"];
    self.label_XMNF.text = dic_list[@"SBYJ"];
    self.label_SQNR.text = dic_list[@"ZYSFNR"];
    self.tetxView_JE.text = dic_list[@"BZZJ"];

    self.textView_CLHDYJ.text = dic_list[@"CLHDYJ"];
    self.tetxView_CFGLDYJ.text = dic_list[@"KYCYJ"];
    self.tetxView_CLDYJ.text = dic_list[@"KYCCSYJ"];
    self.tetxView_JFGLDYJ.text = dic_list[@"FGLDYJ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];

    [self add_JudgeSwitch:self.switch_LX String_Judge:dic_list[@"ISLX"]];
    [self add_JudgeSwitch:self.switch_YS String_Judge:dic_list[@"ISYS"]];
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
