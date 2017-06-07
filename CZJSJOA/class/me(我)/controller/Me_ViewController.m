//
//  Me_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/20.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "Me_ViewController.h"
#import "Me_TableViewCell.h"

@interface Me_ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *me_Text;//显示人的名字

@end

@implementation Me_ViewController

static NSString *ID = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置title的字体大小
    CGRect rect = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = @"常州市城乡建设局综合信息平台（移动端）";
    label.font =  [UIFont fontWithName:@"Arial" size:14];
    
    self.navigationItem.titleView = label;

    NSUserDefaults *as = [NSUserDefaults standardUserDefaults];
    self.me_Text.text = [as stringForKey:@"username"];
}

- (IBAction)qieHuanYongHu_Button_Click:(id)sender {

    //跳转到主界面
    UIViewController *deer = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    //跳转效果
    [deer setModalPresentationStyle:UIModalTransitionStyleFlipHorizontal];

    [self presentViewController:deer animated:YES completion:nil];
}


- (IBAction)qingChuHuanCun_Button_Click:(UIButton *)sender {

    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];

    [IanAlert alertSuccess:@"缓存清除完毕" length:2.0];
}

- (IBAction)guanYu_Button_Click:(id)sender {

    [self performSegueWithIdentifier:@"guanyu" sender:nil];
    
}


@end
