//
//  QiJia_TableViewCell.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiJia_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mingZi_Text;//名字
@property (weak, nonatomic) IBOutlet UILabel *banGongShi_Text;//办公室
@property (weak, nonatomic) IBOutlet UILabel *renShu_Text;//人数
@property (weak, nonatomic) IBOutlet UILabel *LinDao_Text;//领导
@property (weak, nonatomic) IBOutlet UILabel *piCi_Text;//批次


@end
