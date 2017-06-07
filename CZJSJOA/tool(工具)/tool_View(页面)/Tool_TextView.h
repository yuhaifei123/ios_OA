//
//  Tool_TextView.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/12.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tool_TextView : UITextView<UITextViewDelegate>
/**
 textView设置边框
 (UITextView *)txetView 对象， Text:(NSString *)text 需要显示的文字
 */
- (void) textView_BianKuanTextView:(UITextView *)txetView Text:(NSString *)text;

@end
