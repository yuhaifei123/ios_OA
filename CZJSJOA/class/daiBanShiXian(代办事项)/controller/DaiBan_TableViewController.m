//
//  DaiBan_TableViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/20.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "DaiBan_TableViewController.h"
#import "DaiBan_TableViewCell.h"
@interface DaiBan_TableViewController ()

@end

@implementation DaiBan_TableViewController

 static NSString *ID = @"daiban";

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置title的字体大小
    CGRect rect = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = @"常州市城乡建设局综合信息平台（移动端）";
    label.font =  [UIFont fontWithName:@"Arial" size:14];

    self.navigationItem.titleView = label;
    
}
/**
 设置标题(高度)
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

/**
 *设置标题头的名称
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int a = (int)section;
    
    NSString *name = @"";
    
    switch (a) {
            
        case 0:
            name = @"通知公告";
            break;
            
        case 1:
            name = @"材料互递";
            break;
            
        case 2:
            name = @"任务交办";
            break;
            
        case 3:
            name = @"收文管理";
            break;
            
        case 4:
            name = @"发文管理";
            break;
            
        default:
            name = @"其他";
            break;
    }
    
    return  name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (section == 4) ? 1 : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DaiBan_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    int a = (int)indexPath.section;
    int b = (int)indexPath.row;
    switch (a) {
            
        case 0:
            if(b == 0){
                
                cell.daiBan_Text.text = @"你有1条未阅通知";
                cell.daiBan_Title.text = @"未阅通知";
            }else{
                
                cell.daiBan_Text.text = @"你有1条已阅通知";
                cell.daiBan_Title.text = @"已阅通知";
            }
            
            break;
            
        case 1:
            if(b == 0){
                
                cell.daiBan_Text.text = @"你有1条未读材料";
                cell.daiBan_Title.text = @"未读材料";
            }else{
                
                cell.daiBan_Text.text = @"你有1条已读材料";
                cell.daiBan_Title.text = @"已读材料";
            }
            
            break;
            
        case 2:
            if(b == 0){
                
                cell.daiBan_Text.text = @"你有1条任务拟写";
                cell.daiBan_Title.text = @"任务拟写";
            }else{
                
                cell.daiBan_Text.text = @"你有1条任务检索";
                cell.daiBan_Title.text = @"任务检索";
            }
            
            break;
            
        case 3:
            if(b == 0){
                
                cell.daiBan_Text.text = @"你有1条收文待阅";
                cell.daiBan_Title.text = @"收文待阅";
            }else{
                
                cell.daiBan_Text.text = @"你有1条收文办理";
                cell.daiBan_Title.text = @"收文办理";
            }
            
            break;
            
        case 4:
            cell.daiBan_Text.text = @"你有1条发文办理";
            cell.daiBan_Title.text = @"发文办理";
            
            break;
            
        default:
            break;
    }
    return cell;
}




@end
