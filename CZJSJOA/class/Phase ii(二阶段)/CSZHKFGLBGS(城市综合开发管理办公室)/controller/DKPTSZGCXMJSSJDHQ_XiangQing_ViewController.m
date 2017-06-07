//
//  DKPTSZGCXMJSSJDHQ_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 地块配套市政工程项目建议书阶段会签
#import "DKPTSZGCXMJSSJDHQ_XiangQing_ViewController.h"

@interface DKPTSZGCXMJSSJDHQ_XiangQing_ViewController ()<UITextViewDelegate>

/** 编号 */
@property (weak, nonatomic) IBOutlet UILabel *label_BH;
/** 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;

/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;
/** 正文 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_ZW;

/**项目概述 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_XMGS;
/**开发办*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_KFB;
/** 城建处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_KFBZRYJ;
/** 计财处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JCC;
/** 造价监督处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZJJDC;
/** 前期分管*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_QQFG;
/** 项目分管*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_XMFG;
/** 投资分管*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_TZFG;
/** 局长意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_YZYJ;
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

/** 特殊情况下面数据 */
@property (nonatomic,copy) NSString  *string_idlist;
@property (nonatomic,copy) NSString  *string_rolelist;
@property (nonatomic,copy) NSString  *string_userlist;
@property (nonatomic,copy) NSString  *string_state;

@end

@implementation DKPTSZGCXMJSSJDHQ_XiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
     _string_state = self.dic_AllList[@"STATE"];
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_YJSJDHQ";
        NSString *string_flowName = @"jysjdhq";
        NSString *string_STATE = weakDic[@"STATE"];


        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@&state=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"YBRID"],string_STATE];

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
                         self.textView_XMGS,@"XMGK",
                         self.textView_KFB,@"KFBYJ",
                         self.textView_KFBZRYJ,@"CJCYJ",
                         self.textView_JCC,@"JCCYJ",
                         self.textView_ZJJDC,@"ZJCYJ",
                         self.textView_QQFG,@"QQFGLDYJ",
                         self.textView_XMFG,@"XMFGLDYJ",
                         self.textView_TZFG,@"TZFGLDYJ",
                         self.textView_YZYJ,@"ZYLDYJ",
                         self.textView_BZ,@"BZ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_XMGS.delegate = self;
    self.textView_KFB.delegate = self;
    self.textView_KFBZRYJ.delegate = self;
    self.textView_JCC.delegate = self;
    self.textView_ZJJDC.delegate = self;
    self.textView_QQFG.delegate = self;
    self.textView_XMFG.delegate = self;
    self.textView_TZFG.delegate = self;
    self.textView_YZYJ.delegate = self;
    self.textView_BZ.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSLog(@"%@",self.dic_ALLXiangQing);
    //是b02 二次请求数据，选择人
    NSString *string_Bz = self.dic_AllList[@"JSDE940"];
    if ([string_Bz isEqualToString:@"b02"]) {

        GetHttp *http = [[GetHttp alloc] init];
        Util *util = [Util new];
        NSString *string_Path = [util phaseTwo_YeWuGuanLi];

        NSString *string_functionCode = @"304803";
        NSString *string_tableName = @"OA_YWGL_YJSJDHQ";
        NSString *string_flowName = @"jysjdhq";


        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@&state=%@",string_functionCode,string_tableName,string_flowName,self.dic_AllList[@"ID"],self.dic_AllList[@"ID"],self.dic_AllList[@"JSDE940"],self.dic_AllList[@"YBRID"],self.string_state];

        //返回，dic数据
        NSDictionary *dic = [http getHttpPinJie_JiaZai:string_PinJie Util:string_Path];
        self.string_state = @"1";
        _string_idlist = @"";
        _string_rolelist = @"";
        _string_userlist = @"";
        NSArray *array_list = dic[@"list"];
        for (NSDictionary *dic in array_list) {

            NSString *string_SUINO = dic[@"SUINO"];
            NSString *string_SUNAME = dic[@"CODE"];
            NSString *string_nameList = dic[@"SUNAME"];

            [self.string_idlist isEqualToString: @""] ?  self.string_idlist = string_SUINO : (self.string_idlist = [NSString stringWithFormat:@"%@;%@",self.string_idlist,string_SUINO]);

            [self.string_rolelist isEqualToString: @""] ? self.string_rolelist = string_SUNAME : (self.string_rolelist = [NSString stringWithFormat:@"%@;%@",self.string_rolelist,string_SUNAME]);

            [self.string_userlist isEqualToString: @""] ? self.string_userlist = string_nameList : (self.string_userlist = [NSString stringWithFormat:@"%@;%@",self.string_userlist,string_nameList]);
        }
    }



    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_BH.text = dic_list[@"YJSID"];
    self.label_XMMC.text = dic_list[@"XMMC"];

    self.textView_XMGS.text = dic_list[@"XMGK"];
    self.textView_KFB.text = dic_list[@"KBFW"];
    self.textView_KFBZRYJ.text = dic_list[@"CJCYJ"];
    self.textView_JCC.text = dic_list[@"JCCYJ"];
    self.textView_ZJJDC.text = dic_list[@"ZJCYJ"];
    self.textView_QQFG.text = dic_list[@"QQFGLDYJ"];
    self.textView_XMFG.text = dic_list[@"XMFGLDYJ"];
    self.textView_TZFG.text = dic_list[@"TZFGLDYJ"];
    self.textView_YZYJ.text = dic_list[@"ZYLDYJ"];
    self.textView_BZ.text = dic_list[@"BZ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];

    //正文
    NSString *string_Attachment_ZW = [ChangYong_NSObject selectNulString:dic_list[@"RECORDID"]];
    [self.webView_ZW tool_Content:string_Attachment_ZW];
    [self.webView_ZW tool_WebViewBrowse:self.navigationController];

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString  *string_Name = [as stringForKey:@"username"];//名字
    NSString *string_Time = [ChangYong_NSObject DanQianTime];//当前时间
    NSString *string_userid = [as stringForKey:@"userid"];
    if ([string_userid isEqualToString: @"5"]) {

        self.textView_QQFG.text = [NSString stringWithFormat:@"%@ %@",string_Name,string_Time];
        self.textView_XMFG.text = @"";
        self.textView_TZFG.text = @"";
    }
    else if ([string_userid isEqualToString: @"10"]){

        self.textView_QQFG.text = @"";
        self.textView_XMFG.text = [NSString stringWithFormat:@"%@ %@",string_Name,string_Time];
        self.textView_TZFG.text = @"";
    }
    else if ([string_userid isEqualToString: @"11"]){

        self.textView_QQFG.text = @"";
        self.textView_XMFG.text = @"";
        self.textView_TZFG.text = [NSString stringWithFormat:@"%@ %@",string_Name,string_Time];
    }
}



//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    [self add_Process];
}

/**
 * 流程推送
 */
-(void) add_Process{

    self.liuChenBean.spyj = @"请下一步办理";

    //  NSLog(@"%@",self.dic_ALLXiangQing);
    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];
    self.liuChenBean.spyj = self.array_spyj[0];
    self.liuChenBean.id = dic_list[@"ID"];
    self.liuChenBean.bz = dic_list[@"JSDE940"];
    self.liuChenBean.tablename = self.dic_Table[@"tableName"];
    self.liuChenBean.lcname = self.dic_Table[@"flowName"];
    self.liuChenBean.issh = @"";
    self.liuChenBean.idlist = self.string_idlist;
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = self.string_userlist;
    self.liuChenBean.spyjColumn = self.array_spyj[1];
    self.liuChenBean.isdx = self.string_SwitchNO;
    self.liuChenBean.state = self.string_state;//[NSString stringWithFormat:@"%@",self.dic_AllList[@"STATE"]];
   // NSLog(@"%@",self.liuChenBean.state);
    if ([self.liuChenBean.bz isEqualToString:@"b03"]) {

        self.liuChenBean.teshu = [NSString stringWithFormat:@",{columnName:'CJCYJ',value:'%@'},{columnName:'JCCYJ',value:'%@'},{columnName:'KFBYJ',value:'%@'},{columnName:'ZJCYJ',value:'%@'}",self.textView_KFBZRYJ.text,self.textView_JCC.text,self.textView_KFB.text,self.textView_ZJJDC.text];
    }
    if ([self.liuChenBean.bz isEqualToString:@"b02"]) {

        self.liuChenBean.teshu = [NSString stringWithFormat:@",{columnName:'SUINO',value:'%@'},{columnName:'CODE',value:'%@'}",self.string_idlist,self.string_rolelist];
    }
    if ([self.liuChenBean.bz isEqualToString:@"b05"]) {

        self.liuChenBean.teshu = [NSString stringWithFormat:@",{columnName:'QQFGLDYJ',value:'%@'},{columnName:'XMFGLDYJ',value:'%@'},{columnName:'TZFGLDYJ',value:'%@'}",self.textView_QQFG.text,self.textView_XMFG.text,self.textView_TZFG.text];
    }

    NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
   // NSLog(@"%@",pinJie);
    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;

    [MBProgressHUD showMessage:@""];

    //拼接，发送数据
    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];

    NSLog(@"%@",pinJie_02);
    //访问服务器/Users/yuhaifei/Desktop/jsjoa/ios_03/ios/CZJSJOA.xcodeproj
    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];
    NSLog(@"%@",dic);
    NSString *sting_CODE = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"CODE"]];

    [MBProgressHUD hideHUD];
    //判断 code 没有数据，显示Text
    if ([sting_CODE isEqualToString:@""]) {

        [IanAlert alertError:dic[@"TEXT"] length:1.0];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    if ([sting_CODE intValue] != 1) {

        [IanAlert alertError:dic[@"TEXT"] length:1.0];
        //  [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else{

        NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];

        if ([sting_function isEqualToString:@""]) {

            [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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

#pragma  mark -- 流程推送


//键盘控制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}

@end
