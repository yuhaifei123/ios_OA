//
//  LiuChenBean.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/15.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "LiuChenBean.h"

@implementation LiuChenBean

+(instancetype) init_LiuChenBeanDic:(NSMutableDictionary *)dic{

    return [[self alloc] init_LiuChenBeanDic:dic];
}

- (instancetype) init_LiuChenBeanDic:(NSMutableDictionary *)dic{

    self = [super init];

    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }

    return self;
    
}

@end
