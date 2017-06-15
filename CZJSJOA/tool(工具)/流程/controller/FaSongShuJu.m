//
//  FaSongShuJu.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/15.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "FaSongShuJu.h"
#import "LiuChenBean.h"
#import "MBProgressHUD+Add.h"
#import "NotesXMLParser.h"
#import "NotesTBXMLParser.h"

@interface FaSongShuJu ()<NSXMLParserDelegate>

@property (nonatomic,copy) NSString *tablename;
@property (nonatomic,copy) NSString *lcname;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *issh;
@property (nonatomic,copy) NSString *bz;
@property (nonatomic,copy) NSString *idlist;
@property (nonatomic,copy) NSString *kslist;
@property (nonatomic,copy) NSString *ldlist;
@property (nonatomic,copy) NSString *spyj;
@property (nonatomic,copy) NSString *spyjColumn;
@property (nonatomic,copy) NSString *names;
@property (nonatomic,copy) NSString *updateColumns;
@property (nonatomic,copy) NSString *swlx;
@property (nonatomic,copy) NSString *isdx;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *teshu;

@property (nonatomic,copy) NSString *abc;
@property (nonatomic,strong) NSDictionary *dic;

//缓存数据
@property (nonatomic,copy)  NSString *userid ;
@property (nonatomic,copy)  NSString *username;

@end

@implementation FaSongShuJu

/******************** 基本方法 *****************/

/**
*  数据赋值
*/
-(void) addData_LiuChenBean:(LiuChenBean *)liuChenBean{

    _tablename = [self String_PanDuanFeiKongString:liuChenBean.tablename];
    _lcname = [self String_PanDuanFeiKongString:liuChenBean.lcname];
    _id = [self String_PanDuanFeiKongString:liuChenBean.id];
    _issh = [self String_PanDuanFeiKongString:liuChenBean.issh];
    _bz = [self String_PanDuanFeiKongString:liuChenBean.bz];
    _idlist = [self String_PanDuanFeiKongString:liuChenBean.idlist];
    _kslist =[self String_PanDuanFeiKongString:liuChenBean.kslist];
    _ldlist = [self String_PanDuanFeiKongString:liuChenBean.ldlist];
    _spyj = [self String_PanDuanFeiKongString:liuChenBean.spyj];
    _spyjColumn = [self String_PanDuanFeiKongString:liuChenBean.spyjColumn];
    _spyj = [[[_spyj stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r" ] stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    _names = [self String_PanDuanFeiKongString:liuChenBean.names];
    _updateColumns = liuChenBean.updateColumns;
    _swlx = liuChenBean.swlx;
    _isdx = liuChenBean.isdx;
    _state = liuChenBean.state;
    _teshu = liuChenBean.teshu;

    if([self.tablename isEqualToString:@"OA_FIP_GW_SW"]){

        self.spyjColumn = @"";
    }

    //{columnName:'ISSH',value:'%@'} 第一次是issh属性，现在是swlx。issh默认是@“1”
    if (self.swlx == nil) {

        self.swlx = @"1";
    }

    //如果== nil 防止以前收文功能出现问题
   (_isdx == nil || [_isdx isEqualToString:@""]) ? (self.isdx = @"isdx:'',") : (self.isdx = [NSString stringWithFormat:@"isdx:'%@',",self.isdx]);

    // state 判断，
    (_state == nil || [_state isEqualToString:@""]) ? (self.state = @"state:'',") : (self.state = [NSString stringWithFormat:@"state:'%@',",self.state]);

    //特殊流程的判断
    if (_teshu == nil || [_teshu isEqualToString:@""] ) {

        _teshu = @"";
    }

    //拿内存里面的数据
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    _userid = [accountDefaults stringForKey:@"userid"];
    _username = [accountDefaults stringForKey:@"username"];
}

/**
 拼接请求内容
 */
-(NSString *) pinJieLiuChen:(LiuChenBean *)liuChenBean{

    [self addData_LiuChenBean:liuChenBean];

    NSString *pinJie_02 = [NSString stringWithFormat:@"{shopt:'signal',tablename:'%@',YWLX:2,buskey:[{%@%@ISXS:'1',lcid:'%@.%@',pid:'%@.%@',id:'%@',ISSH:'%@',ISSHF:'',bz:'%@',flowType:'go', clbz:'%@', ywid:'%@',spyj:'%@',closetype:3,functionid:'', workflowname:'%@',userid:'%@',username:'%@',wintype:2,isback:'', tablename:'%@', idlist:'%@', kslist:'%@', ldlist:'%@',names:'%@',updateColumns:[{columnName:'spyj',value:'%@'},{columnName:'ISSH',value:'%@'},{columnName:'%@',value:'%@'}%@],spyjColumn:'%@'}]}",self.tablename,self.isdx,self.state,self.lcname,self.id,self.lcname,self.id,self.id,self.issh,self.bz,self.bz,self.id,self.spyj,self.lcname,self.userid,self.username,self.tablename,self.idlist,self.kslist,self.ldlist,self.names,self.spyj,self.issh,self.spyjColumn,self.spyj,self.teshu,self.spyjColumn];

   // NSLog(@"%@",pinJie_02);
    return pinJie_02;   
}

/**
    拼接请求内容(保密审查)
 */
-(NSString *) pinJie_BaoMi_LiuChen:(LiuChenBean *)liuChenBean{

    [self addData_LiuChenBean:liuChenBean];

    NSString *pinJie_02 = [NSString stringWithFormat:@"{shopt:'signal',tablename:'%@',YWLX:2,buskey:[{ISXS:'1',lcid:'%@.%@',pid:'%@.%@',id:'%@',ISSH:'%@',bz:'%@',flowType:'go', clbz:'%@', ywid:'%@',spyj:'%@',closetype:3,functionid:'', workflowname:'%@',userid:'%@',username:'%@',wintype:2,isback:'', tablename:'%@', idlist:'%@', kslist:'%@', ldlist:'%@',names:'%@',updateColumns:[{columnName:'spyj',value:'%@'},{columnName:'%@',value:'%@'}],spyjColumn:'%@'}]}",self.tablename,self.lcname,self.id,self.lcname,self.id,self.id,self.issh,self.bz,self.bz,self.id,self.spyj,self.lcname,self.userid,self.username,self.tablename,self.idlist,self.kslist,self.ldlist,self.names,self.spyj,self.spyjColumn,self.spyj,self.spyjColumn];

    return pinJie_02;
}

/**
    拼接请求内容_选择人
 */
-(NSString *) pinJie_Ren_LiuChen:(LiuChenBean *)liuChenBean Dic_Ren:(NSDictionary *)dic_Ren{

    _tablename = [self String_PanDuanFeiKongString:liuChenBean.tablename];
    _lcname = [self String_PanDuanFeiKongString:liuChenBean.lcname];
    _id = [self String_PanDuanFeiKongString:liuChenBean.id];
    _issh = [self String_PanDuanFeiKongString:liuChenBean.issh];
    _bz = [self String_PanDuanFeiKongString:liuChenBean.bz];
    _idlist = dic_Ren[@"idlist"];
    _kslist =[self String_PanDuanFeiKongString:liuChenBean.kslist];
    _ldlist = [self String_PanDuanFeiKongString:liuChenBean.ldlist];
    _spyj = [self String_PanDuanFeiKongString:liuChenBean.spyj];
    _spyj = [[[_spyj stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r" ] stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    
    _spyjColumn = [self String_PanDuanFeiKongString:liuChenBean.spyjColumn];
    _updateColumns = liuChenBean.updateColumns;
    _swlx = liuChenBean.swlx;
    NSString * names = dic_Ren[@"names"];
    NSString *ends = dic_Ren[@"ends"];
    NSString *isfz = dic_Ren[@"isfz"];
    NSString *ZTBS = dic_Ren[@"ZTBS"];
    NSString *morenode = dic_Ren[@"array_person"];
    NSString *taskname = dic_Ren[@"taskname"];
    NSString *shopt = @"";

    if([morenode isEqualToString:@"1"]){
        shopt = @"signaltask";//signaltask
    }else{
        shopt = @"signal";
    }

    //拿内存里面的数据
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [accountDefaults stringForKey:@"userid"];
    NSString *username = [accountDefaults stringForKey:@"username"];

    if([self.tablename isEqualToString:@"OA_FIP_GW_SW"]){
        
        self.spyjColumn = @"";
    }

  NSString *pinJie_02 = [NSString stringWithFormat:@"{transcode:'OAWF01',shopt:'%@',taskname:'%@',tablename:'%@',YWLX:2,buskey:[{ends:'%@',isfz:'%@',morenode:'%@',lcid:'%@.%@',pid:'%@.%@',id:'%@',ztbs:'%@',taskname:'%@',ISSH:1,bz:'%@',ISSHF:'',flowType:'go', clbz:'%@', ywid:'%@',spyj:'%@',closetype:3,functionid:'', workflowname:'%@',userid:'%@',username:'%@',wintype:2,isback:'', tablename:'%@', idlist:'%@', kslist:'', ldlist:'',names:'%@',updateColumns:[{columnName:'spyj',value:'%@'},{columnName:'ISSH',value:''},{columnName:'',value:'%@'}],spyjColumn:'%@'}]}",shopt,taskname,self.tablename,ends,isfz,morenode,self.lcname,self.id,self.lcname,self.id,self.id,ZTBS,taskname,self.bz,self.bz,self.id,self.spyj,self.lcname,userid,username,self.tablename,self.idlist,names,self.spyj,self.spyj,self.spyjColumn];

//    NSString *pinJie_02 = [NSString stringWithFormat:@"{transcode:'OAWF01',shopt:'%@',taskname:'%@',tablename:'%@',YWLX:2,buskey:[{ends:'%@',isfz:'%@',morenode:'%@',lcid:'%@.%@',pid:'%@.%@',id:'%@',ztbs:'%@',taskname:'%@',ISSH:1,bz:'%@',flowType:'go', clbz:'%@', ywid:'%@',spyj:'%@',closetype:3,functionid:'', workflowname:'%@',userid:'%@',username:'%@',wintype:2,isback:'', tablename:'%@', idlist:'%@', kslist:'', ldlist:'',names:'%@',spyjColumn:[{columnName:'spyj',value:'%@'},{columnName:'ISSH',value:'%@'},{columnName:'%@',value:'%@'}],spyjColumn:'%@'}]}",shopt,taskname,self.tablename,ends,isfz,morenode,self.lcname,self.id,self.lcname,self.id,self.id,ZTBS,taskname,self.bz,self.bz,self.id,self.spyj,self.lcname,userid,username,self.tablename,self.idlist,names,self.spyj,self.swlx,self.spyjColumn,self.spyj,self.spyjColumn];

    return pinJie_02;
}

#pragma  mark -- 第二次添加
/**
 拼接请求内容(二次请求)
 */
-(NSString *) pinJie_ErCiQingQiu_LiuChen:(LiuChenBean *)liuChenBean Function:(NSString *)function{
    
    _tablename = [self String_PanDuanFeiKongString:liuChenBean.tablename];
    _lcname = [self String_PanDuanFeiKongString:liuChenBean.lcname];
    _id = [self String_PanDuanFeiKongString:liuChenBean.id];
    _issh = [self String_PanDuanFeiKongString:liuChenBean.issh];
    _bz = [self String_PanDuanFeiKongString:liuChenBean.bz];
    _idlist = [self String_PanDuanFeiKongString:liuChenBean.idlist];
    _kslist =[self String_PanDuanFeiKongString:liuChenBean.kslist];
    _ldlist = [self String_PanDuanFeiKongString:liuChenBean.ldlist];
    _spyj = [self String_PanDuanFeiKongString:liuChenBean.spyj];
    _spyjColumn = [self String_PanDuanFeiKongString:liuChenBean.spyjColumn];
    _spyj = [[[_spyj stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r" ] stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    _names = [self String_PanDuanFeiKongString:liuChenBean.names];
    _updateColumns = liuChenBean.updateColumns;
    _swlx = liuChenBean.swlx;
    //拿内存里面的数据
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [accountDefaults stringForKey:@"userid"];
    NSString *username = [accountDefaults stringForKey:@"username"];
    
    if([self.tablename isEqualToString:@"OA_FIP_GW_SW"]){
        
        self.spyjColumn = @"";
    }
    
    NSString *pinJie_02 = [NSString stringWithFormat:@"{listoutxml:'%@',shopt:'signal',tablename:'%@',YWLX:2,buskey:[{ISXS:'1',lcid:'%@.%@',pid:'%@.%@',id:'%@',ISSH:'%@',bz:'%@',flowType:'go', clbz:'%@', ywid:'%@',spyj:'%@',closetype:3,functionid:'', workflowname:'%@',userid:'%@',username:'%@',wintype:2,isback:'', tablename:'%@', idlist:'%@', kslist:'%@', ldlist:'%@',names:'%@',updateColumns:[{columnName:'spyj',value:'%@'},{columnName:'ISSH',value:'%@'},{columnName:%@,value:'%@'}],spyjColumn:'%@'}]}",function,self.tablename,self.lcname,self.id,self.lcname,self.id,self.id,self.issh,self.bz,self.bz,self.id,self.spyj,self.lcname,userid,username,self.tablename,self.idlist,self.kslist,self.ldlist,self.names,self.spyj,self.swlx,self.spyjColumn,self.spyj,self.spyjColumn];
    //self.names,self.swlx,self.issh,self.spyjColumn
    return pinJie_02;
}

/**
 *   访问http
 *  [NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&type=%@&TITLE=%@",
 *    tongzhi.gsUSERID,tongzhi.PageIndex,tongzhi.state,tongzhi.TITLE]
 *｀
 *  @param pinJie <#pinJie description#>
 *  @param util   <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getHttpPinJie:(NSString *)pinJie Util:(NSString *)util{

    //添加一个遮罩，禁止用户操作
    [MBProgressHUD showMessage:@"正在努力加载中...."];

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    NSString *tongZhi = util;
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把cookie加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param = pinJie;

    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    //当请求结束的时候调用（有两种结果，一个是成功拿到数据，也可能没有拿到数据，请求失败）
    [MBProgressHUD hideHUD];

   // NSDictionary *dict = nil;
    if (data) {

        //请求成功
        //dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
       NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];

        [self jieXiXmlNsData:data];
        [self.delegate addDic_FaSongShuJu:_dic];
        return self.dic;
    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }

    [MBProgressHUD hideHUD];
    return self.dic;
}

/**
  解析xml
 */
- (void) jieXiXmlNsData:(NSData *)data{

      //NSString* path = [[NSBundle mainBundle] pathForResource:@"Notes" ofType:@"xml"];

     //NSURL *url = [NSURL fileURLWithPath:path];
    //开始解析XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];

      //NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    // 2) 设置代理
    parser.delegate = self;

    // 3）开始解析
    [parser parse];
}

/******************** 工具方法 *****************/
/**
  string判断是不是null
 */
- (NSString *) String_PanDuanFeiKongString:(NSString *)string{

    if (![string isEqual:[NSNull null]] && string != nil && ![string isEqualToString:@""] && ![string isEqualToString:@"\n"] && ![string isEqualToString:@"\r"] && ![string isEqual:@""] && string.length != 0) {

        return string;
    }
    return @"";
}

/**
  解析json
 */
-(NSDictionary *)jieXiJsonString:(NSString *)json{

    //string转化成data
    NSData* aData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:nil];
}

/******************** 代理方法 *****************/
#pragma mark --代理方法

// 1. 开始解析文档，在这里做初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser{

    //NSLog(@"开始解析文档");
}

// 2.3.4会循环执行，一直到XML文档解析完毕
// 2. 解析一个节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
  //  NSLog(@"节点开始 %@ %@", elementName, attributeDict);

    self.abc = elementName;

    if ([self.abc isEqualToString:@"outxml"]) {

  
    }
}

// 3. 查找节点内容，可能会多次
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.abc isEqualToString:@"data"]){

       _dic =[self jieXiJsonString:string];

        [self.delegate addDic_FaSongShuJu:self.dic];
    }
}

// 4. 节点完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    //NSLog(@"节点完成");
}

// 5. 解析完成，做收尾工作
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
   // NSLog(@"解析完成");
}

// 6. 解析出错，清理中间数据
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  //  NSLog(@"%@", parseError.localizedDescription);
}
@end
