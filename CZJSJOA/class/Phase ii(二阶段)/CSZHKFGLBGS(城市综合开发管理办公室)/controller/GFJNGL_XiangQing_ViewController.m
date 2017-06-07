//
//  GFJNGL_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 规费缴纳管理
#import "GFJNGL_XiangQing_ViewController.h"

@interface GFJNGL_XiangQing_ViewController ()<UITextViewDelegate>

/** 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;
/** 建设单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_JSDW;
/** 联系人 */
@property (weak, nonatomic) IBOutlet UILabel *label_LXR;
/**联系电话*/
@property (weak, nonatomic) IBOutlet UILabel *label_LXDH;

//项目截止本次应缴
/**有无逾期欠款*/
@property (weak, nonatomic) IBOutlet UILabel *label_YWYQ;
/**基础设施配套费*/
@property (weak, nonatomic) IBOutlet UILabel *label_JCSSPTF;
/**区外配套资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_QWPTZJ;
/**市政安置房配建资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_SZAZFPTZJ;
/**经办人*/
@property (weak, nonatomic) IBOutlet UILabel *label_JBR;

//催缴情况 欠款金额
/** 欠款金额-基础设施配套费*/
@property (weak, nonatomic) IBOutlet UILabel *label_JCSSPTF_QKEE;
/**欠款金额-区外配套资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_QWPTZJ_QKEE;
/**欠款金额-市政安置房配建资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_SZAZFPTZJ_QKEE;

//催缴情况 违约金
/**违约金-基础设施配套费*/
@property (weak, nonatomic) IBOutlet UILabel *label_JCSSPTF_WYJ;
/**违约金-区外配套资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_QWPTZJ_WYJ;
/**违约金-市政安置房配建资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_SZAZFPTZJ_WYJ;
/**违约金-经办人*/
@property (weak, nonatomic) IBOutlet UILabel *label_JBR_WYJ;

//缴情况 截止本次缴款前累计已缴
/**截止本次缴款前累计已缴-基础设施配套费*/
@property (weak, nonatomic) IBOutlet UILabel *label_JCSSPTF_JZBCJJQLLYJ;
/**截止本次缴款前累计已缴-区外配套资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_QWPTZJ_JZBCJJQLLYJ;
/**截止本次缴款前累计已缴-市政安置房配建资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_SZAZFPTZJ_JZBCJJQLLYJ;

//缴情况 本次收缴
/**本次收缴-基础设施配套费*/
@property (weak, nonatomic) IBOutlet UILabel *label_JCSSPTF_BCSJ;
/**本次收缴-区外配套资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_QWPTZJ_BCSJ;
/**本次收缴-市政安置房配建资金*/
@property (weak, nonatomic) IBOutlet UILabel *label_SZAZFPTZJ_BCSJ;
/**本次收缴-经办人*/
@property (weak, nonatomic) IBOutlet UILabel *label_JBR_BCSJ;

/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 项目基本信息 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_XMJBXX;
/** 复合意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FHYJ;
/** 开发办意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_KFBYJ;
/** 记财处意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JCCYJ;
/** 备注*/
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

@implementation GFJNGL_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_GFJNGL";
        NSString *string_flowName = @"gfjngl";

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
                         self.textView_XMJBXX,@"JBXX",
                         self.textView_FHYJ,@"FHYJ",
                         self.textView_KFBYJ,@"KFBYJ",
                         self.textView_JCCYJ,@"JCCYJ",
                         self.textView_BZ,@"BZ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_XMJBXX.delegate = self;
    self.textView_FHYJ.delegate = self;
    self.textView_KFBYJ.delegate = self;
    self.textView_JCCYJ.delegate = self;
    self.textView_BZ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_XMMC.text = dic_list[@"XMMC"];
    self.label_JSDW.text = dic_list[@"JSDW"];
    self.label_LXR.text = dic_list[@"LXNAME"];
    self.label_LXDH.text = dic_list[@"LXTEL"];
    self.label_YWYQ.text = dic_list[@"YQQJ"];

    //项目截止本次应缴
    self.label_JCSSPTF.text = dic_list[@"YJJCSSF"];
    self.label_QWPTZJ.text = dic_list[@"YJQWZJ"];
    self.label_SZAZFPTZJ.text = dic_list[@"YJPJZJ"];
    self.label_JBR.text = dic_list[@"YJJBR"];
    //催缴情况 欠款金额
    self.label_JCSSPTF_QKEE.text = dic_list[@"QJJCSSF"];
    self.label_QWPTZJ_QKEE.text = dic_list[@"QJQWZJ"];
    self.label_SZAZFPTZJ_QKEE.text = dic_list[@"QJPJZJ"];
    //催缴情况 违约金
    self.label_JCSSPTF_WYJ.text = dic_list[@"WYJJCSSF"];
    self.label_QWPTZJ_WYJ.text = dic_list[@"WYJQWZJ"];
    self.label_SZAZFPTZJ_WYJ.text = dic_list[@"WYJPJZJ"];
    self.label_JBR_WYJ.text = dic_list[@"CKJBR"];

    //缴情况 截止本次缴款前累计已缴
    self.label_JCSSPTF_JZBCJJQLLYJ.text = dic_list[@"LJYJJCSSF"];
    self.label_QWPTZJ_JZBCJJQLLYJ.text = dic_list[@"LJYJQWZJ"];
    self.label_SZAZFPTZJ_JZBCJJQLLYJ.text = dic_list[@"LJYJPJZJ"];
    self.label_JBR_BCSJ.text = dic_list[@"JKJBR"];
    //缴情况 本次收缴
    self.label_JCSSPTF_BCSJ.text = dic_list[@"BCSJJCSSF"];
    self.label_QWPTZJ_BCSJ.text = dic_list[@"BCSJQWZJ"];
    self.label_SZAZFPTZJ_BCSJ.text = dic_list[@"BCSJPJZJ"];

    self.textView_XMJBXX.text = dic_list[@"JBXX"];
    self.textView_FHYJ.text = dic_list[@"FHYJ"];
    self.textView_KFBYJ.text = dic_list[@"KFBYJ"];
    self.textView_JCCYJ.text = dic_list[@"JCCYJ"];
    self.textView_BZ.text = dic_list[@"BZ"];
//    //附件
//    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
//    [self.webView_FJ tool_Attachment:string_Attachment];
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
