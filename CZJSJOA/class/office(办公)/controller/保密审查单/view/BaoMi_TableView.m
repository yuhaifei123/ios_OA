//
//  BaoMi_TableView.m
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import "BaoMi_TableView.h"
#import "BaoMi_TableViewCell.h"

@interface BaoMi_TableView ()

@property (nonatomic,strong) NSArray *array_CellData;

@end

@implementation BaoMi_TableView

-(NSArray *) array_CellData{

    if (_array_CellData == nil) {

        _array_CellData = [NSArray array];
    }
    return _array_CellData;
}
//cell的id
static NSString *ID = @"BAOMI";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

        self.tableFooterView = [UIView new];
    }
    return self;
}

-(void)setDic_BaoMiTableViewData:(NSDictionary *)dic_BaoMiTableViewData{

    _dic_BaoMiTableViewData = dic_BaoMiTableViewData;

    if (_dic_BaoMiTableViewData) {

        [self add_ParsingDataDic:self.dic_BaoMiTableViewData];
    }
}

/**
 * 解析数据，获得cell数据
 *  @param dic <#dic description#>
 */
-(void) add_ParsingDataDic:(NSDictionary *)dic{

    int int_Code = [dic[@"code"] intValue];
    if (int_Code == 0) {

        self.array_CellData = dic[@"list"];
    }
}

#pragma  mark -- uitableView代理
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

//cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

     return self.array_CellData.count;
}

//cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BaoMi_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.dic_BaoMiTableCell = self.array_CellData[indexPath.row];

    return cell;
}

//点击以后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //回调代理,点击以后把数据给控制器
    if ([self.baoMiDelegate respondsToSelector:@selector(BaoMiTableView_ClockCell:)] ) {

        NSDictionary *dic = self.array_CellData[indexPath.row];
        int int_ID = [dic[@"ID"] intValue];
        [self.baoMiDelegate BaoMiTableView_ClockCell:int_ID];
    }
}


@end
