//
//  BaoMi_TableViewCell.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/8.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "BaoMi_TableViewCell.h"
#import "ChangYong_NSObject.h"

@interface BaoMi_TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *Label_Title;//标题
@property (weak, nonatomic) IBOutlet UILabel *Label_BatchNumber;//批号
@property (weak, nonatomic) IBOutlet UILabel *Label_Data;//时间

@end

@implementation BaoMi_TableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma  mark -- 赋值
-(void)setDic_BaoMiTableCell:(NSDictionary *)dic_BaoMiTableCell{

    _dic_BaoMiTableCell = dic_BaoMiTableCell;
    [self add_View];
}

#pragma  mark -- 数据赋值
-(void) add_View{

    self.Label_Title.text = self.dic_BaoMiTableCell[@"TITLE"];

    NSString *string_NGR = [NSString stringWithFormat:@"%@",self.dic_BaoMiTableCell[@"NGR"]];
    self.Label_BatchNumber.text =  [ChangYong_NSObject judgeNullString:string_NGR];

    NSString *string_NRTIME = [NSString stringWithFormat:@"%@",self.dic_BaoMiTableCell[@"NRTIME"]];
    self.Label_Data.text =  [ChangYong_NSObject judgeNullString:string_NRTIME];
}
@end
