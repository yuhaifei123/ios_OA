//
//  DownloadData.h
//  CZJSJOA
//
//  Created by 虞海飞 on 16/10/11.
//  Copyright © 2016年 薛伟俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadDataDelegate <NSObject>

@optional
-(BOOL) getData:(NSMutableData *)data;

@end

@interface DownloadData : NSObject

@property (nonatomic,weak) id<DownloadDataDelegate> delegate;

/**
 下载文件

 @param filePath <#filePath description#>
 @param vc       <#vc description#>
 */
-(void) downloadDataFilePath:(NSString *)filePath VC:(UIViewController *)vc;

@end
