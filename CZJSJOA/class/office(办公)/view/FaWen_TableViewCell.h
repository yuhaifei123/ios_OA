//
//  FaWen_TableViewCell.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/10/8.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaWen_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *biaoTi_Text;//标题
@property (weak, nonatomic) IBOutlet UILabel *shenHe_Text;//审核
@property (weak, nonatomic) IBOutlet UILabel *shiJian_Text;//时间
@property (weak, nonatomic) IBOutlet UILabel *hao_Text;//号
@property (weak, nonatomic) IBOutlet UILabel *diZhi_Text;//地址



@end
