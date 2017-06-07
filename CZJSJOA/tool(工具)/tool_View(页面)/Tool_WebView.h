//
//  Tool_WebView.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/14.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

@interface Tool_WebView : UIWebView<UIWebViewDelegate>
/**
    正文的拼接和超链接 string:正文的名字，以及下载的地方
 */
- (void) tool_Content:(NSString *)string;

/**
    附件的拼接和超链接 string:正文的名字，以及下载的地方
 */
- (void) tool_Attachment:(NSString *)string;


/**
 *   webView的数据浏览 (点击webView 以后跳转到下个页面显示)
 *
 *  @param nav     调用者的控制器
 *  @param webView 调用者的webView
 */
-(void) tool_WebViewBrowse:(UINavigationController *)nav;

@end
