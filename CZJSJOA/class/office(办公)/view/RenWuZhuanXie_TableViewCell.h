//
//  RenWuZhuanXie_TableViewCell.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/24.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#define DELETE_VIEW_WIDTH 80.0f


@protocol RenWuZhuanXie_TableViewCellDelegate <NSObject>
/**
 *  代理-删除方法
 *
 *  @param cell 当前cell
 */
- (void)deleteAction:(UITableViewCell*)cell;

@end

@interface RenWuZhuanXie_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name_Text;//名字
@property (weak, nonatomic) IBOutlet UILabel *time_Text;//时间
@property (weak, nonatomic) IBOutlet UILabel *state_Text;//状态
@property (weak, nonatomic) IBOutlet UILabel *content_Text;//内容

/**
 *  是否开启delete
 *
 *  @param enableDelete 是否开启
 */
- (void)enableDeleteMethod:(BOOL)enableDelete;

/**
 *  归位
 *
 *  @param animation 是否动画
 */
- (void)placeDeleteViewWithAnimation:(BOOL)animation;

/**
 *  获取删除imageview
 *
 *  @return 删除imageview
 */
- (UIImageView*)getDeleteImageView;

/**
 *  代理对象
 */
@property (nonatomic, weak) id <RenWuZhuanXie_TableViewCellDelegate>deleteDelegate;

@property (nonatomic, assign) BOOL isShow;

@end
