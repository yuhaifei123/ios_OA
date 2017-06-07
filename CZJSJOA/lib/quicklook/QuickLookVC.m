//
//  QuickLookVC.m
//  QuickLookDemo
//
//  Created by yangjw  on 13-8-14.
//  Copyright (c) 2013年 yangjw . All rights reserved.
//

#import "QuickLookVC.h"

#import <QuickLook/QuickLook.h>

@interface QuickLookVC ()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

- (IBAction)back:(id)sender;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

///快速查看框架
@property (nonatomic,strong) QLPreviewController *previewController;
@end

// 屏幕高度
#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
//判定系统版本
#define version          [[UIDevice currentDevice].systemVersion doubleValue];

@implementation QuickLookVC
@synthesize path = _path;

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.previewController = [[QLPreviewController alloc] init];
    self.previewController.dataSource = self;
    self.previewController.delegate = self;

    //判断设备版本
    double version_Double = version;
    if (version_Double >= 10.0) {

        [self addChildViewController:self.previewController];
    }

    self.previewController.view.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);//CGRectMake(0,0,self.view.bounds.size., ScreenHeight+200);
    [self.view addSubview:self.previewController.view];

    [self.previewController didMoveToParentViewController:self];
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{

	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
	NSURL *fileURL = nil;
	fileURL = [NSURL fileURLWithPath:self.path];
    return fileURL;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return YES;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
	return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
