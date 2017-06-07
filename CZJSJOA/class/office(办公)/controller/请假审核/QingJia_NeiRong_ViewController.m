//
//  qingJia_NeiRong_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/12.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "QingJia_NeiRong_ViewController.h"
#import "QiJia_ViewController.h"
#import "FaSongShuJu.h"
#import "LiuChenBean.h"
#import "Util.h"
#import "LPPopupListView.h"

@interface QingJia_NeiRong_ViewController ()<UITextViewDelegate,UIScrollViewDelegate,QiJia_ViewControllerDelegate,LPPopupListViewDelegate>

@property (nonatomic,strong) NSDictionary *dic_QiJia;
@property (weak, nonatomic) IBOutlet UIScrollView *allscrollView;
@property (weak, nonatomic) IBOutlet UILabel *xingMing_Text;//姓名_Text
@property (weak, nonatomic) IBOutlet UISegmentedControl *xingBie_Text;//性别
@property (weak, nonatomic) IBOutlet UILabel *qiJianLeiBie_Text;//请假类别
@property (weak, nonatomic) IBOutlet UILabel *gongZuoBuMeng_Text;//工作部门
@property (weak, nonatomic) IBOutlet UILabel *canJiaGongZuoShiJian_Text;//参加工作时间_Text
@property (weak, nonatomic) IBOutlet UILabel *yingXiuTianShu_Text;//应休天数_Text
@property (weak, nonatomic) IBOutlet UILabel *BenCiXiuJia_Text;//本次休假天数_Text
@property (weak, nonatomic) IBOutlet UILabel *shiJianAnPai_Text;//时间安排_Text
@property (weak, nonatomic) IBOutlet UILabel *jieShuShiJian_Text;//结束时间_Text
@property (weak, nonatomic) IBOutlet UILabel *shenQingRen_Text;//申请人_Text
@property (weak, nonatomic) IBOutlet UITextView *buMengFuZheRengYiJian_TextView;//部门负责人意见
@property (weak, nonatomic) IBOutlet UITextView *fenGuanLingDaoYiJian_TextView;//分管领导意见
@property (weak, nonatomic) IBOutlet UITextView *zhuYaoLingDaoYiJian_TextView;//主要领导意见

@property (nonatomic,strong) NSDictionary *dic_Array;

@property (nonatomic,strong) FaSongShuJu *faSongShuJu;
@property (nonatomic,strong) LiuChenBean *liuChenBean;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@property (nonatomic, strong)  NSArray *array_person ;//流程返回_dic 节点
@property (nonatomic, copy)   NSString *ALLREAD; //流程返回_dic
@property (nonatomic, strong) NSArray *array_personList; //流程返回_dic personList节点
@property (nonatomic,strong) NSDictionary *dic_FaSongShuJu;//流程返回_dic
@property (nonatomic, strong) NSMutableArray *array_XuanRen;//选择的人
@property (nonatomic, strong) NSString *names_XuanZeRen;//选择人的名字
@property (nonatomic,strong) NSString *idList_XuanZeRen;//选择人的id
@property (nonatomic, strong) NSString *names_XuanZeRen_Jie;//选择人的名字
@property (nonatomic,strong) NSString *idList_XuanZeRen_Jie;//选择人的id
@property (nonatomic,strong) NSMutableArray *array_XuanJieDian;//选择节点
@property (nonatomic,copy) NSString *taskname_XuanJieDian;//选择节点
@property (nonatomic,copy) NSString *taskname_XuanJieDian_Jie;//选择节点_接
@property (nonatomic,copy) NSString *ZTBS;//最大节点，属性

@property (nonatomic,strong) NSArray *array_fromControl;//回来的fromControl
@property (nonatomic,strong) NSArray *array_messageControl;//回来的messageControl

@end

@implementation QingJia_NeiRong_ViewController

//选择，单选 == 0，选节点 == 1
static int xuanZhe = 1;

- (FaSongShuJu *)faSongShuJu{


    if (_faSongShuJu == nil) {

        _faSongShuJu = [[FaSongShuJu alloc] init];
    }

    return _faSongShuJu;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self sheZhiTextView_ShuXing];

    //给view添加数据   [self getHttpDic:self.shouWenDic] 访问服务器数据
    [self tianJia_ShuJuDic:[self getHttpDic:self.dic_QiJia]];
}

-(void) viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
}
/**************** 基本方法 ****************/
#pragma mark -- 基本方法

/**
 设置UiTextView的属性
 */
- (void) sheZhiTextView_ShuXing{

    [self textView_BianKuanTextView:self.buMengFuZheRengYiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.fenGuanLingDaoYiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.zhuYaoLingDaoYiJian_TextView Text:@""];

    self.allscrollView.delegate = self;
}

/**
 textView设置边框
 (UITextView *)txetView 对象， Text:(NSString *)text 需要显示的文字
 */
- (void) textView_BianKuanTextView:(UITextView *)txetView Text:(NSString *)text{

    //内容框设置
    txetView.layer.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor;
    txetView.layer.borderWidth =1.0;
    txetView.layer.cornerRadius =5.0;
    txetView.text = @"";

    txetView.delegate = self;
}

- (IBAction)faHui_Button_Click:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

/**
  提交button
 */
- (IBAction)tiJiao_Button_Click:(UIButton *)sender {

    self.liuChenBean = [[LiuChenBean alloc] init];
    self.liuChenBean.spyj = @"请下一步办理";
    NSString *spyjColumn =@"";
     NSString *spyj =@"";

    if (self.array_messageControl.count < 1) {

       spyj = @"请下一步办理";
    }
    else{

        NSDictionary *dic_messageControl = self.array_messageControl[0];
        NSString *string_CONTROL = dic_messageControl[@"CONTROL"];

        if ([string_CONTROL isEqualToString:@"ZYLDYJ"]) {

            if (![self.zhuYaoLingDaoYiJian_TextView.text isEqualToString:@""]) {

               spyj = self.zhuYaoLingDaoYiJian_TextView.text;
            }
            spyjColumn = @"ZYLDYJ";
        }

        if ([string_CONTROL isEqualToString:@"FGLDYJ"]) {

            if (![self.fenGuanLingDaoYiJian_TextView.text isEqualToString:@""]) {

                spyj = self.fenGuanLingDaoYiJian_TextView.text;
            }
            spyjColumn = @"FGLDYJ";
        }

        if ([string_CONTROL isEqualToString:@"BMFZRYJ"]) {

            if (![self.buMengFuZheRengYiJian_TextView.text isEqualToString:@""]) {

            spyj = self.buMengFuZheRengYiJian_TextView.text;
            }
            spyjColumn = @"BMFZRYJ";
        }
    }
    
    self.liuChenBean.spyj = spyj;
    self.liuChenBean.id = self.dic_Array[@"ID"];
    self.liuChenBean.bz = self.dic_Array[@"JSDE940"];
    self.liuChenBean.tablename = @"OA_RSGL_QJGL";
    self.liuChenBean.lcname = @"qjgl_jsj";
    self.liuChenBean.issh = @"";
    self.liuChenBean.idlist = @"";
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = @"";
    self.liuChenBean.spyjColumn = spyjColumn;

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

        [IanAlert alertError:dic[@"TEXT"] length:1.0];

        return;
    }
    else{

        NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];

        if ([sting_function isEqualToString:@""]) {

            [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{

            _array_person = dic[@"person"];
            NSDictionary *dic_CurrentDESC = dic[@"CurrentDESC"];
            self.ZTBS = dic_CurrentDESC[@"ZTBS"];

            //弹出，显示框
            [self tianJian_PopChuanKo];
        }
    }
}


- (IBAction)fanHui_Button_Click:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

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

/**
 弹出pop窗口_多选
 */
- (void) tianJian_PopChuanKo_Person_Duo{

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

#pragma mark - 单选多选的数据 List

- (NSArray *)list{

    _array_XuanJieDian = [NSMutableArray array];
    int count =(int)self.array_person.count;//减少调用次数
    for(int i=0; i<count; i++){

        NSDictionary *dic_all = self.array_person[i];
        NSDictionary *dic_node = dic_all[@"node"];

        [self.array_XuanJieDian addObject:@{@"name":dic_node[@"taskname"],@"oid":dic_node[@"ZTBS"]} ];
    }

    return self.array_XuanJieDian;
}

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

/**
 访问服务器
 */
- (NSDictionary *) getHttpDic:(NSDictionary *)dic{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util qingJia_NeiRong];

    NSString  *pinJie = [NSString stringWithFormat:@"ywid=%@&bz=%@",dic[@"ID"],dic[@"JSDE940"]];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 view添加数据
 */
- (void) tianJia_ShuJuDic:(NSDictionary *)dic{

    //解析数据
    NSArray *array_list = dic[@"list"];
     self.dic_Array= array_list[0];

    self.xingMing_Text.text = self.dic_Array[@"USERNAME"];
    self.xingBie_Text.selectedSegmentIndex = [self.dic_Array[@"SEX"] intValue];
    self.qiJianLeiBie_Text.text = [self xuanZe_QianJiaLeiBieString:self.dic_Array[@"QJLB"]];
    self.gongZuoBuMeng_Text.text = self.dic_Array[@"BM"];
    self.canJiaGongZuoShiJian_Text.text = self.dic_Array[@"WORKDATE"];
    self.yingXiuTianShu_Text.text = self.dic_Array[@"YXTS"];
    self.BenCiXiuJia_Text.text = self.dic_Array[@"QJTS"];
    self.shiJianAnPai_Text.text = [self JieQuString:self.dic_Array[@"KSTIME"] NumBer:11];
    self.jieShuShiJian_Text.text = [self JieQuString:self.dic_Array[@"JSTIME"] NumBer:11];
    self.buMengFuZheRengYiJian_TextView.text = self.dic_Array[@"BMFZRYJ"];
    self.fenGuanLingDaoYiJian_TextView.text = self.dic_Array[@"FGLDYJ"];
    self.zhuYaoLingDaoYiJian_TextView.text = self.dic_Array[@"ZYLDYJ"];
    self.shenQingRen_Text.text=self.dic_Array[@"SQRYJ"];

    [self add_KongZhi_DuXie:dic];
}
/**
 解析数组(控制可读，可写)
 */
- (void) add_KongZhi_DuXie:(NSDictionary *)dic{

    _array_fromControl = dic[@"fromControl"];

    if (![dic[@"fromControl"] isEqual:nil]) {

        for (NSDictionary *dic in self.array_fromControl) {

            NSString *PRONAME = dic[@"PRONAME"];
            NSString *PROTYPE = dic[@"PROTYPE"];

            if ([PRONAME isEqualToString:@"ZYLDYJ"]){

                bool a = [self panDuan_DuXiePRONAME:PROTYPE];
                
                if (a == false) {
                    //主要领导，意见失去焦点
                    self.zhuYaoLingDaoYiJian_TextView.userInteractionEnabled = NO;
                }
            }

            if ([PRONAME isEqualToString:@"FGLDYJ"]) {

                bool a = [self panDuan_DuXiePRONAME:PROTYPE];
                if (a == false) {
                    //主要领导，意见失去焦点
                    self.fenGuanLingDaoYiJian_TextView.userInteractionEnabled = NO;
                }
            }

            if ([PRONAME isEqualToString:@"BMFZRYJ"]) {

                bool a = [self panDuan_DuXiePRONAME:PROTYPE];
                if (a == false) {
                    //主要领导，意见失去焦点
                    self.buMengFuZheRengYiJian_TextView.userInteractionEnabled = NO;
                }
            }
        }

        //messagecontrol
        NSString *string_ShiJian = [self shiJian_DangQian];//当前时间
        NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
        NSString *name = [as stringForKey:@"username"];
        NSString *message = [NSString stringWithFormat:@"%@。%@",name,string_ShiJian];

        //得到属性，
        _array_messageControl = dic[@"messageControl"];

        //判断是不是nil
        if(self.array_messageControl.count != 0){

            NSDictionary *dic_messageControl = self.array_messageControl
            [0];
            NSString *string_CONTROL = dic_messageControl[@"CONTROL"];

            if ([string_CONTROL isEqualToString:@"ZYLDYJ"]) {

                if([self.zhuYaoLingDaoYiJian_TextView.text isEqualToString:@""]){
                self.zhuYaoLingDaoYiJian_TextView.text = [NSString stringWithFormat:@"%@\r\n%@",self.zhuYaoLingDaoYiJian_TextView.text,message];
            }else {

                self.zhuYaoLingDaoYiJian_TextView.text = message;
            }
        }

            if ([string_CONTROL isEqualToString:@"FGLDYJ"]) {
               
                if([self.fenGuanLingDaoYiJian_TextView.text isEqualToString:@""]){
                self.fenGuanLingDaoYiJian_TextView.text = [NSString stringWithFormat:@"%@\r\n%@",self.fenGuanLingDaoYiJian_TextView.text,message];
            }else {

                self.fenGuanLingDaoYiJian_TextView.text = message;
            }
            }

            if ([string_CONTROL isEqualToString:@"BMFZRYJ"]) {
             
                if([self.buMengFuZheRengYiJian_TextView.text isEqualToString:@""]){
                self.buMengFuZheRengYiJian_TextView.text = [NSString stringWithFormat:@"%@\r\n%@",self.buMengFuZheRengYiJian_TextView.text,message];
            }else {
                
                self.buMengFuZheRengYiJian_TextView.text = message;
            }
            }
        }
        
    }else{
        
        return;
    }
}


/**************** 代理方法 ****************/
#pragma mark -- 代理方法

#pragma  mark -- QiJia_ViewControllerDelegate代理方法
/**
 QiJia_ViewControllerDelegate拿dic
 */
- (void) addDic:(NSDictionary *)dic{

    self.dic_QiJia = dic;
}

#pragma  mark -- uiscrollView的代理方法
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - LPPopupListViewDelegate代理方法s
//点击事件
- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index{

    if (xuanZhe == 1) {

        NSDictionary *dic = self.array_person[index];
        NSDictionary *dic_node = dic[@"node"];
        self.taskname_XuanJieDian = dic_node[@"taskname"];
        _ALLREAD = dic_node[@"ALLREAD"];
        self.ZTBS = dic_node[@"ZTBS"];
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

        if (self.array_person.count>1){
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


- (void)popupListViewDidHideCancle:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes{

    xuanZhe = 1;
    
}

/**
 点击完成以后的
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

    self.names_XuanZeRen_Jie = [self.names_XuanZeRen substringFromIndex:1];
    self.idList_XuanZeRen_Jie = [self.idList_XuanZeRen substringFromIndex:1];

    NSString *array_person_string;

    if (self.array_person.count>1){
        array_person_string= [NSString stringWithFormat:@"%d", 1];//判断person的长度
    }else{
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

/**************** 工具方法 ****************/
#pragma mark -- 工具方法

-(NSString *) xuanZe_QianJiaLeiBieString:(NSString *)string{

    NSString *xueJian;

    int int_String = [string intValue];

    switch (int_String) {

        case 1:
            xueJian = @"公休假";
            break;

        case 2:
            xueJian = @"年假";
            break;

        case 3:
            xueJian = @"病事假";
            break;

        case 4:
            xueJian = @"探亲假";
            break;

        case 5:
            xueJian = @"产假";
            break;

        case 6:
            xueJian = @"婚假";
            break;

        default:
            xueJian = @"其他";
            break;
    }

    return  xueJian;
  }

/**
 string 截取 nr 前面的几位 不包括nr位
 */
- (NSString *) JieQuString:(NSString *)string NumBer:(int)nr{

    if (string.length < nr) {
        return @"";
    }

    return  [string substringToIndex:nr];
}

/**
 得到当前时间
 */
-(NSString *) shiJian_DangQian{

    NSDate *date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];

    return  [formatter stringFromDate:date];
}

/**
 判断可读可写
 */
- (BOOL ) panDuan_DuXiePRONAME:(NSString *)proname{

    if ([proname isEqualToString:@"readonly"] || [proname isEqualToString:@"disabled"]) {

        return  false;
    }

    return true;
}


@end
