//
//  JYTJYJSHQ_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 建设条件意见书会签
#import "JYTJYJSHQ_XiangQing_ViewController.h"
//选择框
#import "LPPopupListView.h"

@interface JYTJYJSHQ_XiangQing_ViewController ()<UITextViewDelegate,LPPopupListViewDelegate>

/** 意见书编号 */
@property (weak, nonatomic) IBOutlet UILabel *label_YJSBH;
/** 地块名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_DKMC;
/** 发布范围 */
@property (weak, nonatomic) IBOutlet UILabel *label_FBFW;

/** 意见书内容 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_YJSNR;
/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 开发办 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_KFB;
/** 城建处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_CJC;
/** 计财处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JCC;
/** 公用处*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_GYC;
/** 分管开发的局领导意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FGKFJLDYJ;
/** 局主要领导意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_JZYLDYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

/** 选择人 */
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
/** 选择节点 */
@property (nonatomic,strong) NSMutableArray *array_XuanJieDian;
/** 选人 */
@property (nonatomic,strong) NSArray  *array_XuanRen;

@end

@implementation JYTJYJSHQ_XiangQing_ViewController

//选择，单选 == 0，选节点 == 1
static int xuanZhe = 1;

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_YJSHQ";
        NSString *string_flowName = @"yjshq";
        NSString *string_state = weakDic[@"STATE"];

        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@&state=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"YBRID"],string_state];

        return string_PinJie;
    }];
}

#pragma  mark -- 请求网络数据流程返回_dic 节点
/**
 *请求网络数据
 *
 *  @param dic 请求网络数据
 */
- (void)add_GetHttp_PinJie:(NSString *(^)())pinJie{
    [super add_GetHttp_PinJie:pinJie];

    //是b02 二次请求数据，选择人
    NSString *string_Bz = self.dic_AllList[@"JSDE940"];
    if ([string_Bz isEqualToString:@"b02"]) {

        GetHttp *http = [[GetHttp alloc] init];
        Util *util = [Util new];
        NSString *string_Path = [util phaseTwo_YeWuGuanLi];

        NSString *string_functionCode = @"304503";
        NSString *string_tableName = @"OA_YWGL_YJSHQ";
        NSString *string_flowName = @"yjshq";
        NSString *string_state = self.dic_AllList[@"STATE"];

        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@&state=%@",string_functionCode,string_tableName,string_flowName,self.dic_AllList[@"ID"],self.dic_AllList[@"ID"],self.dic_AllList[@"JSDE940"],self.dic_AllList[@"YBRID"],string_state];

        //返回，dic数据
        NSDictionary *dic = [http getHttpPinJie_JiaZai:string_PinJie Util:string_Path];
        self.array_XuanRen = dic[@"list"];

       // [self xuanRen_DataConversion:self.array_XuanRen];
    }
}


#pragma  mark -- 选择人数据转换
/**
 *  选择人数据转换
 *
 *  @param array <#array description#>
 */
-(NSDictionary *) xuanRen_DataConversion:(NSArray *)array{

    NSString *idlist_All = @"";
    NSString *userlist_All = @"";
    NSString *rolelist_All = @"";
    for (NSDictionary *dic in array) {

        NSString  *idlist = dic[@"SUINO"];
        idlist_All = [NSString stringWithFormat:@"%@,%@",idlist_All,idlist];
        NSString  *userlist = dic[@"SUNAME"];
        userlist_All = [NSString stringWithFormat:@"%@,%@",userlist_All,userlist];
        NSString  *rolelist = dic[@"CODE"];
        rolelist_All = [NSString stringWithFormat:@"%@,%@",rolelist_All,rolelist];
    }

    idlist_All = [idlist_All substringFromIndex:1];//截取掉下标2之前的字符串
    userlist_All = [userlist_All substringFromIndex:1];//截取掉下标2之前的字符串
    rolelist_All = [rolelist_All substringFromIndex:1];//截取掉下标2之前的字符串

    return  [NSDictionary dictionaryWithObjectsAndKeys:idlist_All,@"idlist",userlist_All,@"userlist",rolelist_All,@"rolelist",nil];
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
                         self.textView_KFB,@"KFBYJ",
                         self.textView_CJC,@"CJCYJ",
                         self.textView_GYC,@"GYCYJ",
                         self.textView_FGKFJLDYJ,@"FGLDYJ",
                         self.textView_JZYLDYJ,@"ZYLDYJ",
                         self.textView_JCC,@"JCCYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_KFB.delegate = self;
    self.textView_CJC.delegate = self;
    self.textView_GYC.delegate = self;
    self.textView_FGKFJLDYJ.delegate = self;
    self.textView_JZYLDYJ.delegate = self;
    self.textView_JCC.delegate = self;
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.label_YJSBH.text = dic_list[@"YJSID"];
    self.label_DKMC.text = dic_list[@"DKMC"];
    self.label_FBFW.text = dic_list[@"FBFW"];

    self.textView_KFB.text = dic_list[@"KFBYJ"];
    self.textView_CJC.text = dic_list[@"CJCYJ"];
    self.textView_GYC.text = dic_list[@"GYCYJ"];
    self.textView_FGKFJLDYJ.text = dic_list[@"FGLDYJ"];
    self.textView_JZYLDYJ.text = dic_list[@"ZYLDYJ"];
    self.textView_JCC.text = dic_list[@"JCCYJ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
    //文档
    NSString *string_Attachment_WD = [ChangYong_NSObject selectNulString:dic_list[@"WD"]];
    [self.webView_YJSNR tool_Content:string_Attachment_WD];
    [self.webView_YJSNR tool_WebViewBrowse:self.navigationController];
}

//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    [self add_Process];
}

- (void)add_Process{

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
    self.liuChenBean.idlist = @"";
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = @"";
    self.liuChenBean.spyjColumn = self.array_spyj[1];
    self.liuChenBean.isdx = self.string_SwitchNO;
    self.liuChenBean.state = [NSString stringWithFormat:@"%@",self.dic_AllList[@"STATE"]];

    NSString *string_bz = [NSString stringWithFormat:@"%@",dic_list[@"JSDE940"]];
    //b02 分批给三个人
    if ([string_bz isEqualToString:@"b02"]) {

        NSDictionary *dic = [self xuanRen_DataConversion:self.array_XuanRen];
//	params.put("morespyjColumn", "{columnName:'SUINO',value:'"+idlist+"'},{columnName:'CODE',value:'"+rolelist+"'}");
        self.liuChenBean.teshu = [NSString stringWithFormat:@",{columnName:'SUINO',value:'%@'},{columnName:'CODE',value:'%@'}",dic[@"idlist"],dic[@"rolelist"]];
       // NSLog(@"%@",self.liuChenBean.teshu);
    }

    [MBProgressHUD showMessage:@""];
    NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];

    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;

    //拼接，发送数据
    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];
    //访问服务器
    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];

    NSString *sting_CODE = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"CODE"]];

    [MBProgressHUD hideHUD];

    //判断 code 没有数据，显示Text
    if ([sting_CODE isEqualToString:@""]) {

        [IanAlert alertError:dic[@"TEXT"] length:1.0];

        return;
    }

    if ([sting_CODE intValue] != 1) {

      //  NSLog(@"%@",dic[@"TEXT"]);

        [IanAlert alertError:dic[@"TEXT"] length:1.0];

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

//键盘控制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}

/*************** 选择人 **************/
#pragma mark - LPPopupListViewDelegate代理方法

/**
 弹出pop窗口1
 */
- (void) tianJian_PopChuanKo{

    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;

    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));

    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"流程选择：" list:[self list] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO];
    listView.delegate = self;

    [listView showInView:self.navigationController.view animated:YES];
}

#pragma mark - 单选多选的数据 List
- (NSArray *)list{

    _array_XuanJieDian = [NSMutableArray array];
//    int count =(int)self.array_person.count;//减少调用次数
//    for(int i=0; i<count; i++){

//        NSDictionary *dic_all = self.array_person[i];
//        NSDictionary *dic_node = dic_all[@"node"];

//        [self.array_XuanJieDian addObject:@{@"name":dic_node[@"taskname"],@"oid":dic_node[@"ZTBS"]} ];
//    }

    for (NSDictionary *dic in self.array_XuanRen) {

        [self.array_XuanJieDian addObject:@{@"name":dic[@"SUNAME"],@"oid":dic[@"SUINO"]} ];
    }

    return self.array_XuanJieDian;
}


//点击事件
- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index{

//    if (xuanZhe == 1) {
//
//        NSDictionary *dic = self.array_person[index];
//        NSDictionary *dic_node = dic[@"node"];
//        self.taskname_XuanJieDian = dic_node[@"taskname"];
//        _ALLREAD = dic_node[@"ALLREAD"];
//        self.ZTBS = dic_node[@"ZTBS"];
//        _array_personList = dic[@"personList"];
//
//        if ([self.ALLREAD isEqualToString:@"1"]) {
//
//            xuanZhe = 3;
//            [self tianJian_PopChuanKo_Person_Duo];
//        }else{
//
//            xuanZhe = 2;
//            [self tianJian_PopChuanKo_Person_Dan];
//        }
//    }else if (xuanZhe == 2) {
//        xuanZhe = 1;
//        NSArray * list =  [self list_Person];
//        self.names_XuanZeRen_Jie = list[index][@"name"];
//        self.idList_XuanZeRen_Jie = list[index][@"oid"];
//
//        NSString *array_person_string;
//
//        if (self.array_person.count>1){
//            array_person_string= [NSString stringWithFormat:@"%d", 1];//判断person的长度
//        }else{
//            array_person_string= [NSString stringWithFormat:@"%d", 0];//判断person的长度
//        }
//
//        if([array_person_string isEqualToString:@"1"]){
//            self.taskname_XuanJieDian = [NSString stringWithFormat:@"to %@",self.taskname_XuanJieDian];
//
//        }
//
//
//        NSDictionary *dic_Reng = [[NSDictionary alloc] initWithObjectsAndKeys:self.names_XuanZeRen_Jie,@"names",self.idList_XuanZeRen_Jie,@"idlist",self.taskname_XuanJieDian,@"taskname",array_person_string,@"array_person",@"",@"ends",@"",@"isfz",self.ZTBS,@"ZTBS",nil];
//
//        NSString *pingjie = [self.faSongShuJu pinJie_Ren_LiuChen:self.liuChenBean Dic_Ren:dic_Reng];
//        //拼接，发送数据
//        NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pingjie,@"common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess",@"1"];
//
//        Util *util = [[Util alloc]init];
//        NSString *LiuChen_Util = util.tuiLiuChen;
//        //访问服务器
//        NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];
//
//        [IanAlert alertSuccess:dic[@"TEXT"]];
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


- (void)popupListViewDidHideCancle:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes{

    xuanZhe = 1;

}
///**
// 点击完成以后的
// */
//- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes{
//
//    self.selectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:selectedIndexes];
//    xuanZhe = 1;   self.names_XuanZeRen = @"";
//    self.idList_XuanZeRen = @"";
//    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//
//        NSDictionary *dic = self.array_XuanRen[idx];
//
//        self.names_XuanZeRen = [NSString stringWithFormat:@"%@;%@",self.names_XuanZeRen,dic[@"name"]];
//        self.idList_XuanZeRen = [NSString stringWithFormat:@"%@;%@",self.idList_XuanZeRen,dic[@"oid"]];
//    }];
//
//    self.names_XuanZeRen_Jie = [self.names_XuanZeRen substringFromIndex:1];
//    self.idList_XuanZeRen_Jie = [self.idList_XuanZeRen substringFromIndex:1];
//
//    NSString *array_person_string;
//
//    if (self.array_person.count>1){
//        array_person_string= [NSString stringWithFormat:@"%d", 1];//判断person的长度
//    }else{
//        array_person_string= [NSString stringWithFormat:@"%d", 0];//判断person的长度
//    }
//
//    if([array_person_string isEqualToString:@"1"]){
//        self.taskname_XuanJieDian = [NSString stringWithFormat:@"to %@",self.taskname_XuanJieDian];
//
//    }
//
//    NSDictionary *dic_Reng = [[NSDictionary alloc] initWithObjectsAndKeys:self.names_XuanZeRen_Jie,@"names",self.idList_XuanZeRen_Jie,@"idlist",self.taskname_XuanJieDian,@"taskname",array_person_string,@"array_person",@"",@"ends",@"",@"isfz",self.ZTBS,@"ZTBS",nil];
//
//    NSString *pingjie = [self.faSongShuJu pinJie_Ren_LiuChen:self.liuChenBean Dic_Ren:dic_Reng];
//    //拼接，发送数据
//    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pingjie,@"common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess",@"1"];
//
//    Util *util = [[Util alloc]init];
//    NSString *LiuChen_Util = util.tuiLiuChen;
//    //访问服务器
//    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];
//    
//    [IanAlert alertSuccess:dic[@"TEXT"]];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
