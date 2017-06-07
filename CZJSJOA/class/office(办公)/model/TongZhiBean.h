//
//  tongZhiBean.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TongZhiBean : NSObject

@property (nonatomic,copy) NSString *gsUSERID;
@property (nonatomic,copy) NSString *PageIndex;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *TITLE;

+(instancetype) init_TongZhiBeanDic:(NSMutableDictionary *)dic;

- (instancetype) init_TongZhiBeanDic:(NSMutableDictionary *)dic;
@end
