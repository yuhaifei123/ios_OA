//
//  BaoMiDetailed_ScrollView.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "BaoMiDetailed_ScrollView.h"

@interface BaoMiDetailed_ScrollView ()

@property (nonatomic,strong)  UIButton *bnutton_Submit;

@end

@implementation BaoMiDetailed_ScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

       // [self add_View];
    }
    return self;
}

#pragma  mark -- 添加view的属性
/**
 * 添加view的属性
 */
-(void) add_View{


    //添加提交button
    _bnutton_Submit = [UIButton new];
    [_bnutton_Submit setTitle:@"提交" forState:UIControlStateNormal];
    _bnutton_Submit.backgroundColor = [UIColor greenColor];
    [self addSubview:_bnutton_Submit];
}




@end
