//
//  YiZhouDaiBan_TableViewCell.h
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/26.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiZhouDaiBan_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *biaoTi_Text;//标题
@property (weak, nonatomic) IBOutlet UIWebView *xiaZai_Web;//下载
@property (weak, nonatomic) IBOutlet UILabel *mingzi_Text;//名字
@property (weak, nonatomic) IBOutlet UILabel *shiJian_Text;//时间
@property (weak, nonatomic) IBOutlet UIButton *xiaZai_Button;

@property (nonatomic,strong) NSString *xiaZaiDiZhi;
@end
