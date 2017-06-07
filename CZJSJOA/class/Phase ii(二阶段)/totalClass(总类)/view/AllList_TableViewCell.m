//
//  AllList_TableViewCell.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/5/4.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "AllList_TableViewCell.h"

@interface AllList_TableViewCell ()

@end

@implementation AllList_TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic_TableCell:(NSDictionary *)dic_TableCell{

    _dic_TableCell = dic_TableCell;

    [self add_View];
}


#pragma  mark -- 添加view的属性
/**
 * 添加view的属性
 */
-(void) add_View{

    self.label_Title.text = [NSString stringWithFormat:@"%@",self.dic_TableCell[@"TASKNAME"]];
    NSString *string_Time = [ChangYong_NSObject InterceptionString:self.dic_TableCell[@"NRTIME"] Character:11];//截取字符
    self.label_Name.text = [NSString stringWithFormat:@"%@  %@",self.dic_TableCell[@"NGR"],string_Time];
    self.label_LiuCheng.text = [NSString stringWithFormat:@"%@",self.dic_TableCell[@"LCNAME"]];
    self.label_State.text = [NSString stringWithFormat:@"%@",self.dic_TableCell[@"STATES"]];
}

@end
