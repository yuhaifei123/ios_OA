//
//  tongZhiBean.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "TongZhiBean.h"


@implementation TongZhiBean

+(instancetype) init_TongZhiBeanDic:(NSMutableDictionary *)dic{

    return [[self alloc] init_TongZhiBeanDic:dic];
   }

- (instancetype) init_TongZhiBeanDic:(NSMutableDictionary *)dic{

    self = [super init];

    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }

    return self;

}
@end
