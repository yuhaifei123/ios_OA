//
//  shouWenDaiYue_TableViewCell.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shouWenDaiYue_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fuJian_Text;//附件_Text
@property (weak, nonatomic) IBOutlet UILabel *shouWen_Text;//收文_Text
@property (weak, nonatomic) IBOutlet UILabel *hao_Text;//号_Text
@property (weak, nonatomic) IBOutlet UILabel *shiJian_Text;//时间_Text

@end
