//
//  Tool_TextView.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/12.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "Tool_TextView.h"
#import "AllDetailed_ViewController.h"

@interface Tool_TextView ()

@end

@implementation Tool_TextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self textView_BianKuanTextView:self Text:@""];
    }
    return self;
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
    txetView.text = text;
}


@end
