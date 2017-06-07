//
//  BaoCunBean.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "BaoCunBean.h"

@implementation BaoCunBean

+(instancetype) init_BaoCunBeanDic:(NSMutableDictionary *)dic{

    return [[self alloc] init_BaoCunBeanDic:dic];
}

- (instancetype) init_BaoCunBeanDic:(NSMutableDictionary *)dic{

    self = [super init];

    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }

    return self;
}
@end
