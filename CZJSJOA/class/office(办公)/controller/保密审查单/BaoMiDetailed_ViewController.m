//
//  BaoMiDetailed_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "BaoMiDetailed_ViewController.h"
#import "BaoMi_ViewController.h"
#import "Tool_TextView.h"


//web
#import "QuickLookVC.h"

@interface BaoMiDetailed_ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label_Name;//申请人名字
@property (weak, nonatomic) IBOutlet UILabel *label_Department;//申请部门
@property (weak, nonatomic) IBOutlet UILabel *label_Time;//时间
@property (weak, nonatomic) IBOutlet UISwitch *swith_SMS;//发送短信
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_Content;//正文
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_Attachment;//附件
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CBRYJ;//承办人意见
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CSFZRYJ;//处室负责人意见
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FGLDYJ;//分管领导意见
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZYSC;//专业审查
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FHSC;//复核审查
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CXSC;//程序审查
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FBR;//发布人

//流程
@property (nonatomic,strong) LiuChenBean *liuChenBean;//流程bean
@property (nonatomic,strong) FaSongShuJu *faSongShuJu;//发送数据
@property (nonatomic, strong)  NSArray *array_person ;//流程返回_dic 节点

//详细数据
@property (nonatomic,strong) NSDictionary *dic_DetailedData;

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@end

@implementation BaoMiDetailed_ViewController

#pragma  mark -- 懒加载
-(LiuChenBean *) liuChenBean{

    if (_liuChenBean == nil) {

        _liuChenBean = [LiuChenBean new];
    }
    return _liuChenBean;
}

- (FaSongShuJu *)faSongShuJu{


    if (_faSongShuJu == nil) {

        _faSongShuJu = [[FaSongShuJu alloc] init];
    }

    return _faSongShuJu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self add_View];
}

//请求网络数据
-(void) add_GetHttp_CellId:(int) cellId{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util baoMi_Detailed];

    NSString  *pinJie =[NSString stringWithFormat:@"ywid=%d&type=sp&tableName=oa_bmscd&flowName=bmscd&functionCode=209904",cellId];

    //返回，dic数据
    NSDictionary *dic = [http getHttpPinJie_JiaZai:pinJie Util:util_string];

    if (dic) {

        [self add_ParsingDataDic:dic];
    }
}

/**
 *  解析数据,网络返回数据
 */
-(void) add_ParsingDataDic:(NSDictionary *)dic{

    NSArray *array_Data = dic[@"list"];
    _dic_DetailedData = array_Data[0];
}

/**
 *  view添加属性
 */
-(void) add_View{

    self.label_Name.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"SQR"]];
    self.label_Department.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"SQBM"]];
    self.label_Time.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"SQSJ"]];
    self.textView_CBRYJ.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"CBRYJ"]];
    self.textView_CSFZRYJ.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"CSFZRYJ"]];
    self.textView_FGLDYJ.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"FGLDYJ"]];
    self.textView_ZYSC.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"ZYSC"]];
    self.textView_FHSC.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"FHSC"]];
    self.textView_CXSC.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"CXSC"]];
    self.textView_FBR.text = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"FBR"]];

    //正文
    NSString *string_Content = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"RECORDID"]];
    //添加html数据
    [self.webView_Content tool_Content:string_Content];
    [self.webView_Content tool_WebViewBrowse:self.navigationController];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:self.dic_DetailedData[@"FJNAME"]];
    [self.webView_Attachment tool_Attachment:string_Attachment];
    [self.webView_Attachment tool_WebViewBrowse:self.navigationController];
}

#pragma  mark -- 流程推送
/**
 * 流程推送
 */
-(void) add_Process{

    self.liuChenBean.id = self.dic_DetailedData[@"ID"];
    self.liuChenBean.bz = self.dic_DetailedData[@"JSDE940"];
    self.liuChenBean.tablename = @"OA_BMSCD";
    self.liuChenBean.lcname = @"bmscd";
    self.liuChenBean.issh = @"";
    self.liuChenBean.idlist = @"";
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = @"";

    NSDictionary *dic_spyj = [self add_SpyjColumn];
    self.liuChenBean.spyj= dic_spyj[@"spyj"];

    NSString *pinJie = [self.faSongShuJu pinJie_BaoMi_LiuChen:self.liuChenBean];
    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;

    //[MBProgressHUD showMessage:@""];
    //拼接，发送数据
    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];
    //访问服务器
    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];

    NSString *sting_CODE = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"CODE"]];

    //判断 code 没有数据，显示Text
    if ([sting_CODE isEqualToString:@""] || [sting_CODE intValue] != 1) {

       [MBProgressHUD hideHUD];
        [IanAlert alertError:dic[@"TEXT"] length:1.0];

        return;
    }
    else{

        NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];

        if ([sting_function isEqualToString:@""]) {

            [MBProgressHUD hideHUD];
            [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }
}

#pragma  mark -- 判断领导级别
/**
 *
 *
 *  @param spyj 领导（b02，b16...）
 *
 *  @return 请求数据（DWYJ，BGSHGSYJ...）
 */
-(NSDictionary *) add_SpyjColumn{

    NSString *spyjColumn = @"";
    NSString *spyj = @"";
    NSString *bz =  self.dic_DetailedData[@"JSDE940"];

    if ([bz isEqualToString:@"b02"] ) {

        spyj = self.textView_CSFZRYJ.text;
        spyjColumn = @"CSFZRYJ";
    }
    else if ([bz isEqualToString:@"b08"]){

        spyj = self.textView_FGLDYJ.text;
        spyjColumn = @"FGLDYJ";
    }
    else if ([bz isEqualToString:@"b03"]){

        spyj =self.textView_ZYSC.text;
        spyjColumn = @"ZYSC";
    }
    else if ([bz isEqualToString:@"b04"]){

        spyj =self.textView_FHSC.text;
        spyjColumn = @"FHSC";
    }
    else if ([bz isEqualToString:@"b05"]){

        spyj =self.textView_CXSC.text;
        spyjColumn = @"CXSC";
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:spyj,@"spyj",spyjColumn,@"spyjColumn",nil];
}

/**
 *  提交按钮，点击以后
 *  @param sender <#sender description#>
 */
- (IBAction)submit_Click:(id)sender {

    [self add_Process];
}

/**
 * 返回按钮
 *  @param sender <#sender description#>
 */
- (IBAction)return_Click:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark -- BaoMiViewControllerDelegate
// 回调唯一id
-(void)BaoMiViewControllerDelegate_Id:(int)Id{

    if(Id != 0){

        [self add_GetHttp_CellId:Id];
    }
}

@end
