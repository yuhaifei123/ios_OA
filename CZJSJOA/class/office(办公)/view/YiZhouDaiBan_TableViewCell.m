//
//  YiZhouDaiBan_TableViewCell.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/26.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "YiZhouDaiBan_TableViewCell.h"

@interface YiZhouDaiBan_TableViewCell ()<UIWebViewDelegate>

@property (nonatomic,copy) NSString *liuJin;;//路径，拼接好的

//web属性
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSString *filename;

@end

@implementation YiZhouDaiBan_TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
  拼接下载路径
 */
- (NSString *) pinJie_XiaZaiLiuJin:(NSString *)liuJin{

    if (![liuJin isEqualToString:@""]) {
        Util *url =[[Util alloc]init];

        return [NSString stringWithFormat:@"%@app/tt_downloadfile.do?filename=%@&downname=%@.doc&path=&uploadtype=doc",[url yuanShi],liuJin,liuJin];
    }

    return @"";
}

@end
