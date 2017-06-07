//
//  GSSCBGCY_XiangQing_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/16.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 概算审查报告传阅
#import "GSSCBGCY_XiangQing_ViewController.h"
#import "LPPopupListView.h"
#import "RenWuZhuanXie_SelectMen_TableViewController.h"

@interface GSSCBGCY_XiangQing_ViewController ()<UITextViewDelegate,LPPopupListViewDelegate,RenWuZhuanXie_SelectMen_TableViewControllerDelegate>

/** 编号 */
@property (weak, nonatomic) IBOutlet UILabel *label_BH;
/** 审计单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_SJDW;
/** 报审单位 */
@property (weak, nonatomic) IBOutlet UILabel *label_BSDW;
/** 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *label_XMMC;

/** 文档 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_WD;
/** 附件 */
@property (weak, nonatomic) IBOutlet Tool_WebView *webView_FJ;

/** 项目概况 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_XMGK;
/** 备注*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_BZ;
/** 实施单位意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_SSDWYJ;
/**投融资主体意见*/
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_TRZZRYJ;
/** 造价管理处意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZJGLCYJ;
/** 业务处室审核意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_YWCSSSYJ;
/** 造价监督处意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZJJDCYJ;
/** 分管领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_FGLDYJ;
/** 主要领导意见 */
@property (weak, nonatomic) IBOutlet Tool_TextView *textView_ZYLDYJ;

/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
/** 返回 */
@property (weak, nonatomic) IBOutlet UIButton *button_Return;
/** 返回button的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnWidth;
/**  返回button的中心Y轴  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_ReturnCenterY;

#pragma  mark -- 选择人参数
/**  选择人要是参数 */
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
/**  提交服务器，返回选择人数据 */
@property (nonatomic, strong) NSDictionary *dic_SelectMan;
/** 服务器二次返回的选人的节点 */
@property (nonatomic, strong) NSArray *array_Manperson;
/**  选人返回参数 */
@property (nonatomic, copy) NSString *ALLREAD;
/** 选人返回参数 */
@property (nonatomic,copy) NSString *ZTBS;
/** 选择节点 */
@property (nonatomic,copy) NSString *taskname_XuanJieDian;
/** 选择节点_接 */
@property (nonatomic,copy) NSString *taskname_XuanJieDian_Jie;
/** 流程返回_dic personList节点 */
@property (nonatomic, strong) NSArray *array_personList;
/** //选择人的名字 */
@property (nonatomic, strong) NSString *names_XuanZeRen_Jie;
@property (nonatomic, strong) NSString *idList_XuanZeRen_Jie;
@property (nonatomic, strong) NSString *names_XuanZeRen;//选择人的名字
@property (nonatomic,strong) NSString *idList_XuanZeRen;//选择人的id
@property (nonatomic, strong) NSMutableArray *array_XuanRen;//选择的人
/** b02 等BZ */
@property (nonnull,strong) NSString *string_BZ;

#pragma  mark -- 第二次修改添加属性（收文类型的修改）
/**  选择人小手 */
@property (weak, nonatomic) IBOutlet UIButton *button_XuanRen;
@property (copy, nonatomic) NSString *string_ShouWenLeiXing;//收文类型
@property (copy, nonatomic) NSString *string_swlx;//收文提交
/** 小手选人回来的数据 */
@property (nonatomic,strong) NSDictionary *dic_XiaoShouXuanRen;

@end

@implementation GSSCBGCY_XiangQing_ViewController

/** 选择，单选 == 0，选节点 == 1 */
static int xuanZhe = 1;
static int type = 0;//选择小手的条件
static NSString *xuanRen = @"xuanRen";

- (void)viewDidLoad {
    [super viewDidLoad];

    //在block里面数据，所以要弱指针。不然内存泄漏（重要）
    __weak NSDictionary *weakDic = self.dic_AllList;
    _string_BZ = self.dic_AllList[@"JSDE940"];
    //请求网络数据
    [self add_GetHttp_PinJie:^NSString *{

        NSString *string_functionCode = @"209904";
        NSString *string_tableName = @"OA_YWGL_GSSCBGCY";
        NSString *string_flowName = @"gsscbgcy";

        NSString *string_PinJie = [NSString stringWithFormat:@"functionCode=%@&tableName=%@&flowName=%@&ywid=%@&ID=%@&bz=%@&ybrid=%@",string_functionCode,string_tableName,string_flowName,weakDic[@"ID"],weakDic[@"ID"],weakDic[@"JSDE940"],weakDic[@"YBRID"]];

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
                         self.textView_XMGK,@"XMGK",
                         self.textView_BZ,@"BZ",
                         self.textView_SSDWYJ,@"SSDWYJ",
                         self.textView_TRZZRYJ,@"TRZZTYJ",
                         self.textView_ZJGLCYJ,@"ZJGLCYJ",
                         self.textView_YWCSSSYJ,@"XGBMHQ",
                         self.textView_FGLDYJ,@"FGLD",
                         self.textView_ZYLDYJ,@"ZYLDYJ",
                         self.textView_ZJJDCYJ,@"ZJJDCYJ",
                         nil];
    self.array_spyj = [self add_judgeAddTextView_BZDic:dic];

    self.textView_XMGK.delegate = self;
    self.textView_BZ.delegate = self;
    self.textView_SSDWYJ.delegate = self;
    self.textView_TRZZRYJ.delegate = self;
    self.textView_ZJGLCYJ.delegate = self;
    self.textView_YWCSSSYJ.delegate = self;
    self.textView_FGLDYJ.delegate = self;
    self.textView_ZYLDYJ.delegate = self;
    self.textView_ZJJDCYJ.delegate = self;

    //选人小手判断
    if (![self.dic_AllList[@"JSDE940"] isEqualToString:@"b07"] && [self.dic_AllList[@"STATE"] isEqualToString:@"0"]) {

        self.button_XuanRen.hidden = YES;
    }
    else{
        [self.button_XuanRen addTarget:self action:@selector(click_XuanRenBurron) forControlEvents:UIControlEventTouchDown];
    }
}

#pragma  mark -- 父类界面赋值方法
- (void)add_View_Array:(NSArray *)array{
    [super add_View_Array:array];

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];

    NSLog(@"%@",array_list);
    NSDictionary *dic_list = array_list[0];
    self.label_BH.text = dic_list[@"BH"];
    self.label_SJDW.text = dic_list[@"SJDW"];
    self.label_BSDW.text = dic_list[@"BSDW"];
    self.label_XMMC.text = dic_list[@"XMMC"];

    self.textView_XMGK.text = dic_list[@"XMGK"];
    self.textView_BZ.text = dic_list[@"BZ"];
    self.textView_SSDWYJ.text = dic_list[@"SSDWYJ"];
    self.textView_TRZZRYJ.text = dic_list[@"TRZZTYJ"];
    self.textView_ZJGLCYJ.text = dic_list[@"ZJGLCYJ"];
    self.textView_YWCSSSYJ.text = dic_list[@"XGBMHQ"];
    self.textView_FGLDYJ.text = dic_list[@"FGLDYJ"];
    self.textView_ZYLDYJ.text = dic_list[@"ZYLDYJ"];
    self.textView_ZJJDCYJ.text = dic_list[@"ZJJDCYJ"];

    //附件
    NSString *string_Attachment = [ChangYong_NSObject selectNulString:dic_list[@"FJNAME"]];
    [self.webView_FJ tool_Attachment:string_Attachment];
    [self.webView_FJ tool_WebViewBrowse:self.navigationController];
    //文档
    NSString *string_Attachment_WD = [ChangYong_NSObject selectNulString:dic_list[@"WD"]];
    [self.webView_WD tool_Content:string_Attachment_WD];
    [self.webView_WD tool_WebViewBrowse:self.navigationController];

    //小手选择完人以后，回调数据显示
    if (self.dic_XiaoShouXuanRen != nil) {

        if ([[NSString stringWithFormat:@"%@", self.dic_XiaoShouXuanRen[@"name"]] isEqualToString:@""]) {

            self.textView_FGLDYJ.text = @"";
        }
        else{

            self.textView_FGLDYJ.text = [NSString stringWithFormat:@"请%@阅。%@",self.dic_XiaoShouXuanRen[@"name"],[ChangYong_NSObject judgeString:self.textView_FGLDYJ.text]];
        }
    }
}

//点击提交按钮
- (IBAction)clickSubmit:(id)sender {

    //选人小手判断
    if (![self.dic_AllList[@"JSDE940"] isEqualToString:@"b07"] && [self.dic_AllList[@"STATE"] isEqualToString:@"0"]) {

        [self add_Process];
    }
    else{

       // NSLog(@"%@======",self.textView_FGLDYJ.text);
        if ([[ChangYong_NSObject removeSpaceAndNewline:self.textView_FGLDYJ.text] isEqualToString:@""]) {
            [IanAlert alertError:@"请选择分管领导"];
            return;
        }
        [self add_Process];
    }
}

#pragma  mark -- 返回按钮
- (IBAction)clickReturn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark -- 流程推送
/**
 * 流程推送
 */
-(void) add_Process{

    self.liuChenBean.spyj = @"请下一步办理";

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];
    self.liuChenBean.id = dic_list[@"ID"];
    self.liuChenBean.bz = dic_list[@"JSDE940"];
    self.liuChenBean.tablename = self.dic_Table[@"tableName"];
    self.liuChenBean.lcname = self.dic_Table[@"flowName"];
    self.liuChenBean.issh = @"";
    self.liuChenBean.isdx = self.string_SwitchNO;
    self.liuChenBean.state = [NSString stringWithFormat:@"%@",self.dic_AllList[@"STATE"]];

    //判断是不是点击了小手，选择人
    if(self.dic_XiaoShouXuanRen == nil){

        self.liuChenBean.idlist = @"";
        self.liuChenBean.kslist = @"";
        self.liuChenBean.ldlist = @"";
        self.liuChenBean.names = @"";
    }
    else{
        //点击小手以后选择人
        self.liuChenBean.idlist = self.dic_XiaoShouXuanRen[@"nameId"];
        self.liuChenBean.kslist = self.dic_XiaoShouXuanRen[@"kslistId"];
        self.liuChenBean.ldlist = self.dic_XiaoShouXuanRen[@"cdListid"];
        self.liuChenBean.names = self.dic_XiaoShouXuanRen[@"name"];
    }

    if ([self.liuChenBean.bz isEqualToString:@"b07"]) {

        self.liuChenBean.spyj = [NSString stringWithFormat:@"%@",self.textView_FGLDYJ.text];
        self.liuChenBean.spyjColumn = @"FGLDYJ";
    }
    else{

        self.liuChenBean.spyj = self.array_spyj[0];
        self.liuChenBean.spyjColumn = self.array_spyj[1];
    }

    [MBProgressHUD showMessage:@""];
    NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
    // NSLog(@"%@",pinJie);
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

    //错误的情况下
    if ([sting_CODE intValue] != 1) {

        [IanAlert alertError:dic[@"TEXT"] length:1.0];

        return;
    }
    else{

        NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];

        //这个是正常的情况
        if ([sting_function isEqualToString:@""]) {

            [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            //选择人的情况
            //关闭阴影
            [MBProgressHUD hideHUD];
            //单选
            xuanZhe = 1;
            self.dic_SelectMan = dic;
            [self tianJian_PopChuanKoDic:self.dic_SelectMan];
        }
    }
}

#pragma  mark -- 选人按钮点击以后
//选人按钮点击以后
-(void) click_XuanRenBurron{

    [self performSegueWithIdentifier:xuanRen sender:nil];
}

/**
 segue 跳转
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    RenWuZhuanXie_SelectMen_TableViewController *ren = segue.destinationViewController;
    self.delegate = ren;

    NSDictionary *dic = dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"6",@"type",@"jjzrbg",@"rolename",nil];

    if ([self.delegate respondsToSelector:@selector(addTypeAllDetailed:)]) {
        
        [self.delegate addTypeAllDetailed:dic];
    }
    
    ren.delegate_AddName = self;
}

#pragma  mark -- 选择人小手，回调来的数据
-(void)addNameDic:(NSDictionary *)dic{

    self.dic_XiaoShouXuanRen = dic;
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

/************* 选择人 ***************/
#pragma  mark -- 弹出选择人窗口单选
/**
 弹出选择人选择人 单选
 */
- (void) tianJian_PopChuanKoDic:(NSDictionary *) dic{

    //选择框的样式
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"流程选择：" list:[self listDic:dic] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO];
    listView.delegate = self;
    [listView showInView:self.navigationController.view animated:YES];
}

/**
 弹出选择人选择人 多选
 */
- (void) tianJian_PopChuanKo_Person_Duo{

    //选择框的样式
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"人员选择：" list:[self list_Person] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:YES];
    listView.delegate = self;
    [listView showInView:self.navigationController.view animated:YES];
}

/**
 弹出pop窗口_单选
 */
- (void) tianJian_PopChuanKo_Person_Dan{

    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;

    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));

#warning  no == 单选  yes多选
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"人员选择：" list:[self list_Person] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO];
    listView.delegate = self;

    [listView showInView:self.navigationController.view animated:YES];
}

/**
 *  选择人的数据转化
 *
 *  @return <#return value description#>
 */
-(NSArray *) listDic:(NSDictionary *)dic{

    //NSLog(@"%@",dic);
    //选择展示人的选择
    _array_XuanRen = [NSMutableArray array];
    //服务器二次返回的选人的节点
    self.array_Manperson = dic[@"person"];
    for (NSDictionary *dic in self.array_Manperson) {

        NSDictionary *dic_node = dic[@"node"];
        [self.array_XuanRen addObject:@{@"name":dic_node[@"taskname"],@"oid":dic_node[@"ZTBS"]} ];
    }

    return self.array_XuanRen;
}

/**
 * 多选
 */
/**
 选择person
 */
- (NSArray *)list_Person{

    _array_XuanRen = [NSMutableArray array];
    int count =(int)self.array_personList.count;//减少调用次数

    for(int i=0; i<count; i++){

        NSDictionary *dic_all = self.array_personList[i];
        //添加字典
        [self.array_XuanRen addObject:@{@"name":dic_all[@"SUNAME"],@"oid":dic_all[@"SUINO"]} ];
    }

    return self.array_XuanRen;
}

#pragma  mark -- 选人的代理
- (void)popupListViewDidHideCancle:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes{

    xuanZhe = 1;
}

//点击事件(单选)
- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index{

    if (xuanZhe == 1) {

        NSDictionary *dic = self.array_Manperson[index];
        NSDictionary *dic_node = dic[@"node"];
        self.taskname_XuanJieDian = dic_node[@"taskname"];
        _ALLREAD = dic_node[@"ALLREAD"];
        _ZTBS = dic_node[@"ZTBS"];
        _array_personList = dic[@"personList"];

        if ([self.ALLREAD isEqualToString:@"1"]) {

            xuanZhe = 3;
            [self tianJian_PopChuanKo_Person_Duo];
        }
        else{

            xuanZhe = 2;
            [self tianJian_PopChuanKo_Person_Dan];
        }
    }
    else if (xuanZhe == 2) {

        xuanZhe = 1;
        NSArray * list =  [self list_Person];
        self.names_XuanZeRen_Jie = list[index][@"name"];
        self.idList_XuanZeRen_Jie = list[index][@"oid"];

        NSString *array_person_string;

        if (self.array_Manperson.count>1){

            array_person_string= [NSString stringWithFormat:@"%d", 1];//判断person的长度
        }
        else{

            array_person_string= [NSString stringWithFormat:@"%d", 0];//判断person的长度
        }

        if([array_person_string isEqualToString:@"1"]){

            self.taskname_XuanJieDian = [NSString stringWithFormat:@"to %@",self.taskname_XuanJieDian];
        }

        NSDictionary *dic_Reng = [[NSDictionary alloc] initWithObjectsAndKeys:self.names_XuanZeRen_Jie,@"names",self.idList_XuanZeRen_Jie,@"idlist",self.taskname_XuanJieDian,@"taskname",array_person_string,@"array_person",@"",@"ends",@"",@"isfz",self.ZTBS,@"ZTBS",nil];

        NSString *pingjie = [self.faSongShuJu pinJie_Ren_LiuChen:self.liuChenBean Dic_Ren:dic_Reng];
        //拼接，发送数据
        NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pingjie,@"common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess",@"1"];

        Util *util = [[Util alloc]init];
        NSString *LiuChen_Util = util.tuiLiuChen;
        //访问服务器
        NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];

        [IanAlert alertSuccess:dic[@"TEXT"]];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 点击完成以后的（多选）
 */
- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes{

    self.selectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:selectedIndexes];
    xuanZhe = 1;
    self.names_XuanZeRen = @"";
    self.idList_XuanZeRen = @"";
    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {

        NSDictionary *dic = self.array_XuanRen[idx];

        self.names_XuanZeRen = [NSString stringWithFormat:@"%@;%@",self.names_XuanZeRen,dic[@"name"]];
        self.idList_XuanZeRen = [NSString stringWithFormat:@"%@;%@",self.idList_XuanZeRen,dic[@"oid"]];
    }];

    //判断是不是nil
    if (self.names_XuanZeRen == nil ||[self.names_XuanZeRen isEqualToString:@""] || [self.names_XuanZeRen isEqual:[NSNull null]]) {
        return;
    }

    self.names_XuanZeRen_Jie = [self.names_XuanZeRen substringFromIndex:1];
    self.idList_XuanZeRen_Jie = [self.idList_XuanZeRen substringFromIndex:1];

    NSString *array_person_string;

    if (self.array_Manperson.count>1){

        array_person_string= [NSString stringWithFormat:@"%d", 1];//判断person的长度
    }
    else{

        array_person_string= [NSString stringWithFormat:@"%d", 0];//判断person的长度
    }

    if([array_person_string isEqualToString:@"1"]){
        self.taskname_XuanJieDian = [NSString stringWithFormat:@"to %@",self.taskname_XuanJieDian];

    }

    NSDictionary *dic_Reng = [[NSDictionary alloc] initWithObjectsAndKeys:self.names_XuanZeRen_Jie,@"names",self.idList_XuanZeRen_Jie,@"idlist",self.taskname_XuanJieDian,@"taskname",array_person_string,@"array_person",@"",@"ends",@"",@"isfz",self.ZTBS,@"ZTBS",nil];

    NSString *pingjie = [self.faSongShuJu pinJie_Ren_LiuChen:self.liuChenBean Dic_Ren:dic_Reng];
    //拼接，发送数据
    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pingjie,@"common/AndroidSer/biz/AndroidSerWorkFlowServiceProcess",@"1"];

    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;
    //访问服务器
    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];
    
    [IanAlert alertSuccess:dic[@"TEXT"]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
