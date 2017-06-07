//
//  RenWuZhuanXieTianJia_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/25.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "RenWuZhuanXieTianJia_ViewController.h"
#import "RenWuZhuanXie_ViewController.h"
#import "RenWuZhuanXie_SelectMen_TableViewController.h"
#import "BaoCunBean.h"

@interface RenWuZhuanXieTianJia_ViewController ()<RenWuZhuanXie_ViewControllerDelegate,RenWuZhuanXie_SelectMen_TableViewControllerDelegate,UISearchBarDelegate>{

     UIToolbar *toolBar;
     UIDatePicker *selectDate;
}

@property (weak, nonatomic) IBOutlet UITextView *content_TextView;//多内容
@property (weak, nonatomic) IBOutlet UITextField *time_Text;//时间
@property (weak, nonatomic) IBOutlet UITextField *renWuJIeShouZhe_Text;
@property (weak, nonatomic) IBOutlet UISwitch *duanXin_Swith;//是否发送短信
@property (weak, nonatomic) IBOutlet UIButton *baoCun_Button;//保存
@property (weak, nonatomic) IBOutlet UIButton *tiJiao_Button;//提交
@property (weak, nonatomic) IBOutlet UIButton *fanHui_Button;//返回

@property (nonatomic,copy) NSString *renWuJIeShouZhe;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,strong) NSMutableDictionary *dic_selectMen;//选择人代理数据
@property (nonatomic,strong) GetHttp *http;
@property (nonatomic,assign) int type;//判断？任务撰写 == 4 ： 任务检索 == 5
@property (nonatomic,strong) NSDictionary *kaiShiDic;//开始得到的数据
@property (nonatomic,strong) NSArray *kaiShiArray;//开始得到的数据
@end

@implementation RenWuZhuanXieTianJia_ViewController

  static int aa = 0;

- (void)viewDidLoad {
    [super viewDidLoad];

    //内容框设置
    self.content_TextView.layer.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor;
    self.content_TextView.layer.borderWidth =1.0;
    self.content_TextView.layer.cornerRadius =5.0;
    self.content_TextView.text = @"";

    self.renWuJIeShouZhe_Text.userInteractionEnabled = NO;
    //不能被编辑
    self.time_Text.userInteractionEnabled = NO;

    //过来，不是添加功能，实现提交
    if(self.dic != nil){

        self.dic_selectMen = [NSMutableDictionary dictionary];
        NSDictionary *dic = [self addData_KaiShiDic:self.dic];
    
        self.kaiShiArray = dic[@"list"];
        self.kaiShiDic = self.kaiShiArray[0];
        self.dic_selectMen[@"nameId"] = self.kaiShiDic[@"FBFWID"];
        //页面显示数据
        self.renWuJIeShouZhe_Text.text = self.kaiShiDic[@"FBFW"];
        self.time_Text.text = [self string_JieQuString:self.kaiShiDic[@"YQSJ"] NumBer:11];
        self.content_TextView.text = self.kaiShiDic[@"RW"];
    }else{
        self.dic = [NSMutableDictionary dictionary];
        self.dic[@"BZ"] = @"";
        self.dic[@"ID"] = @"";
    }

    [self yinCangButtonDic:self.dic Type:self.type];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

     [[self view] endEditing:YES];
}

/**
    判断butto是不死要被隐藏
 */
- (void) yinCangButtonDic:(NSDictionary *)dic Type:(int)type{

    NSString *BZ = [NSString stringWithFormat:@"%@",dic[@"BZ"]];
    NSString *ISWC = [NSString stringWithFormat:@"%@",dic[@"ISWC"]];

#pragma mark --是不是要隐藏，type == 5 任务检索
    //隐藏button按钮 type == 5
    if([BZ isEqualToString:@"b01"] || [ISWC isEqualToString:@"1"] || type == 5){

        self.tiJiao_Button.hidden = YES;
        self.fanHui_Button.hidden = YES;
        self.baoCun_Button.hidden = YES;
    }
}


- (IBAction)fanHui_Button_Click:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  人选择_button
 *
 *  @param sender <#sender description#>
 */
- (IBAction)men_Button:(id)sender {

    [self performSegueWithIdentifier:@"men" sender:nil];
}

/**
 *  跳转方法
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    RenWuZhuanXie_SelectMen_TableViewController *tr = segue.destinationViewController;
    tr.delegate_AddName = self;//反向代理

    //正向代理
    self.delegate = tr;
    [self.delegate addType_RenWu:@"1"];
}

/**
 * 保存按钮
 *  @param sender <#sender description#>
 */
- (IBAction)baoCun_Button:(id)sender {

   int a = [self baoCunType:@"save"];

   if( a == 1) [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  提交按钮,先保存，后提交
 *  @param sender <#sender description#>
 */
- (IBAction)tiJiao_Button:(id)sender {

   int a =   [self baoCunType:@"go"];
 if( a == 1) [self.navigationController popViewControllerAnimated:YES];}

/**
  返回（到前面view）
 */
- (IBAction)fanHui:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  保存按钮，调用方法（防止在提交过程调用保存）
    成功 ？ int == 1 : int == 0
 */
- (int) baoCunType:(NSString *)type{

   NSDictionary *dic = self.kaiShiArray[0];
     if (self.content_TextView.text.length < 1){

        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"内容不能为空" length:abcd];
        return 0;
    }else if(self.renWuJIeShouZhe_Text.text.length < 1) {

        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"名字不能为空" length:abcd];
        return 0;
    }else{

        //把userid 从缓存里拿出
        NSUserDefaults *as = [NSUserDefaults standardUserDefaults];

        BaoCunBean *baoCunBean = [[BaoCunBean alloc] init];
        baoCunBean.ISDX = @"0";
        baoCunBean.TYPE = type;//判断 保存，提交
        baoCunBean.FBFWID = self.dic_selectMen[@"nameId"];
        baoCunBean.NRTIME =[ChangYong_NSObject DanQianTime];//当前时间
        baoCunBean.NGBMID = [as stringForKey:@"dept"];
        baoCunBean.NGR = [as stringForKey:@"username"];
        baoCunBean.BZ = self.dic[@"BZ"];
        baoCunBean.FBFW = self.renWuJIeShouZhe_Text.text;
        baoCunBean.NGRID = [as stringForKey:@"userid"];
        baoCunBean.YQSJ = self.time_Text.text;//时间，不知道格式
        baoCunBean.ID = self.dic[@"ID"];
        baoCunBean.NGBM = [as stringForKey:@"deptname"];
        baoCunBean.RW = self.content_TextView.text;

      [self addDataBaoCunBean:baoCunBean];

        return 1;
    }
}

/**
  提交的方法
 */
- (void)tiJiao{

    NSDictionary *dic = self.kaiShiArray[0];
    
    if(self.time_Text.text.length < 1){
//
//        NSTimeInterval abcd = 1.0;
//        [IanAlert alertError:@"时间不能为空" length:abcd];
//

    }else  if (self.content_TextView.text.length < 1){

        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"内容不能为空" length:abcd];

    }else if(self.renWuJIeShouZhe_Text.text.length < 1) {

        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"名字不能为空" length:abcd];

    }else{

        //把userid 从缓存里拿出
        NSUserDefaults *as = [NSUserDefaults standardUserDefaults];

        BaoCunBean *baoCunBean = [[BaoCunBean alloc] init];
        baoCunBean.ISDX = @"0";
        baoCunBean.TYPE = @"go";//判断 保存，提交
        baoCunBean.FBFWID = self.dic_selectMen[@"nameId"];
        baoCunBean.NRTIME =[ChangYong_NSObject DanQianTime];//当前时间
        baoCunBean.NGBMID = [as stringForKey:@"dept"];
        baoCunBean.NGR = [as stringForKey:@"username"];
        baoCunBean.BZ = self.dic[@"BZ"];
        baoCunBean.FBFW = self.renWuJIeShouZhe_Text.text;
        baoCunBean.NGRID = [as stringForKey:@"userid"];
        baoCunBean.YQSJ = self.time_Text.text;//时间，不知道格式
        baoCunBean.ID = self.dic[@"ID"];
        baoCunBean.NGBM = [as stringForKey:@"deptname"];
        baoCunBean.RW = self.content_TextView.text;
        
        [self addDataBaoCunBean:baoCunBean];
    }
}

/**
 *  服务器申请数据(开始的时候，调用的数据)
 *  @return
 */
- (NSDictionary *) addData_KaiShiDic:(NSDictionary *)dic{

    //添加数据
    self.http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    NSString *util_String = [util renWu_TianJia];

    NSString *pinJie = [NSString stringWithFormat:@"ID=%@&type=%@&BZ=%@",dic[@"ID"],@"sq",dic[@"BZ"]];

    return [self.http getHttpPinJie:pinJie Util:util_String];
}

/**
 *  服务器申请数据
 *
 *  @return
 */
- (NSDictionary *) addDataBaoCunBean:(BaoCunBean *)baoCunBean{

    //添加数据
    self.http = [[GetHttp alloc] init];
    Util *util = [[Util alloc] init];
    NSString *util_String = [util baoCun];

    NSString *pinJie = [NSString stringWithFormat:@"ISDX=%@&TYPE=%@&FBFWID=%@&NRTIME=%@&NGBMID=%@&NGR=%@&BZ=%@&FBFW=%@&NGRID=%@&YQSJ=%@&ID=%@&NGBM=%@&RW=%@",baoCunBean.ISDX,baoCunBean.TYPE,baoCunBean.FBFWID,baoCunBean.NRTIME,baoCunBean.NGBMID,baoCunBean.NGR,baoCunBean.BZ,baoCunBean.FBFW,baoCunBean.NGRID,baoCunBean.YQSJ,baoCunBean.ID,baoCunBean.NGBM,baoCunBean.RW];

    return [self.http getHttpPinJie:pinJie Util:util_String];
}

/**************** 时间的选择  ***************/ #pragma  mark -- 时间的选择

/**
 *  时间button
 *
 *  @param sender <#sender description#>
 */
- (IBAction)timeButton:(id)sender {

    //得到屏幕的大小
    CGRect b = [UIScreen mainScreen].bounds;

    if(aa == 0){

        //定义DatePicker 位置,大小,背景色,格式,显示语言
        selectDate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height, 0, 0)];
        selectDate.backgroundColor=[UIColor groupTableViewBackgroundColor];
        selectDate.datePickerMode=UIDatePickerModeDate;
        selectDate.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];

        //定义UIToolbar位置大小背景色
        toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height, b.size.width, 30)];
        toolBar.backgroundColor=[UIColor groupTableViewBackgroundColor];

        //定义toolbar里按钮
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target: self action: @selector(done)];

        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(docancel)];

        UIBarButtonItem *leftButton2  = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target: self action: @selector(doclear)];

        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,leftButton2,fixedButton, rightButton, nil];

        [toolBar setItems: array];

        //添加按钮
        [self.view addSubview:toolBar];
        [self.view addSubview:selectDate];

        //设置动画
        [UIView animateWithDuration:0.4 animations:^{

            CGRect rectSelectDate=selectDate.frame;
            rectSelectDate.origin.y=self.view.frame.size.height-selectDate.frame.size.height;
            selectDate.frame=rectSelectDate;

            CGRect rectToolBar=toolBar.frame;
            rectToolBar.origin.y=self.view.frame.size.height-selectDate.frame.size.height-30;
            toolBar.frame=rectToolBar;
        }];

        //防止多次点击
        aa = 1;
    }
}

//确定选取显示方法
-(void)done{

    NSDate *date=selectDate.date;
    NSDateFormatter *a=[[NSDateFormatter alloc]init];
    a.dateFormat=@"yyyy-MM-dd";
    NSString *b=[a stringFromDate:date];
    self.time_Text.text=b;
    [UIView animateWithDuration:0.2 animations:^{

        CGRect rectSelectDate=selectDate.frame;
        rectSelectDate.origin.y=self.view.frame.size.height;
        selectDate.frame=rectSelectDate;

        CGRect rectToolBar=toolBar.frame;
        rectToolBar.origin.y=self.view.frame.size.height;
        toolBar.frame=rectToolBar;
    }];

    aa = 0;
}

//取消选取方法
-(void)docancel{

    [UIView animateWithDuration:0.2 animations:^{

        CGRect rectSelectDate=selectDate.frame;
        rectSelectDate.origin.y=self.view.frame.size.height;
        selectDate.frame=rectSelectDate;

        CGRect rectToolBar=toolBar.frame;
        rectToolBar.origin.y=self.view.frame.size.height;
        toolBar.frame=rectToolBar;
    }];

    aa = 0;
}

//清空信息方法
-(void)doclear
{
    self.time_Text.text=@"";
}

/********************* RenWuZhuanXie_ViewControllerDelegate 代理**************/
#pragma  mark -- RenWuZhuanXie_ViewControllerDelegate 代理

/**
  传值
 */
- (void) addDataDic:(NSDictionary *)dic{

    self.dic = dic;
}

/**
  判断过来的类型，撰写 == 4， 检索 == 5
 */
- (void) addType:(int)type{

    self.type = type;
}

/********************* RenWuZhuanXie_SelectMen_TableViewControllerDelegate 代理**************/
#pragma  mark -- RenWuZhuanXie_SelectMen_TableViewControllerDelegate 代理

- (void) addNameDic:(NSDictionary *)dic{

    self.dic_selectMen = dic;
    self.renWuJIeShouZhe_Text.text = dic[@"name"];
}

/**
 string 截取 nr 前面的几位 不包括nr位
 */
- (NSString *) string_JieQuString:(NSString *)string NumBer:(int)nr{

    if (string.length < nr) {
        return string;
    }else{
        return  [string substringToIndex:nr];
    }
}
@end
