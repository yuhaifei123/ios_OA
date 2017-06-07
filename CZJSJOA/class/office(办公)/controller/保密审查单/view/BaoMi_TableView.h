//
//  BaoMi_TableView.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/4/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

@protocol BaoMi_TableViewDelegate <NSObject>

/**
 * cell点击回调
 */
-(void) BaoMiTableView_ClockCell:(int) cell;

@end

@interface BaoMi_TableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id<BaoMi_TableViewDelegate>  baoMiDelegate;
/**
 *  保密table的数据
 */
@property (nonatomic,strong) NSDictionary *dic_BaoMiTableViewData;

@end