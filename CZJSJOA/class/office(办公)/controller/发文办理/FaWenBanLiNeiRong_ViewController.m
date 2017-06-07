//
//  FaWenBanLiNeiRong_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/11.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "FaWenBanLiNeiRong_ViewController.h"
#import "FaWenBanLi_ViewController.h"

#import "FaSongShuJu.h"
#import "LiuChenBean.h"
#import "Util.h"
#import "LPPopupListView.h"
#import "QuickLookVC.h"

@interface FaWenBanLiNeiRong_ViewController ()<UITextViewDelegate,UIScrollViewDelegate,FaWenBanLi_ViewControllerDelegate,LPPopupListViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *all_ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *biaoTi_Text;//标题
//@property (strong, nonatomic) IBOutlet UILabel *zhengWenNeiRong_Text;//正文内容
//@property (strong, nonatomic) IBOutlet UILabel *fuJian_Text;//附件
@property (weak, nonatomic) IBOutlet UITextView *qianFa_TxetView;//签发_TextView
@property (weak, nonatomic) IBOutlet UITextView *huiQian_TextView;//会签_TextView
@property (weak, nonatomic) IBOutlet UITextView *banGongShi_TextView;//办公室核稿_TextView
@property (weak, nonatomic) IBOutlet UITextView *huiGao_TextView;//会搞_TextView
@property (weak, nonatomic) IBOutlet UITextView *danWeiYiJian_TxtView;//单位意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMenYiJian_01_TextView;//部门意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *fenFaFnWei_TextView;//分发范围_TextView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoShenYue_TextView;//领导审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *lingDaoYiJian_TextView;//领导意见_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMengShenYue_textView;//部门审阅_TextView
@property (weak, nonatomic) IBOutlet UITextView *buMengYiJian_TextView;//部门意见_TextView  上面
@property (weak, nonatomic) IBOutlet UIWebView *zhenWen_Web;//正文_Web
@property (weak, nonatomic) IBOutlet UIWebView *fuJian_Web;//附件_Web
@property (weak, nonatomic) IBOutlet UIButton *tiJiao_Button;//提交_Button

//控制button
@property (weak, nonatomic) IBOutlet UIButton *qianFa_Button;//签发
@property (weak, nonatomic) IBOutlet UIButton *huiQian_Button;//会签
@property (weak, nonatomic) IBOutlet UIButton *banGongShi_Button;//办公室
@property (weak, nonatomic) IBOutlet UIButton *huiGao_Button;//会搞
@property (weak, nonatomic) IBOutlet UIButton *danWei_Button;//单位
@property (weak, nonatomic) IBOutlet UIButton *buMenYiJian_01_Button;//部门
@property (weak, nonatomic) IBOutlet UIButton *fenFa_Button;//分发
@property (weak, nonatomic) IBOutlet UIButton *lingDaoShenYue_Button;//领导审阅
@property (weak, nonatomic) IBOutlet UIButton *lingDaoYiJian_Button;//领导意见
@property (weak, nonatomic) IBOutlet UIButton *buMenShenYue_Button;//部门审阅
@property (weak, nonatomic) IBOutlet UIButton *buMenYiJian_Button;//部门意见   上面

@property (nonatomic,strong) NSDictionary *dic_FaWen;//发文办理传递过来的数据
@property (nonatomic,strong) NSDictionary *dic_swdj;//dic_swdj

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

@implementation FaWenBanLiNeiRong_ViewController

//选择，单选 == 0，选节点 == 1
static int xuanZhe = 1;

- (FaSongShuJu *)faSongShuJu{


    if (_faSongShuJu == nil) {

        _faSongShuJu = [[FaSongShuJu alloc] init];
    }

    return _faSongShuJu;
}

-(LiuChenBean *) liuChenBean {

    if (_liuChenBean == nil) {

        _liuChenBean = [[FaSongShuJu alloc] init];
    }

    return _liuChenBean;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tianJian_Button];
    [self sheZhiTextView_ShuXing];

    [self tianJia_ShuJuDic:[self getHttpDic:self.dic_FaWen]];
    [self tianJian_YinChang_AnNiuDic_swdj:self.dic_swdj];//添加隐藏button
    self.zhenWen_Web.delegate = self;
    self.fuJian_Web.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUD];
}
/****************** 基本方法 *****************/
#pragma  mark -- 基本方法

/**
  控制隐藏按钮
 */
- (void) tianJian_YinChang_AnNiuDic_swdj:(NSDictionary *)Dic_swdj{

    self.qianFa_Button.hidden = YES;//签发
    self.huiQian_Button.hidden = YES;//会签
    self.banGongShi_Button.hidden = YES;//办公室
    self.huiGao_Button.hidden = YES;//会搞
    self.danWei_Button.hidden = YES;//单位
    self.buMenYiJian_01_Button.hidden = YES;//部门
    self.fenFa_Button.hidden = YES;//分发
    self.lingDaoShenYue_Button.hidden = YES;//领导审阅
    self.lingDaoYiJian_Button.hidden = YES;//领导意见
    self.buMenShenYue_Button.hidden = YES;//部门审阅
    self.buMenYiJian_Button.hidden = YES;//部门意见
    self.buMenYiJian_01_Button.hidden = YES;
    self.buMenYiJian_Button.hidden = YES;


    //缓存数据
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *name = [as stringForKey:@"username"];

    NSString *bz = [self String_PanDuanFeiKongString:Dic_swdj[@"JSDE940"]];//步骤判断
   
    NSString *spyj = @"";//审批意见
    NSString *spyjColumn = @"";

    if ([bz isEqualToString:@"b02"]||[bz isEqualToString:@"b18"]) {
            spyj = [NSString stringWithFormat:@"%@%@",name,[self shiJian_DangQian]];
        if (![self.buMengYiJian_TextView.text isEqualToString:@""]) {

            spyj = [NSString stringWithFormat:@"%@\r\n%@",self.buMengYiJian_TextView.text,spyj];
        }
        else{
            spyj = [NSString stringWithFormat:@"%@",spyj];
        }

        self.buMengYiJian_TextView.text = spyj;
        spyjColumn = @"BMHGYJ";
    }
    else if ([bz isEqualToString:@"b03"]){

        spyj = [NSString stringWithFormat:@"%@%@",name,[self shiJian_DangQian]];
        if (![self.danWeiYiJian_TxtView.text isEqualToString:@""]) {
            
            spyj = [NSString stringWithFormat:@"%@\r\n%@",self.danWeiYiJian_TxtView.text,spyj];
        }
        else{
            
            spyj = [NSString stringWithFormat:@"%@",spyj];
        }


        self.danWeiYiJian_TxtView.text = spyj;
        spyjColumn = @"DWYJ";
    }
    else if ([bz isEqualToString:@"b04"] ||[bz isEqualToString:@"b15"]||[bz isEqualToString:@"b17"]){

        spyj = [NSString stringWithFormat:@"%@%@",name,[self shiJian_DangQian]];
        if (![self.huiGao_TextView.text isEqualToString:@""]) {
            
            spyj = [NSString stringWithFormat:@"%@\r\n%@",self.huiGao_TextView.text,spyj];
        }
        else{
            spyj = [NSString stringWithFormat:@"%@",spyj];
        }

        self.huiGao_TextView.text = spyj;
        spyjColumn = @"HGYJ";
    }
    else if ([bz isEqualToString:@"b16"]){

        
        spyj = [NSString stringWithFormat:@"%@%@",name,[self shiJian_DangQian]];
        if (![self.banGongShi_TextView.text isEqualToString:@""]) {
            
            spyj = [NSString stringWithFormat:@"%@\r\n%@",self.banGongShi_TextView.text,spyj];
        }
        else{
            spyj = [NSString stringWithFormat:@"%@",spyj];
            
        }

        self.banGongShi_TextView.text = spyj;
        spyjColumn = @"BGSHGSYJ";
    }
    else if([bz isEqualToString:@"b05"]){

        self.huiQian_Button.hidden = NO;

        spyjColumn = @"QFYJ";
        //添加button
        [self.huiQian_Button addTarget:self action:@selector(huiQian_Button_Click) forControlEvents:UIControlEventTouchDown];
    }
    else if ([bz isEqualToString:@"b06"] ||[bz isEqualToString:@"b07"]){

        self.qianFa_Button.hidden = NO;
        spyjColumn = @"ZYYJ";
        [self.qianFa_Button addTarget:self action:@selector(qianFa_Button_Click) forControlEvents:UIControlEventTouchDown];
    }

    self.liuChenBean.spyjColumn = spyjColumn;
    self.liuChenBean.spyj = spyj;
}

/**
  会签button
 */
-(void) huiQian_Button_Click{

    //缓存数据
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *name = [as stringForKey:@"username"];

    NSString *spyj =[NSString stringWithFormat:@"同意%@%@",name,[self shiJian_DangQian]];//审批意见

   NSString *hQ = self.huiQian_TextView.text;

    if (![hQ isEqualToString:@""]) {

        spyj = [NSString stringWithFormat:@"%@\r\n%@",hQ,spyj];
    }

    self.huiQian_TextView.text = spyj;
    self.liuChenBean.spyj = spyj;
}

/**
  签发
 */
-(void) qianFa_Button_Click{

    //缓存数据
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    NSString *name = [as stringForKey:@"username"];

    NSString *spyj =[NSString stringWithFormat:@"同意%@%@",name,[self shiJian_DangQian]];//审批意见

    NSString *hQ = self.qianFa_TxetView.text;

    if (![hQ isEqualToString:@""]) {

        spyj = [NSString stringWithFormat:@"%@\r\n%@",hQ,spyj];
    }

    self.qianFa_TxetView.text = spyj;
    self.liuChenBean.spyj = spyj;
}

/**
  添加button
 */
-(void) tianJian_Button{

    [self.tiJiao_Button addTarget:self action:@selector(tiJiao_Button_Click) forControlEvents:UIControlEventTouchDown];
}


- (IBAction)faHui_Button_Click:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

/**
  提交_button_click
 */
-(void) tiJiao_Button_Click{

    NSString *spyjColumn = @"";
    NSString *spyj = @"";

    NSString *bz =  self.dic_swdj[@"JSDE940"];
 
    if ([bz isEqualToString:@"b02"] || [bz isEqualToString:@"b18"]) {

        spyj = self.buMengYiJian_TextView.text;
        spyjColumn = @"BMYJQM";
    }
    else if ([bz isEqualToString:@"b03"]){

        spyj = self.danWeiYiJian_TxtView.text;
        spyjColumn = @"DWYJ";
    }
    else if ([bz isEqualToString:@"b15"] ||[bz isEqualToString:@"b04"]||[bz isEqualToString:@"b17"]){

        spyj =self.huiGao_TextView.text;
        spyjColumn = @"HGYJ";
    }
    else if ([bz isEqualToString:@"b16"]){

        spyj =self.banGongShi_TextView.text;
        spyjColumn = @"BGSHGSYJ";
    }
    else if ([bz isEqualToString:@"b05"]){

        spyj =self.huiQian_TextView.text;
        spyjColumn = @"QFYJ";

        if ([spyj isEqualToString:@"" ]) {

             [IanAlert alertError:@"请点击小手图标签名后提交" length:1.0];
            return;
        }
    }
    else if ([bz isEqualToString:@"b06"]|| [bz isEqualToString:@"b07"]){

        spyj =self.qianFa_TxetView.text;
        spyjColumn = @"ZYYJ";

        if ([spyj isEqualToString:@"" ]) {

            [IanAlert alertError:@"请点击小手图标签名后提交" length:1.0];
            return;
        }
    }
    else{

        return;
    }

    if ([spyj isEqualToString:@""]) {

        [IanAlert alertError:@"请点击小手图标签名后提交！" length:2.0];
        return;
    }

    self.liuChenBean.id = self.dic_swdj[@"ID"];
    self.liuChenBean.bz = self.dic_swdj[@"JSDE940"];
    self.liuChenBean.tablename = @"OA_FIP_GW_FW";
    self.liuChenBean.lcname = @"fw";
    self.liuChenBean.issh = @"1";
    self.liuChenBean.idlist = @"";
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = @"";
    self.liuChenBean.spyj= spyj;
   // self.liuChenBean.spyjColumn = spyjColumn;

    NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;

   // [MBProgressHUD showMessage:@""];
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

            [IanAlert alertSuccess:dic[@"TEXT"] length:2.0];
            [self.navigationController popViewControllerAnimated:YES];

            return;
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

/**
 设置UiTextView的属性
 */
- (void) sheZhiTextView_ShuXing{

    [self textView_BianKuanTextView:self.qianFa_TxetView Text:@""];
    [self textView_BianKuanTextView:self.huiQian_TextView Text:@""];
    [self textView_BianKuanTextView:self.banGongShi_TextView Text:@""];
    [self textView_BianKuanTextView:self.huiGao_TextView Text:@""];
    [self textView_BianKuanTextView:self.danWeiYiJian_TxtView Text:@""];
    [self textView_BianKuanTextView:self.buMenYiJian_01_TextView Text:@""];
    [self textView_BianKuanTextView:self.fenFaFnWei_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoShenYue_TextView Text:@""];
    [self textView_BianKuanTextView:self.lingDaoYiJian_TextView Text:@""];
    [self textView_BianKuanTextView:self.buMengShenYue_textView Text:@""];
    [self textView_BianKuanTextView:self.buMengYiJian_TextView Text:@""];

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
    NSString *util_string = [util faWen_NeiRong];

    NSString  *pinJie = [NSString stringWithFormat:@"ID=%@&bz=%@",dic[@"ID"],dic[@"JSDE940"]];

    //返回，dic数据
    return [http getHttpPinJie_JiaZai:pinJie Util:util_string];
}

/**
 view添加数据
 */
- (void) tianJia_ShuJuDic:(NSDictionary *)dic{

    self.dic_swdj = dic[@"swdj"];

    self.biaoTi_Text.text = self.dic_swdj[@"TITLE"];
    self.banGongShi_TextView.text = self.dic_swdj[@"BGSHGSYJ"];
    self.qianFa_TxetView.text = self.dic_swdj[@"ZYYJ"];
    self.huiQian_TextView.text = self.dic_swdj[@"QFYJ"];
    self.huiGao_TextView.text = self.dic_swdj[@"HGYJ"];
    self.danWeiYiJian_TxtView.text = self.dic_swdj[@"DWYJ"];
    self.buMenYiJian_01_TextView.text = self.dic_swdj[@"BMYJ"];
    self.fenFaFnWei_TextView.text = self.dic_swdj[@"NBYJ"];
    self.lingDaoShenYue_TextView.text = self.dic_swdj[@"LDSHYJ"];
    self.lingDaoYiJian_TextView.text = self.dic_swdj[@"LDYJ"];
    self.buMengShenYue_textView.text = self.dic_swdj[@"BMYJQM"];
    self.buMengYiJian_TextView.text = self.dic_swdj[@"BMHGYJ"];

    //正文
     [self zhenWenString:self.dic_swdj[@"RECORDID"]];
    [self fuJianString:self.dic_swdj[@"FJNAME"]];
}

/**
  正文的拼接和超链接
 */
- (void) zhenWenString:(NSString *)string{

    NSString *pingJie;

    //判断nil
    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""]) {

        Util *util = [[Util alloc] init];
        NSString *xiaZai = [util xiaZai];

        pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<a href='",xiaZai,@"?filename=",string,@"&downname=",string,@".doc&path=&uploadtype=doc'>",string,@".doc</a><br>"];
    }

    //替换html文件
    //拿系统里面“context.html”文件
    NSString *homePath = [[NSBundle mainBundle] executablePath];
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];
    NSString *rawDirectory = [homePath substringToIndex:
                              [homePath length]-[executableName length]-1];
    NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" "
                                                                      withString:@"%20"];
    NSString *htmlFile = [NSString stringWithFormat:@"file://%@/download.html",baseDirectory];

    //把文件里面的数据拿出来
    NSURL *url = [NSURL URLWithString: htmlFile];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    //NSData *fileData = [NSData dataWithContentsOfFile:htmlFile];

    //得到uiview里面的样式
    NSString *htmlContent = [[NSMutableString alloc] initWithData:
                             fileData encoding:NSUTF8StringEncoding];

    //替换里面的数据
   NSString *string_TiHuan = [NSString stringWithFormat: htmlContent,pingJie];

    [self.zhenWen_Web loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

/**
  附件的拼接和超链接
 */
- (void) fuJianString:(NSString *)string{

    NSString *pingJie = @"";
    Util *util = [[Util alloc] init];
    NSString *xiaZai = [util xiaZai];

    if (string != nil && ![string isEqualToString:@""]) {

        NSArray *array = [string componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组

        //不清楚，到底有几个附件，迭代出来
        for (NSString *fuJian_fj in array) {

            //把附件分层filename 与 idname
            NSArray *array = [fuJian_fj componentsSeparatedByString:@":"];

            NSString *id  = array[0];
            NSString *downname = array[1];

            pingJie = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",pingJie,@"<a href='",xiaZai,@"?filename=",id,@"&downname=",downname,@"&path=&uploadtype='>",downname,@"</a><br>"];
        }
    }

    //替换html文件
    //拿系统里面“context.html”文件
    NSString *homePath = [[NSBundle mainBundle] executablePath];
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];
    NSString *rawDirectory = [homePath substringToIndex:
                              [homePath length]-[executableName length]-1];
    NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" "
                                                                      withString:@"%20"];
    NSString *htmlFile = [NSString stringWithFormat:@"file://%@/download_01.html",baseDirectory];

    //把文件里面的数据拿出来
    NSURL *url = [NSURL URLWithString: htmlFile];
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    //NSData *fileData = [NSData dataWithContentsOfFile:htmlFile];

    //得到uiview里面的样式
    NSString *htmlContent = [[NSMutableString alloc] initWithData:
                             fileData encoding:NSUTF8StringEncoding];

    //替换里面的数据
    NSString *string_TiHuan = [NSString stringWithFormat: htmlContent,pingJie];

    [self.fuJian_Web loadHTMLString:string_TiHuan baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)
}

/****************** 代理方法 *****************/
#pragma  mark -- 代理方法

/**
  web代理
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{

    // Will execute  this block only when links are clicked
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
        else{

            NSLog(@"Bad Connection!");
        }

        return NO;

    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];//置空数据
    long long mp3Size = [response expectedContentLength];//获取要下载的文件的长度
    NSLog(@"%@",response.MIMEType) ;
    NSLog(@"%lld",mp3Size);

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
        }else if(isANSI){

            NSData *data1 = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
            [_receivedData appendData:data1];
        }

    }else{

        [_receivedData appendData:data];
    }
}

//接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    [MBProgressHUD hideHUD];
    //在保存文件和播放文件之前可以做一些判断，保证程序的健壮行：例如：文件是否存在，接收的数据是否完整等处理，此处没加，使用时注意
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"mp3 path=%@",documentsDirectory);
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
  web
 */
-(void)openfile:(NSString *)filePath {

    QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];
    qu.path = filePath;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:qu animated:YES];
    
}

#pragma  mark -- FaWenBanLi_ViewControllerDelegate 传递数据
- (void) addDic:(NSDictionary *)dic{

    self.dic_FaWen = dic;
}

#pragma  mark -- uiscrollView的代理方法
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - LPPopupListViewDelegate代理方法s
//点击事件
- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index{

    NSLog(@"popUpListView - didSelectIndex: %d", (int)index);

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

    xuanZhe = 1;
    self.names_XuanZeRen = @"";
    self.idList_XuanZeRen = @"";
    self.selectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:selectedIndexes];

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

/****************** 工具方法 *****************/
#pragma  mark -- 工具方法

/**
 string 截取 nr 前面的几位 不包括nr位
 */
- (NSString *) string_JieQuString:(NSString *)string NumBer:(int)nr{
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
 string判断是不是null
 */
- (NSString *) String_PanDuanFeiKongString:(NSString *)string{

    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""] && ![string isEqualToString:@"\n"] && ![string isEqualToString:@"\r"] && ![string isEqual:@""] && string.length != 0) {

        return string;
    }
    return @"";
}

@end
