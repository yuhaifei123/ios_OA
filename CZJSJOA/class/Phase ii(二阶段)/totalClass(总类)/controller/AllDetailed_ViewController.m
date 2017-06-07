//
//  AllDetailed_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/5.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//
#pragma  mark -- 所有详细界面的父类
#import "AllDetailed_ViewController.h"

@interface AllDetailed_ViewController ()

@property (nonatomic,copy) NSString *string_TextViewText;

@end

@implementation AllDetailed_ViewController

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

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self add_ViewZiLei];
    [self add_View];
    [self add_View_Array:self.array_AllXiangQing];
}

#pragma  mark -- view赋值，子类的一些独有的方法
/**
 * view赋值，子类的一些独有的方法
 */
-(void) add_ViewZiLei{

}
#pragma  mark -- view属性设置
/**
 * view属性设置
 */
-(void) add_View{

    self.automaticallyAdjustsScrollViewInsets = NO;
}

/**
 *  根据messageControl，判断来给每个textView赋值
 *
 *  @param BzDic 字典[ZYLDYJ:主要领导意见]
 *
 *  @return [spyi,spyjColumn];
 */
-(NSMutableArray *) add_judgeAddTextView_BZDic:(NSDictionary *)BzDic{

    NSString *string_spyi = @"";
    NSString *string_spyjColumn = @"";
    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];

    NSArray *array_messageControl = self.dic_ALLXiangQing[@"messageControl"];
    self.dic_AllLianXi = BzDic;
    if (array_messageControl.count < 1) {

        string_spyi = @"请下一步办理";
    }
    else{

        self.dic_AllLianXi = BzDic;

        NSDictionary *dic_messageControl = array_messageControl[0];
        NSString *string_CONTROL = dic_messageControl[@"CONTROL"];

        if(![string_CONTROL isEqualToString:@""]){

            //字典[ZYLDYJ:主要领导意见]-》拿到所有的key，和传过来的key比较，相等就把相对应的key的textView赋值
            NSArray *array_key = [BzDic allKeys];
            for (NSString *string_key in array_key) {

                //key判断
                if ([string_key isEqualToString:string_CONTROL]) {

                    NSString  *string_Name = [as stringForKey:@"username"];//名字
                    NSString *string_Time = [ChangYong_NSObject DanQianTime];//当前时间
                    string_spyi = [NSString stringWithFormat:@"%@ %@",string_Name,string_Time];

                    UITextView *textView = BzDic[string_key];

                    //判断tetView里面有没有数据
                    if ([textView.text isEqualToString:@""]) {

                        textView.text = string_spyi;
                    }
                    else{

                        textView.text = [NSString stringWithFormat:@"%@\r%@",string_spyi,textView.text];
                    }

                    string_spyi = textView.text;
                    string_spyjColumn = string_CONTROL;
                }
            }
        }
    }

    return [NSMutableArray arrayWithObjects:string_spyi,string_spyjColumn, nil];
}

#pragma  mark -- 请求网络数据流程返回_dic 节点
/**
 *请求网络数据
 *
 *  @param dic 请求网络数据
 */
-(void) add_GetHttp_PinJie:(NSString *(^)())pinJie{

    GetHttp *http = [[GetHttp alloc] init];
    Util *util = [Util new];
    NSString *string_Path = [util phaseTwo_Detailed];

    //拼接需要的参数
    NSString  *string_PinJie = pinJie();

    //返回，dic数据
    self.dic_ALLXiangQing = [http getHttpPinJie_JiaZai:string_PinJie Util:string_Path];

    [self add_DataConversion_Dic:self.dic_ALLXiangQing];
}

#pragma  mark -- 数据转化
/**
 *数据转化
 *
 *  @param dic 网络返回详细数据
 */
-(void) add_DataConversion_Dic:(NSDictionary *)dic{

    if (![dic[@"code"] isEqualToString:@"1"]) {

        [IanAlert alertError:@"没有数据"];
        return;
    }

    self.array_AllXiangQing = dic[@"fromControl"];
}

#pragma  mark -- 返回的数据，赋值给界面
/**
 *
 *  @return 返回的数据，赋值给界面
 */
-(void) add_View_Array:(NSArray *)array{

    NSArray *array_list = self.dic_ALLXiangQing[@"list"];
    NSDictionary *dic_list = array_list[0];

    self.string_SwitchNO = @"";

    if ([dic_list[@"ISDX"] isEqual:[NSNull null]]) {

        [self.switch_isdx setOn:NO];
    }
    else{

        [dic_list[@"ISDX"] isEqualToString:@"0"] ? [self.switch_isdx setOn:NO],self.string_SwitchNO = @"0" : [self.switch_isdx setOn:YES],self.string_SwitchNO = @"1";
    }
    //按钮点击以后触发事件
    [self.switch_isdx addTarget:self action:@selector(onclick_Switch) forControlEvents:UIControlEventValueChanged];

    // NSLog(@"%@",self.dic_ALLXiangQing);
}

-(void) onclick_Switch{

     BOOL isButtonOn = [self.switch_isdx isOn];

    isButtonOn == NO ? (self.string_SwitchNO = @"0") : (self.string_SwitchNO = @"1");
}

#pragma  mark -- 判断按钮
/**
 *  判断按钮
 *
 *  @param sw           按钮
 *  @param string_Judge 数据
 */
-(void) add_JudgeSwitch:(UISwitch *)sw String_Judge:(NSString *)string_Judge{

    if ([string_Judge isEqualToString:@"0"]) {

        [sw setOn:NO];
    }else{
        [sw setOn:YES];
    }
}

#pragma  mark -- AllListDelegate
-(void)AllList_Dic:(NSDictionary *)dic Dic_Table:(NSDictionary *)dic_Table{

    self.dic_AllList = dic;
    self.dic_Table = dic_Table;
}

#pragma  mark -- 流程推送
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
    self.liuChenBean.idlist = @"";
    self.liuChenBean.kslist = @"";
    self.liuChenBean.ldlist = @"";
    self.liuChenBean.names = @"";
    self.liuChenBean.spyjColumn = self.array_spyj[1];
    self.liuChenBean.isdx = self.string_SwitchNO;
    self.liuChenBean.state = [NSString stringWithFormat:@"%@",self.dic_AllList[@"STATE"]];

    [MBProgressHUD showMessage:@""];
    NSString *pinJie = [self.faSongShuJu pinJieLiuChen:self.liuChenBean];
    NSLog(@"%@",pinJie);
    Util *util = [[Util alloc]init];
    NSString *LiuChen_Util = util.tuiLiuChen;

    //拼接，发送数据
    NSString *pinJie_02 = [NSString stringWithFormat:@"inxml=%@&ttforward=%@&keepalive=%@",pinJie,@"common/AndroidSer/biz/AndroidSerWorkFlowService",@"1"];
    //访问服务器/Users/yuhaifei/Desktop/jsjoa/ios_03/ios/CZJSJOA.xcodeproj
    NSDictionary *dic = [self.faSongShuJu getHttpPinJie:pinJie_02 Util:LiuChen_Util];

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

/************* UITextViewDelegate ***************/
#pragma  mark --  UITextViewDelegate

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    //不是未办的就都不能编辑
    if (![self.dic_AllList[@"STATES"] isEqualToString:@"未办"]){

        return NO;
    }
    //得到对应的key
    NSArray *arrray = [self.dic_AllLianXi allKeysForObject:textView];


    if (arrray.count < 1) {

        return NO;
    }
    else{

        int key = 1;
        NSString *string_DicKey = [NSString stringWithFormat:@"%@",arrray[0]];
        NSArray *array_fromControl = self.dic_ALLXiangQing[@"fromControl"];
      //  NSLog(@"%@",array_fromControl);

        //比较是不死有这个key
        for (NSDictionary *dic in array_fromControl) {

            NSString *string_PRONAME = dic[@"PRONAME"];
            if ([string_PRONAME isEqualToString:string_DicKey]) {
                //有就加
                key = key + 1;
            }
        }

        if (key > 1) {

            return NO;
        }
    }
    return YES;
}

//键盘控制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];

        //判断有没有数据
        if([textView.text isEqualToString:@""]){

            //把默认批阅放进去
            NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
            NSString  *string_Name = [as stringForKey:@"username"];//名字
            NSString *string_Time = [ChangYong_NSObject DanQianTime];//当前时间
            NSString *string_spyj = [NSString stringWithFormat:@"%@ %@",string_Name,string_Time];
            textView.text = string_spyj;

            self.array_spyj[0] = string_spyj;
        }else{

            NSString *string_Text = textView.text;
            self.array_spyj[0] = string_Text;
        }

      //  NSLog(@"%@",self.array_spyj);
        return NO;
    }
    return YES;
}

@end
