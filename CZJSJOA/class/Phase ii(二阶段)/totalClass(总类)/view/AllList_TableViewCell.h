//
//  AllList_TableViewCell.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/4.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllList_TableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dic_TableCell;

@property (weak, nonatomic) IBOutlet UILabel *label_Title;//标题
@property (weak, nonatomic) IBOutlet UILabel *label_LiuCheng;//流程表示
@property (weak, nonatomic) IBOutlet UILabel *label_Name;//名字
@property (weak, nonatomic) IBOutlet UILabel *label_State;//状态

@end
