//
//  DaiYueXiangQin_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/10.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "DaiYueXiangQin_ViewController.h"
#import "shouWenDaiYue_ViewController.h"
#import "RenWuZhuanXie_SelectMen_TableViewController.h"
#import "FaSongShuJu.h"
#import "LiuChenBean.h"
#import "Util.h"
#import "LPPopupListView.h"
#import "QuickLookVC.h"
#import "MBProgressHUD+Add.h"

@interface DaiYueXiangQin_ViewController ()<UITextViewDelegate,UIScrollViewDelegate,shouWenDaiYue_ViewControllerDelegate,RenWuZhuanXie_SelectMen_TableViewControllerDelegate,FaSongShuJuDelegate,LPPopupListViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *all_ScrollView;//总的scrollView
@property (weak, nonatomic) IBOutlet UIButton *all_View;//all_ScrollView里面的all_View
@property (weak, nonatomic) IBOutlet UILabel *biaoTi_Text;//标题
@property (weak, nonatomic) IBOutlet UILabel *LaiWenDanWei_Text;//来文单位
@property (weak, nonatomic) IBOutlet UIWebView *shouWen_WebView;//收文_WebView
@property (weak, nonatomic) IBOutlet UITextView *banGongShi_YiJian_TextView;//办公室意见_textView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoShenYue_TextView;//领导审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoYiJian_TextView;//领导意见_TeXtView
@property (weak, nonatomic) IBOutlet UITextView *buMenShenYue_TextView;//部门审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMenYiJian_TextView;//部门意见_TextView
@property (weak, nonatomic) IBOutlet UIButton *yueBi_Button;//阅毕_Button
@property (weak, nonatomic) IBOutlet UIButton *tiJiao_Button;//提交_Button
@property (weak, nonatomic) IBOutlet UIButton *fanHui_Button;//返回_Btton
@property (weak, nonatomic) IBOutlet UILabel *xianBanShiJian_Text;//限办时间_Text

@property (weak, nonatomic) IBOutlet UIButton *lingDaoShenYue_Button;//领导审阅_Button
@property (weak, nonatomic) IBOutlet UIButton *buMenShenYue_Button;//部门shenyue_Button


@property (nonatomic,strong) NSDictionary *dic_XuanRen;
@property (nonatomic,strong) NSDictionary *shouWenDic;
@property (nonatomic,strong) NSDictionary *dic_swdj;
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

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@end


@implementation DaiYueXiangQin_ViewController

static NSString *xuanRen = @"daiyuexuanren";//选人segue 选择领导人 == 1，部门人 == 2
static int type = 0;
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

    self.shouWen_WebView.delegate = self;
    [self sheZhiTextView_ShuXing];

    //给view添加数据   [self getHttpDic:self.shouWenDic] 访问服务器数据
    [self tianJia_ShuJuDic:[self getHttpDic:self.shouWenDic]];

    //添加按钮
    [self tianJianAnNiu];

    FaSongShuJu *a = [[FaSongShuJu alloc] init];
    a.delegate = self;
 }

- (void) viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
}
/*********************  基本方法  *********************/
#pragma  mark -- 基本方法

/**
  添加按钮，功能
 */
- (void) tianJianAnNiu{

//    //监听阅毕_Button
//    [self.yueBi_Button addTarget:self action:@selector(yeBi_Button_Click) forControlEvents:UIControlEventTouchDown];
//
    //默认关闭
    self.lingDaoShenYue_Button.hidden = YES;
    self.buMenShenYue_Button.hidden = YES;


    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *dept = [as stringForKey:@"dept"];

    //领导选人，显示
    if ([dept isEqualToString:@"000099"]) {

        self.lingDaoShenYue_Button.hidden = NO;

        //[self.lingDaoShenYue_Button addTarget:self action: forControlEvents:UIControlEventTouchDown ]
        [self.lingDaoShenYue_Button addTarget:self action:@selector(lingDaoXuanRen_Click) forControlEvents:UIControlEventTouchDown];
        type = 1;
    }else{

        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        NSString *role = [accountDefaults stringForKey:@"role"];

        //部门选择人
        self.buMenShenYue_Button.hidden = NO;
        [self.buMenShenYue_Button addTarget:self action:@selector(danWeiXuanRen_Click) forControlEvents:UIControlEventTouchDown];
        type = 2;
    }
}

/**
 阅毕_Button 按下以后触发事件
 */
- (IBAction)yeBI_Button_Click:(id)sender {

        NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
        NSString *name = [as stringForKey:@"username"];
    
        self.liuChenBean = [[LiuChenBean alloc] init];
        self.liuChenBean.spyj = [NSString stringWithFormat:@"已阅.%@%@",name,[self shiJian_DangQian]];
        self.liuChenBean.id = self.dic_swdj[@"ID"];
        self.liuChenBean.bz = self.dic_swdj[@"JSDE940"];
        self.liuChenBean.tablename = @"OA_FIP_GW_SW";
        self.liuChenBean.lcname = @"sw";
        self.liuChenBean.issh = @"1";
        self.liuChenBean.idlist = @"";
        self.liuChenBean.kslist = @"";
        self.liuChenBean.ldlist = @"";
        self.liuChenBean.names = @"";

        NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
        Util *util = [[Util alloc]init];
        NSString *LiuChen_Util = util.tuiLiuChen;

        [MBProgressHUD showMessage:@""];//等待
        //拼接，发送数据
        NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];
        //访问服务器
        NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];

        NSString *sting_CODE = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"CODE"]];
        //判断 code 没有数据，显示Text
        if ([sting_CODE isEqualToString:@""]) {

            [MBProgressHUD hideHUD];
            [IanAlert alertError:dic[@"TEXT"] length:1.0];
            return;
        }
        if ([sting_CODE intValue] != 1) {

            [MBProgressHUD hideHUD];
            [IanAlert alertError:dic[@"TEXT"] length:1.0];
            return;
        }else{

            //code 有数据，判断 function 没有数据，alert"text",关闭控制器
            NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];

            if ([sting_function isEqualToString:@""]) {

                [MBProgressHUD hideHUD];
                [IanAlert alertSuccess:dic[@"TEXT"] length:3.0];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }

/**
  提交button
 */
- (IBAction)tiJiao_Button_Click:(id)sender {

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *name = [as stringForKey:@"username"];
    NSString *dept = [as stringForKey:@"dept"];

    self.liuChenBean = [[LiuChenBean alloc] init];

    if ([self.dic_swdj[@"JSDE940"] isEqualToString:@"b05"] || [self.dic_swdj[@"JSDE940"] isEqualToString:@"b11"]) {

        //判断 部门与领导
        if ([dept isEqualToString:@"000099"]) {

            if(self.lingDaoShenYue_TextView.text.length < 1){

                [IanAlert alertError:@"请签名后提交!" length:1.0];
                return;
            }else{

                self.liuChenBean.spyj = self.lingDaoShenYue_TextView.text;
                self.liuChenBean.spyjColumn = @"LDYJQM";
            }
        }else{

            if(self.buMenShenYue_TextView.text.length < 1){

                [IanAlert alertError:@"请签名后提交!" length:1.0];
                return;
            }else{

                self.liuChenBean.spyj = self.buMenShenYue_TextView.text;
                self.liuChenBean.spyjColumn = @"BMYJQM";
            }
        }


    self.liuChenBean.id = self.dic_swdj[@"ID"];
    self.liuChenBean.bz = self.dic_swdj[@"JSDE940"];
    self.liuChenBean.tablename = @"OA_FIP_GW_SW";
    self.liuChenBean.lcname = @"sw";
    self.liuChenBean.issh = @"1";
    self.liuChenBean.idlist = self.dic_XuanRen[@"nameId"];
    self.liuChenBean.kslist = self.dic_XuanRen[@"kslistId"];
    self.liuChenBean.ldlist = self.dic_XuanRen[@"cdListid"];
    self.liuChenBean.names = self.dic_XuanRen[@"name"];
        
        //把前面，判断小手的。拿来
        if (type ==1) {
            
            if ([[NSString stringWithFormat:@"%@", self.dic_XuanRen[@"name"]] isEqualToString:@""]) {
                
               // self.lingDaoShenYue_TextView.text = [NSString stringWithFormat:@"已阅 %@ %@",name,[self shiJian_DangQian]];;
                [self yeBI_Button_Click:sender];
                return;
            }
        }

            [MBProgressHUD showMessage:@""];//等待

            NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
            Util *util = [[Util alloc]init];
            NSString *LiuChen_Util = util.tuiLiuChen;
            
            //拼接，发送数据
            NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];
            //访问服务器
            NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];
            
            NSString *sting_CODE = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"CODE"]];
            //判断 code 没有数据，显示Text
            if ([sting_CODE isEqualToString:@""]) {

                [MBProgressHUD hideHUD];
                [IanAlert alertError:dic[@"TEXT"] length:1.0];

                return;
            }
            
            if ([sting_CODE intValue] != 1) {

                [MBProgressHUD hideHUD];
                [IanAlert alertError:dic[@"TEXT"] length:1.0];
                
                return;
            }else{
                
                NSString *sting_function = [self.faSongShuJu String_PanDuanFeiKongString:dic[@"function"]];
                
                if ([sting_function isEqualToString:@""]) {

                    [MBProgressHUD hideHUD];
                    [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{

                    [MBProgressHUD hideHUD];
                    [MBProgressHUD hideHUD];[MBProgressHUD hideHUD];
                    _array_person = dic[@"person"];
                    NSDictionary *dic_CurrentDESC = dic[@"CurrentDESC"];
                    self.ZTBS = dic_CurrentDESC[@"ZTBS"];
                    
                    //弹出，显示框
                    [self tianJian_PopChuanKo];
                }
            }
        }
  }

/**
  领导选人点击以后
 */
- (void) lingDaoXuanRen_Click{

    [self performSegueWithIdentifier:xuanRen sender:nil];
}

/**
 单位选人点击以后
 */
- (void) danWeiXuanRen_Click{

    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role = [accountDefaults stringForKey:@"role"];


    [self performSegueWithIdentifier:xuanRen sender:nil];
}

/**
  segue 跳转
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    RenWuZhuanXie_SelectMen_TableViewController *ren = segue.destinationViewController;

    self.delegate = ren;

    NSDictionary *dic = nil;
    if (type == 1) {
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"type",@"",@"rolename",nil];
    }else{
         dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"type",@"oa_swdw",@"rolename",nil];
    }

    [self.delegate addType:dic];
    ren.delegate_AddName = self;
}

/**
  设置UiTextView的属性
 */
- (void) sheZhiTextView_ShuXing{

    [self textView_BianKuanTextView:self.banGongShi_YiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoShenYue_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoYiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.buMenShenYue_TextView Text:@""];
    [self textView_BianKuanTextView:self.buMenYiJian_TextView Text:@""];

    self.all_ScrollView.delegate = self;
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

#pragma  mark -- 访问访问器
/**
  访问服务器
 */
- (NSDictionary *) getHttpDic:(NSDictionary *)dic{

    GetHttp *http = [[GetHttp alloc] init];

    Util *util = [[Util alloc] init];
    NSString *util_string = [util shouWen_NeiRong];

    NSString  *pinJie = [NSString stringWithFormat:@"ID=%@&bz=%@",dic[@"ID"],dic[@"JSDE940"]];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 view添加数据
 */
- (void) tianJia_ShuJuDic:(NSDictionary *)dic{

    //解析数据
    self.dic_swdj = dic[@"swdj"];

    self.biaoTi_Text.text = self.dic_swdj[@"TITLE"];
    self.LaiWenDanWei_Text.text = self.dic_swdj[@"LWDW"];
    //正文 超链接与下载
    NSString *abc = [NSString stringWithFormat:@"%@",self.dic_swdj[@"ZW"]];
    [PinJie zhenWenString:abc WebView:self.shouWen_WebView];
    self.banGongShi_YiJian_TextView.text = self.dic_swdj[@"NBYJ"];
    self.lingDaoYiJian_TextView.text = self.dic_swdj[@"LDYJ"];
    self.lingDaoShenYue_TextView.text = @"";
    self.buMenShenYue_TextView.text = self.dic_swdj[@"BMYJQM"];
    self.buMenYiJian_TextView.text = self.dic_swdj[@"BMYJ"];
    self.xianBanShiJian_Text.text = [self string_JieQuString:self.dic_swdj[@"BLTIME"] NumBer:11];
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

/******************* 代理方法 ******************/
#pragma  mark -- 代理方法

/**
 RenWuZhuanXie_SelectMen_TableViewControllerDelegate 添加人
 */
- (void) addNameDic:(NSDictionary *)dic{

    self.dic_XuanRen = dic;
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *name = [as stringForKey:@"username"];

    //领导，部门，textView里面数据
    if (type ==1) {

        if ([[NSString stringWithFormat:@"%@", self.dic_XuanRen[@"name"]] isEqualToString:@""]) {

            self.lingDaoShenYue_TextView.text = [NSString stringWithFormat:@"已阅 %@ %@",name,[self shiJian_DangQian]];
        }else{

            self.lingDaoShenYue_TextView.text = [NSString stringWithFormat:@"请%@阅。 %@ %@",self.dic_XuanRen[@"name"],name,[self shiJian_DangQian]];
        }
    }else{

        if ([[NSString stringWithFormat:@"%@", self.dic_XuanRen[@"name"]] isEqualToString:@""]) {

             self.buMenShenYue_TextView.text = [NSString stringWithFormat:@"已阅 %@ %@",name,[self shiJian_DangQian]];;
        }else{

             self.buMenShenYue_TextView.text = [NSString stringWithFormat:@"请%@阅。%@ %@",self.dic_XuanRen[@"name"],name,[self shiJian_DangQian]];
        }
    }
}

#pragma  mark -- uiscrollView的代理方法
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   [self.view endEditing:YES];
}

#pragma 收文待遇的代理 dic
-(void) addDic:(NSDictionary *)dic{

    self.shouWenDic = dic;
}

/**
  string 截取 nr 前面的几位 不包括nr位
 */
- (NSString *) string_JieQuString:(NSString *)string NumBer:(int)nr{
    
    if (string.length < nr) {
        
        return @"";
    }
    return  [string substringToIndex:nr];
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
        }else{

            xuanZhe = 2;
            [self tianJian_PopChuanKo_Person_Dan];
        }
    }else if (xuanZhe == 2) {
        xuanZhe = 1;
        NSArray * list =  [self list_Person];
        self.names_XuanZeRen_Jie = list[index][@"name"];
        self.idList_XuanZeRen_Jie = list[index][@"oid"];

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

/**
 webview调用safari浏览
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    // Will execute this block only when links are clicked
    if( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        
        NSURL *url = [request URL];
        NSString *str1 = [url absoluteString];
        NSRange range = [str1 rangeOfString:@"downname="];
        int location = range.location;
        NSString *filename = [str1 substringFromIndex:location+9];

        range = [filename rangeOfString:@"&path"];
        location = range.location;
        filename = [filename substringToIndex:location];
        range = [filename rangeOfString:@"."];
        filename = [filename substringFromIndex:range.location];
        self.filename =[NSString stringWithFormat:@"%@%@",@"temp",filename];

        [MBProgressHUD showMessage:@"正在努力加载中...."];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        if (connection)
        {
            self.receivedData = [NSMutableData data];//初始化接收数据的缓存
        }
        else
        {
          //  NSLog(@"Bad Connection!");
        }
        return NO;

    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];//置空数据
    long long mp3Size = [response expectedContentLength];//获取要下载的文件的长度
  //  NSLog(@"%@",response.MIMEType) ;
  //  NSLog(@"%lld",mp3Size);

}

//接收NSMutableData数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSRange range = [self.filename  rangeOfString:@".txt"];
    int bz =range.length;

    if (bz>0) {


        //判断是UNICODE编码
        NSString *isUNICODE = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        //还是ANSI编码
        NSString *isANSI = [[NSString alloc] initWithData:data encoding:-2147482062];

        if (isUNICODE) {

            NSString *retStr = [[NSString alloc]initWithCString:[isUNICODE UTF8String] encoding:NSUTF8StringEncoding];

            NSData *data1 = [retStr dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }
        else if(isANSI){

            NSData *data1 = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }

    }else{

        [_receivedData appendData:data];
    }
}

//接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    [connection cancel];
    [MBProgressHUD hideHUD];
    //在保存文件和播放文件之前可以做一些判断，保证程序的健壮行：例如：文件是否存在，接收的数据是否完整等处理，此处没加，使用时注意
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSLog(@"mp3 path=%@",documentsDirectory);
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: self.filename];//mp3Name:你要保存的文件名称，包括文件类型。如果你知道文件类型的话，可以指定文件类型；如果事先不知道文件类型，可以在- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response中获取要下载的文件类型

    //在document下创建文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    NSLog(@"mp3 path=%@",filePath);
    //将下载的数据，写入文件中
    [_receivedData writeToFile:filePath atomically:YES];

    //播放下载下来的mp3文件
    [self openfile:filePath];


    //如果下载的是图片则可以用下面的方法生成图片并显示 create image from data and set it to ImageView
    /*
     UIImage *image = [[UIImage alloc] initWithData:recvData];
     [imgView setImage:image];
     */
}

/**
 webview调用safari浏览
 */
-(void)openfile:(NSString *)filePath {

    QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];
    qu.path = filePath;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:qu animated:YES];
    
}

/******************* 工具方法 ******************/
#pragma  mark -- 工具方法

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


@end
