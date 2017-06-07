//
//  FaSongShuJu.h
//  CZJSJ
//
//  Created by 虞海飞1 on 15/10/15.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LiuChenBean;

@protocol FaSongShuJuDelegate <NSObject>



@optional

-(void) addDic_FaSongShuJu:(NSDictionary *)dic;

@end

@interface FaSongShuJu : NSObject

@property (nonatomic,assign) id<FaSongShuJuDelegate> delegate;


/**
  拼接请求内容
 */
-(NSString *) pinJieLiuChen:(LiuChenBean *)liuChenBean;

/**
 拼接请求内容(保密审查)
 */
-(NSString *) pinJie_BaoMi_LiuChen:(LiuChenBean *)liuChenBea;

/**
  网络请求方法
 */
-(NSDictionary *) getHttpPinJie:(NSString *)pinJie Util:(NSString *)util;

/**
 string判断是不是null
 */
- (NSString *) String_PanDuanFeiKongString:(NSString *)string;

/**
 拼接请求内容(二次请求)
 */
-(NSString *) pinJie_ErCiQingQiu_LiuChen:(LiuChenBean *)liuChenBean Function:(NSString *)function;

/**
 保存数据列表
 */
@property (nonatomic,strong) NSMutableArray* objects;

/**
 解析xml
 */
- (void) jieXiXmlNsData:(NSData *)data;

/**
 拼接请求内容_选择人
 */
-(NSString *) pinJie_Ren_LiuChen:(LiuChenBean *)liuChenBean Dic_Ren:(NSDictionary *)dic_Ren;

@end
