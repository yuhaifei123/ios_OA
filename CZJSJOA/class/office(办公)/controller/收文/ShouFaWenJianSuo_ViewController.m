//
//  ShouFaWenJianSuo_ViewController.m
//  CZJSJOA
//
//  Created by 虞海飞 on 15/10/27.
//  Copyright © 2015年 薛伟俊. All rights reserved.
//

#import "ShouFaWenJianSuo_ViewController.h"

@interface ShouFaWenJianSuo_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *biaoTi_TextView;//标题
@property (weak, nonatomic) IBOutlet UITextField *wenHao_TextView;//文号
@property (weak, nonatomic) IBOutlet UIButton *souSuo_Button;//搜索_Button

@end

@implementation ShouFaWenJianSuo_ViewController
@synthesize biaoTi;
@synthesize wenHao;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)souSuo_Button_Click:(id)sender {
    biaoTi = _biaoTi_TextView.text;
    wenHao = _wenHao_TextView.text;
    _biaoTi_TextView.text=@"";
    _wenHao_TextView.text=@"";
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideAFPopup" object:nil];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
